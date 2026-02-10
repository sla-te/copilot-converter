<#
.SYNOPSIS
Install Awesome Copilot content as VS Code fallback artifacts.

.DESCRIPTION
Installs selected content from an awesome-copilot checkout into VS Code prompt/skill folders:
- `plugins/*/agents/*.md` -> `<prompts>/<name>.agent.md`
- `plugins/*/commands/*.md` -> `<prompts>/<name>.prompt.md`
- `skills/<skill-dir>` -> `<skills>/<skill-dir>`
- `instructions/*.instructions.md` -> `<prompts>/<name>.instructions.md`

This script understands awesome-copilot command wrappers where plugin command markdown
files point to real files under repo root (`prompts/`). Skills are sourced directly from
repo root `skills/`.

.EXAMPLE
pwsh -File ./scripts/install-vscode-fallback-awesome-copilot.ps1

.EXAMPLE
pwsh -File ./scripts/install-vscode-fallback-awesome-copilot.ps1 -Target Workspace -WorkspaceRoot C:\src\my-repo -Plugins csharp-dotnet-development,software-engineering-team
#>

[CmdletBinding()]
param(
    [string]$RepoRoot = "",
    [ValidateSet("Auto", "Local", "Remote")]
    [string]$SourceMode = "Auto",
    [string]$RemoteArchiveUrl = "https://github.com/github/awesome-copilot/archive/refs/heads/main.zip",
    [string]$SourceCacheRoot = "",
    [ValidateSet("Interactive", "Workspace", "UserVSCode", "Custom")]
    [string]$Target = "Interactive",
    [string]$WorkspaceRoot,
    [string]$PromptsPath,
    [string]$SkillsPath,
    [string[]]$Plugins,
    [switch]$IncludeAgents,
    [switch]$IncludeCommands,
    [switch]$IncludeSkills,
    [switch]$IncludeInstructions,
    [switch]$Force,
    [switch]$DryRun,
    [switch]$UpdateExisting,
    [string]$StateFilePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-WarnLine {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-Step {
    param([string]$Message)
    Write-Host "[STEP] $Message" -ForegroundColor Blue
}

function Write-SuccessLine {
    param([string]$Message)
    Write-Host "[OK]   $Message" -ForegroundColor Green
}

function Write-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host ("==== {0} ====" -f $Title) -ForegroundColor Magenta
}

function Write-KeyValueLine {
    param(
        [Parameter(Mandatory = $true)][string]$Label,
        [Parameter(Mandatory = $true)][string]$Value,
        [ValidateSet("Gray", "White", "Cyan", "Green", "Yellow", "Red")]
        [string]$ValueColor = "White"
    )

    Write-Host ("  {0}" -f $Label.PadRight(30, " ")) -NoNewline -ForegroundColor DarkGray
    Write-Host $Value -ForegroundColor $ValueColor
}

function Ensure-Directory {
    param([Parameter(Mandatory = $true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Get-CopilotConverterCacheRoot {
    param([string]$OverridePath)

    if (-not [string]::IsNullOrWhiteSpace($OverridePath)) {
        return $OverridePath
    }

    return Join-Path ([System.IO.Path]::GetTempPath()) "copilot-converter-awesome-copilot"
}

function Get-StringSha256 {
    param([Parameter(Mandatory = $true)][string]$InputText)

    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($InputText)
        $hashBytes = $sha.ComputeHash($bytes)
        return ([System.BitConverter]::ToString($hashBytes)).Replace("-", "").ToLowerInvariant()
    }
    finally {
        $sha.Dispose()
    }
}

function Get-HeaderValue {
    param(
        $Headers,
        [Parameter(Mandatory = $true)][string]$Name
    )

    if (-not $Headers) {
        return $null
    }

    $value = $null
    try {
        $value = $Headers[$Name]
    }
    catch {
    }

    if (-not $value) {
        try {
            $value = $Headers[$Name.ToLowerInvariant()]
        }
        catch {
        }
    }

    if ($value -is [System.Array]) {
        if ($value.Count -gt 0) {
            return [string]$value[0]
        }
        return $null
    }

    if ($value) {
        return [string]$value
    }

    return $null
}

function Resolve-PluginsRootFromRepoRoot {
    param([Parameter(Mandatory = $true)][string]$CandidateRepoRoot)

    if ([string]::IsNullOrWhiteSpace($CandidateRepoRoot)) {
        return $null
    }
    if (-not (Test-Path -LiteralPath $CandidateRepoRoot)) {
        return $null
    }
    $pluginsPath = Join-Path $CandidateRepoRoot "plugins"
    if (Test-Path -LiteralPath $pluginsPath) {
        return $pluginsPath
    }
    return $null
}

function Resolve-SourceRepoRoot {
    param(
        [string]$Override,
        [Parameter(Mandatory = $true)][string]$Mode,
        [Parameter(Mandatory = $true)][string]$ArchiveUrl,
        [string]$CacheRootOverride
    )

    $localCandidates = @()
    if (-not [string]::IsNullOrWhiteSpace($Override)) {
        $localCandidates += $Override
    }

    $scriptRepoRoot = $null
    if ($PSScriptRoot) {
        try {
            $scriptRepoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..") -ErrorAction Stop).Path
        }
        catch {
            $scriptRepoRoot = (Join-Path $PSScriptRoot "..")
        }

        $scriptRepoParent = Split-Path -Parent $scriptRepoRoot
        if (-not [string]::IsNullOrWhiteSpace($scriptRepoParent)) {
            # Prefer a neighboring awesome-copilot checkout when this script runs from copilot-converter.
            $localCandidates += (Join-Path $scriptRepoParent "awesome-copilot")
        }
    }

    # Prefer known awesome-copilot checkouts before falling back to current repo/cwd.
    $localCandidates += "/home/toor/awesome-copilot"
    $localCandidates += "/home/toor/code/awesome-copilot"

    if ($PSScriptRoot) {
        $localCandidates += (Join-Path $PSScriptRoot "..")
    }
    $localCandidates += (Get-Location).Path

    if ($Mode -in @("Auto", "Local")) {
        $seenCandidates = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($candidate in $localCandidates) {
            if ([string]::IsNullOrWhiteSpace($candidate)) {
                continue
            }
            $candidateText = [string]$candidate
            if (-not $seenCandidates.Add($candidateText)) {
                continue
            }
            if (-not (Test-Path -LiteralPath $candidate)) {
                continue
            }
            $resolvedCandidate = (Resolve-Path -LiteralPath $candidate).Path
            $pluginsPath = Resolve-PluginsRootFromRepoRoot -CandidateRepoRoot $resolvedCandidate
            if ($pluginsPath) {
                Write-Info "Using local source repository: $resolvedCandidate"
                return $resolvedCandidate
            }
        }

        if ($Mode -eq "Local") {
            throw "Local source mode requested, but no awesome-copilot plugins directory was found. Provide -RepoRoot or use -SourceMode Remote."
        }
    }

    if ($Mode -notin @("Auto", "Remote")) {
        throw "Unsupported source mode: $Mode"
    }

    $cacheRoot = Get-CopilotConverterCacheRoot -OverridePath $CacheRootOverride
    Ensure-Directory -Path $cacheRoot

    $urlHash = Get-StringSha256 -InputText $ArchiveUrl
    $cachePath = Join-Path $cacheRoot ("source-" + $urlHash)
    Ensure-Directory -Path $cachePath

    $zipPath = Join-Path $cachePath "source.zip"
    $extractPath = Join-Path $cachePath "extract"
    $metaPath = Join-Path $cachePath "metadata.json"

    $cacheMeta = $null
    if (Test-Path -LiteralPath $metaPath) {
        try {
            $cacheMeta = Get-Content -LiteralPath $metaPath -Raw | ConvertFrom-Json
        }
        catch {
            Write-WarnLine "Cache metadata at '$metaPath' is invalid. It will be refreshed."
        }
    }

    $hasCachedZip = Test-Path -LiteralPath $zipPath
    $remoteChanged = -not $hasCachedZip
    $headEtag = $null
    $headLastModified = $null

    if ($hasCachedZip) {
        try {
            Write-Info "Checking remote archive metadata (HEAD): $ArchiveUrl"
            $headResponse = Invoke-WebRequest -Uri $ArchiveUrl -Method Head -MaximumRedirection 5
            $headEtag = Get-HeaderValue -Headers $headResponse.Headers -Name "ETag"
            $headLastModified = Get-HeaderValue -Headers $headResponse.Headers -Name "Last-Modified"

            $cachedEtag = $null
            $cachedLastModified = $null
            if ($cacheMeta) {
                if ($cacheMeta.etag) { $cachedEtag = [string]$cacheMeta.etag }
                if ($cacheMeta.lastModified) { $cachedLastModified = [string]$cacheMeta.lastModified }
            }

            if ($headEtag -and $cachedEtag) {
                $remoteChanged = ($headEtag -ne $cachedEtag)
            }
            elseif ($headLastModified -and $cachedLastModified) {
                $remoteChanged = ($headLastModified -ne $cachedLastModified)
            }
            else {
                $remoteChanged = $false
            }
        }
        catch {
            Write-WarnLine "Remote metadata check failed; reusing cached archive. Error: $($_.Exception.Message)"
            $remoteChanged = $false
        }
    }

    if ($remoteChanged) {
        Write-Info "Downloading source archive: $ArchiveUrl"
        $downloadResponse = Invoke-WebRequest -Uri $ArchiveUrl -OutFile $zipPath -PassThru
        $downloadEtag = Get-HeaderValue -Headers $downloadResponse.Headers -Name "ETag"
        $downloadLastModified = Get-HeaderValue -Headers $downloadResponse.Headers -Name "Last-Modified"

        $cacheMetaOut = [PSCustomObject]@{
            remoteArchiveUrl = $ArchiveUrl
            etag             = if ($downloadEtag) { $downloadEtag } elseif ($headEtag) { $headEtag } else { $null }
            lastModified     = if ($downloadLastModified) { $downloadLastModified } elseif ($headLastModified) { $headLastModified } else { $null }
            downloadedAt     = (Get-Date).ToString("o")
        }
        ($cacheMetaOut | ConvertTo-Json -Depth 5) | Set-Content -LiteralPath $metaPath -Encoding UTF8
    }
    else {
        Write-Info "Using cached source archive: $zipPath"
    }

    $needsExtract = $remoteChanged -or -not (Test-Path -LiteralPath $extractPath)
    if (-not $needsExtract) {
        $existingRoots = @(Get-ChildItem -LiteralPath $extractPath -Directory -ErrorAction SilentlyContinue | Sort-Object Name)
        if ($existingRoots.Count -eq 0) {
            $needsExtract = $true
        }
        else {
            $existingPlugins = Resolve-PluginsRootFromRepoRoot -CandidateRepoRoot $existingRoots[0].FullName
            if (-not $existingPlugins) {
                $needsExtract = $true
            }
        }
    }

    if ($needsExtract) {
        if (Test-Path -LiteralPath $extractPath) {
            Remove-Item -LiteralPath $extractPath -Recurse -Force
        }
        Ensure-Directory -Path $extractPath
        Expand-Archive -LiteralPath $zipPath -DestinationPath $extractPath -Force
    }

    $extractedRoots = @(Get-ChildItem -LiteralPath $extractPath -Directory | Sort-Object Name)
    if ($extractedRoots.Count -eq 0) {
        throw "Archive extracted but no repository directory was found in cache path '$extractPath'."
    }

    $resolvedRepoRoot = $extractedRoots[0].FullName
    if (-not (Resolve-PluginsRootFromRepoRoot -CandidateRepoRoot $resolvedRepoRoot)) {
        throw "Downloaded/cached archive does not contain a 'plugins' directory under '$resolvedRepoRoot'."
    }

    Write-Info "Using cached source repository: $resolvedRepoRoot"
    return $resolvedRepoRoot
}

function Get-StateFilePath {
    param(
        [Parameter(Mandatory = $true)][string]$PromptsPath,
        [Parameter(Mandatory = $true)][string]$SkillsPath,
        [string]$OverridePath
    )

    if (-not [string]::IsNullOrWhiteSpace($OverridePath)) {
        return $OverridePath
    }

    $promptsParent = Split-Path -Parent $PromptsPath
    $skillsParent = Split-Path -Parent $SkillsPath
    if ($promptsParent -and $skillsParent -and $promptsParent -ieq $skillsParent) {
        return Join-Path $promptsParent "awesome-copilot-install-state.json"
    }
    return Join-Path $promptsParent "awesome-copilot-install-state.json"
}

function Read-InstallState {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return $null
    }

    try {
        return (Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json)
    }
    catch {
        throw "State file '$Path' could not be parsed as JSON."
    }
}

function Write-InstallState {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [Parameter(Mandatory = $true)][string]$PromptsPath,
        [Parameter(Mandatory = $true)][string]$SkillsPath,
        [array]$SelectedPlugins = @(),
        [array]$SelectedAgents = @(),
        [array]$SelectedCommands = @(),
        [array]$SelectedSkills = @(),
        [array]$SelectedInstructions = @(),
        [string]$SelectionMode = "",
        [bool]$IncludeAgents = $false,
        [bool]$IncludeCommands = $false,
        [bool]$IncludeSkills = $false,
        [bool]$IncludeInstructions = $false,
        [array]$InstalledPromptTargets = @(),
        [array]$InstalledSkillTargets = @()
    )

    if (-not $SelectedPlugins) { $SelectedPlugins = @() }
    if (-not $SelectedAgents) { $SelectedAgents = @() }
    if (-not $SelectedCommands) { $SelectedCommands = @() }
    if (-not $SelectedSkills) { $SelectedSkills = @() }
    if (-not $SelectedInstructions) { $SelectedInstructions = @() }
    if (-not $InstalledPromptTargets) { $InstalledPromptTargets = @() }
    if (-not $InstalledSkillTargets) { $InstalledSkillTargets = @() }

    $pluginNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($plugin in $SelectedPlugins) {
        if ($plugin -and -not [string]::IsNullOrWhiteSpace([string]$plugin.Name)) {
            [void]$pluginNames.Add([string]$plugin.Name)
        }
    }
    foreach ($item in $SelectedAgents) {
        if ($item -and -not [string]::IsNullOrWhiteSpace([string]$item.Plugin)) {
            [void]$pluginNames.Add([string]$item.Plugin)
        }
    }
    foreach ($item in $SelectedCommands) {
        if ($item -and -not [string]::IsNullOrWhiteSpace([string]$item.Plugin)) {
            [void]$pluginNames.Add([string]$item.Plugin)
        }
    }
    foreach ($item in $SelectedSkills) {
        if ($item -and -not [string]::IsNullOrWhiteSpace([string]$item.Plugin)) {
            [void]$pluginNames.Add([string]$item.Plugin)
        }
    }

    $pluginEntries = @()
    foreach ($pluginName in ($pluginNames | Sort-Object)) {
        $pluginEntries += [PSCustomObject]@{
            name     = $pluginName
            agents   = @($SelectedAgents | Where-Object { $_.Plugin -eq $pluginName } | ForEach-Object { $_.Stem } | Sort-Object -Unique)
            commands = @($SelectedCommands | Where-Object { $_.Plugin -eq $pluginName } | ForEach-Object { $_.Stem } | Sort-Object -Unique)
            skills   = @($SelectedSkills | Where-Object { $_.Plugin -eq $pluginName } | ForEach-Object { $_.Name } | Sort-Object -Unique)
        }
    }

    $state = [PSCustomObject]@{
        schemaVersion      = 2
        updatedAt          = (Get-Date).ToString("o")
        repoRoot           = $RepoRoot
        promptsPath        = $PromptsPath
        skillsPath         = $SkillsPath
        selection          = [PSCustomObject]@{
            mode                = $SelectionMode
            includeAgents       = $IncludeAgents
            includeCommands     = $IncludeCommands
            includeSkills       = $IncludeSkills
            includeInstructions = $IncludeInstructions
        }
        selectedArtifacts  = [PSCustomObject]@{
            agents       = @(
                $SelectedAgents |
                    ForEach-Object {
                        if ([string]::IsNullOrWhiteSpace([string]$_.Plugin)) { $_.Stem } else { "$($_.Plugin)/$($_.Stem)" }
                    } |
                    Sort-Object -Unique
            )
            prompts      = @(
                $SelectedCommands |
                    ForEach-Object {
                        if ([string]::IsNullOrWhiteSpace([string]$_.Plugin)) {
                            if ($_.Path) {
                                try {
                                    $resolvedPromptPath = (Resolve-Path -LiteralPath $_.Path -ErrorAction Stop).Path
                                    $resolvedRepoRootForPrompt = (Resolve-Path -LiteralPath $RepoRoot -ErrorAction Stop).Path
                                    if ($resolvedPromptPath.StartsWith($resolvedRepoRootForPrompt, [System.StringComparison]::OrdinalIgnoreCase)) {
                                        $resolvedPromptPath.Substring($resolvedRepoRootForPrompt.Length).TrimStart('\', '/').Replace('\', '/')
                                    }
                                    else {
                                        [System.IO.Path]::GetFileName($resolvedPromptPath)
                                    }
                                }
                                catch {
                                    [System.IO.Path]::GetFileName([string]$_.Path)
                                }
                            }
                            else {
                                $_.Stem
                            }
                        }
                        else {
                            "$($_.Plugin)/$($_.Stem)"
                        }
                    } |
                    Sort-Object -Unique
            )
            skills       = @(
                $SelectedSkills |
                    ForEach-Object {
                        if ([string]::IsNullOrWhiteSpace([string]$_.Plugin)) { $_.Name } else { "$($_.Plugin)/$($_.Name)" }
                    } |
                    Sort-Object -Unique
            )
            instructions = @($SelectedInstructions | ForEach-Object { $_.Name } | Sort-Object -Unique)
        }
        installedArtifacts = [PSCustomObject]@{
            promptTargets = @($InstalledPromptTargets | Sort-Object -Unique)
            skillTargets  = @($InstalledSkillTargets | Sort-Object -Unique)
        }
        plugins            = $pluginEntries
        instructions       = @($SelectedInstructions | ForEach-Object { $_.Name } | Sort-Object -Unique)
    }

    Ensure-Directory -Path (Split-Path -Parent $Path)
    ($state | ConvertTo-Json -Depth 8) | Set-Content -LiteralPath $Path -Encoding UTF8
}

function Get-VSCodeUserRoot {
    if ($env:OS -eq "Windows_NT") {
        if (-not $env:APPDATA) {
            throw "APPDATA is not set. Provide -PromptsPath and -SkillsPath (Target=Custom)."
        }
        return Join-Path $env:APPDATA "Code\User"
    }

    $homePath = [Environment]::GetFolderPath("UserProfile")
    if ([string]::IsNullOrWhiteSpace($homePath)) {
        $homePath = $HOME
    }
    $macUserRoot = Join-Path $homePath "Library/Application Support/Code/User"
    if (Test-Path -LiteralPath (Split-Path -Parent $macUserRoot)) {
        return $macUserRoot
    }
    return Join-Path $homePath ".config/Code/User"
}

function Parse-SelectionInput {
    param(
        [AllowNull()][AllowEmptyString()][string]$InputValue = "",
        [Parameter(Mandatory = $true)][int]$MaxIndex
    )

    $raw = [string]$InputValue
    if ([string]::IsNullOrWhiteSpace($raw)) {
        Write-Output -NoEnumerate @()
        return
    }
    $raw = $raw.Trim().ToLowerInvariant()
    if ($raw -eq "all" -or $raw -eq "*") {
        return @(0..($MaxIndex - 1))
    }

    $indexes = [System.Collections.Generic.HashSet[int]]::new()
    foreach ($token in ($raw -split ",")) {
        $part = $token.Trim()
        if ([string]::IsNullOrWhiteSpace($part)) {
            continue
        }
        if ($part -match "^(\d+)-(\d+)$") {
            $start = [int]$Matches[1]
            $end = [int]$Matches[2]
            if ($start -lt 1 -or $end -lt 1 -or $start -gt $MaxIndex -or $end -gt $MaxIndex) {
                throw "Range '$part' is out of bounds (1..$MaxIndex)."
            }
            if ($end -lt $start) {
                throw "Range '$part' is invalid (end < start)."
            }
            for ($i = $start; $i -le $end; $i++) {
                [void]$indexes.Add($i - 1)
            }
            continue
        }
        if ($part -match "^\d+$") {
            $idx = [int]$part
            if ($idx -lt 1 -or $idx -gt $MaxIndex) {
                throw "Index '$idx' is out of bounds (1..$MaxIndex)."
            }
            [void]$indexes.Add($idx - 1)
            continue
        }
        throw "Unsupported token '$part'. Use numbers, ranges (for example 2-5), or 'all'."
    }
    Write-Output -NoEnumerate @($indexes | Sort-Object)
    return
}

function Test-InteractiveConsole {
    try {
        return (-not [Console]::IsInputRedirected) -and (-not [Console]::IsOutputRedirected)
    }
    catch {
        return $false
    }
}

function Test-GoBackKeyPress {
    param([Parameter(Mandatory = $true)]$KeyInfo)

    if ($KeyInfo.Key -eq [ConsoleKey]::Backspace -or $KeyInfo.Key -eq [ConsoleKey]::Delete) {
        return $true
    }
    if (($KeyInfo.Key -eq [ConsoleKey]::H) -and (($KeyInfo.Modifiers -band [ConsoleModifiers]::Control) -ne 0)) {
        return $true
    }
    if ([int]$KeyInfo.KeyChar -eq 8) {
        return $true
    }
    if ($KeyInfo.KeyChar -eq "b" -or $KeyInfo.KeyChar -eq "B" -or $KeyInfo.KeyChar -eq "q" -or $KeyInfo.KeyChar -eq "Q") {
        return $true
    }

    return $false
}

function Select-IndicesFromList {
    param(
        [Parameter(Mandatory = $true)][array]$Items,
        [Parameter(Mandatory = $true)][string]$Label,
        [switch]$AllowEmpty,
        [switch]$PreselectAll,
        [switch]$AllowGoBack,
        [int[]]$PreselectedIndexes = @()
    )

    if ($Items.Count -eq 0) {
        Write-Output -NoEnumerate @()
        return
    }

    if (-not (Test-InteractiveConsole)) {
        for ($i = 0; $i -lt $Items.Count; $i++) {
            $n = $i + 1
            Write-Host ("[{0}] {1}" -f $n.ToString().PadLeft(2, " "), $Items[$i])
        }
        while ($true) {
            $suffix = if ($AllowEmpty) { " (Enter to skip)" } else { "" }
            $answerRaw = Read-Host "$Label (comma/range/all)$suffix"
            $answerText = if ($null -eq $answerRaw) { "" } else { [string]$answerRaw }
            $answerLower = $answerText.Trim().ToLowerInvariant()
            if ($AllowGoBack -and ($answerLower -in @("b", "q", "back"))) {
                return $null
            }
            if ($AllowEmpty -and [string]::IsNullOrWhiteSpace($answerText)) {
                Write-Output -NoEnumerate @()
                return
            }
            try {
                return Parse-SelectionInput -InputValue $answerText -MaxIndex $Items.Count
            }
            catch {
                Write-WarnLine $_.Exception.Message
            }
        }
    }

    $selected = [bool[]]::new($Items.Count)
    if ($PreselectAll) {
        for ($i = 0; $i -lt $selected.Length; $i++) {
            $selected[$i] = $true
        }
    }
    else {
        foreach ($idx in $PreselectedIndexes) {
            if ($idx -ge 0 -and $idx -lt $selected.Length) {
                $selected[$idx] = $true
            }
        }
    }

    $cursor = 0
    $offset = 0
    $headerLines = 6
    $minWidth = 40

    while ($true) {
        $windowWidth = 120
        $windowHeight = 30
        try {
            $windowWidth = [Console]::WindowWidth
            $windowHeight = [Console]::WindowHeight
        }
        catch {
            $windowWidth = 120
            $windowHeight = 30
        }

        $width = [Math]::Max($windowWidth - 1, $minWidth)
        $pageSize = $windowHeight - $headerLines - 1
        if ($pageSize -lt 1) { $pageSize = 1 }

        if ($cursor -lt $offset) { $offset = $cursor }
        elseif ($cursor -ge ($offset + $pageSize)) { $offset = $cursor - $pageSize + 1 }
        if ($offset -lt 0) { $offset = 0 }
        if ($offset -gt [Math]::Max($Items.Count - $pageSize, 0)) { $offset = [Math]::Max($Items.Count - $pageSize, 0) }

        Clear-Host
        Write-Host $Label -ForegroundColor Cyan
        if ($AllowGoBack) {
            Write-Host "Use Up/Down to move, Space to toggle, A=toggle all, I=invert, PgUp/PgDn/Home/End to navigate, Enter to confirm, Esc to clear, Backspace/Delete/Ctrl+H/B/Q to go back" -ForegroundColor DarkGray
        }
        else {
            Write-Host "Use Up/Down to move, Space to toggle, A=toggle all, I=invert, PgUp/PgDn/Home/End to navigate, Enter to confirm, Esc to clear" -ForegroundColor DarkGray
        }
        $selectedCount = 0
        for ($i = 0; $i -lt $selected.Length; $i++) {
            if ($selected[$i]) { $selectedCount++ }
        }
        Write-Host ("Selected {0}/{1}" -f $selectedCount, $Items.Count) -ForegroundColor DarkGray
        Write-Host ""

        $end = [Math]::Min($offset + $pageSize - 1, $Items.Count - 1)
        for ($i = $offset; $i -le $end; $i++) {
            $pointer = if ($i -eq $cursor) { ">" } else { " " }
            $check = if ($selected[$i]) { "[x]" } else { "[ ]" }
            $lineText = "$pointer $check $($Items[$i])"
            if ($lineText.Length -gt $width) {
                $lineText = $lineText.Substring(0, $width - 3) + "..."
            }
            [Console]::WriteLine($lineText)
        }

        $done = $false
        $key = [Console]::ReadKey($true)
        if ($AllowGoBack -and (Test-GoBackKeyPress -KeyInfo $key)) {
            return $null
        }
        switch ($key.Key) {
            "UpArrow" { if ($cursor -gt 0) { $cursor-- } }
            "DownArrow" { if ($cursor -lt ($Items.Count - 1)) { $cursor++ } }
            "PageUp" { $cursor = [Math]::Max($cursor - $pageSize, 0) }
            "PageDown" { $cursor = [Math]::Min($cursor + $pageSize, $Items.Count - 1) }
            "Home" { $cursor = 0 }
            "End" { $cursor = $Items.Count - 1 }
            "Spacebar" { $selected[$cursor] = -not $selected[$cursor] }
            "Enter" { $done = $true }
            "Escape" {
                if ($AllowEmpty) {
                    for ($i = 0; $i -lt $selected.Length; $i++) { $selected[$i] = $false }
                    $done = $true
                }
            }
        }

        if ($done) { break }

        if ($key.KeyChar -eq "a" -or $key.KeyChar -eq "A") {
            $allSelected = $true
            for ($i = 0; $i -lt $selected.Length; $i++) {
                if (-not $selected[$i]) { $allSelected = $false; break }
            }
            for ($i = 0; $i -lt $selected.Length; $i++) { $selected[$i] = -not $allSelected }
        }
        if ($key.KeyChar -eq "i" -or $key.KeyChar -eq "I") {
            for ($i = 0; $i -lt $selected.Length; $i++) { $selected[$i] = -not $selected[$i] }
        }
    }

    $indexes = @()
    for ($i = 0; $i -lt $selected.Length; $i++) {
        if ($selected[$i]) { $indexes += $i }
    }
    Write-Host ""
    Write-Output -NoEnumerate $indexes
    return
}

function Select-IndexFromList {
    param(
        [Parameter(Mandatory = $true)][array]$Items,
        [Parameter(Mandatory = $true)][string]$Label,
        [switch]$AllowGoBack,
        [int]$PreselectedIndex = 0
    )

    if ($Items.Count -eq 0) {
        throw "No items available for selection."
    }

    if ($PreselectedIndex -lt 0 -or $PreselectedIndex -ge $Items.Count) {
        $PreselectedIndex = 0
    }

    if (-not (Test-InteractiveConsole)) {
        for ($i = 0; $i -lt $Items.Count; $i++) {
            $n = $i + 1
            Write-Host ("[{0}] {1}" -f $n.ToString().PadLeft(2, " "), $Items[$i])
        }
        while ($true) {
            $answerRaw = Read-Host "$Label (single number)"
            $answerText = if ($null -eq $answerRaw) { "" } else { [string]$answerRaw }
            if ($AllowGoBack -and ($answerText.Trim().ToLowerInvariant() -in @("b", "q", "back"))) {
                return $null
            }
            if ($answerText -match "^\d+$") {
                $idx = [int]$answerText
                if ($idx -ge 1 -and $idx -le $Items.Count) {
                    return ($idx - 1)
                }
            }
            Write-WarnLine "Use a single number from 1 to $($Items.Count)."
        }
    }

    $cursor = $PreselectedIndex
    $offset = 0
    $headerLines = 5
    $minWidth = 40

    while ($true) {
        $windowWidth = 120
        $windowHeight = 30
        try {
            $windowWidth = [Console]::WindowWidth
            $windowHeight = [Console]::WindowHeight
        }
        catch {
            $windowWidth = 120
            $windowHeight = 30
        }

        $width = [Math]::Max($windowWidth - 1, $minWidth)
        $pageSize = $windowHeight - $headerLines - 1
        if ($pageSize -lt 1) { $pageSize = 1 }

        if ($cursor -lt $offset) { $offset = $cursor }
        elseif ($cursor -ge ($offset + $pageSize)) { $offset = $cursor - $pageSize + 1 }
        if ($offset -lt 0) { $offset = 0 }
        if ($offset -gt [Math]::Max($Items.Count - $pageSize, 0)) { $offset = [Math]::Max($Items.Count - $pageSize, 0) }

        Clear-Host
        Write-Host $Label -ForegroundColor Cyan
        if ($AllowGoBack) {
            Write-Host "Use Up/Down to move, Enter to select, Backspace/Delete/Ctrl+H/B/Q to go back" -ForegroundColor DarkGray
        }
        else {
            Write-Host "Use Up/Down to move, Enter to select" -ForegroundColor DarkGray
        }
        Write-Host ""

        $end = [Math]::Min($offset + $pageSize - 1, $Items.Count - 1)
        for ($i = $offset; $i -le $end; $i++) {
            $pointer = if ($i -eq $cursor) { ">" } else { " " }
            $lineText = "$pointer $($Items[$i])"
            if ($lineText.Length -gt $width) {
                $lineText = $lineText.Substring(0, $width - 3) + "..."
            }
            [Console]::WriteLine($lineText)
        }

        $key = [Console]::ReadKey($true)
        if ($AllowGoBack -and (Test-GoBackKeyPress -KeyInfo $key)) {
            return $null
        }
        switch ($key.Key) {
            "UpArrow" { if ($cursor -gt 0) { $cursor-- } }
            "DownArrow" { if ($cursor -lt ($Items.Count - 1)) { $cursor++ } }
            "PageUp" { $cursor = [Math]::Max($cursor - $pageSize, 0) }
            "PageDown" { $cursor = [Math]::Min($cursor + $pageSize, $Items.Count - 1) }
            "Home" { $cursor = 0 }
            "End" { $cursor = $Items.Count - 1 }
            "Enter" { return $cursor }
        }
    }
}

function Select-RunConfiguration {
    param(
        [Parameter(Mandatory = $true)][bool]$SupportsInstructions
    )

    if (-not (Test-InteractiveConsole)) {
        return $null
    }

    while ($true) {
        $contentModes = @(
            "Plugins",
            "Agents",
            "Skills",
            "Prompts"
        )
        $contentModeIndex = Select-IndexFromList -Items $contentModes -Label "Select content type to install" -AllowGoBack
        if ($null -eq $contentModeIndex) {
            return $null
        }

        $installByPlugin = $false
        $includeAgents = $false
        $includeSkills = $false
        $includePrompts = $false

        switch ($contentModeIndex) {
            0 {
                $installByPlugin = $true
                $includeAgents = $true
                $includeSkills = $true
                $includePrompts = $true
            }
            1 { $includeAgents = $true }
            2 { $includeSkills = $true }
            3 { $includePrompts = $true }
        }

        $includeInstructions = $false

        return [PSCustomObject]@{
            SelectionMode       = ($contentModes[$contentModeIndex].ToLowerInvariant())
            InstallByPlugin     = $installByPlugin
            IncludeAgents       = $includeAgents
            IncludePrompts      = $includePrompts
            IncludeSkills       = $includeSkills
            IncludeInstructions = $includeInstructions
            UpdateExisting      = $false
            DryRun              = $false
            Force               = $true
        }
    }
}

function Resolve-SelectionModeLabel {
    param(
        [Parameter(Mandatory = $true)][bool]$InstallByPlugin,
        [Parameter(Mandatory = $true)][bool]$IncludeAgents,
        [Parameter(Mandatory = $true)][bool]$IncludeCommands,
        [Parameter(Mandatory = $true)][bool]$IncludeSkills
    )

    if ($InstallByPlugin) {
        return "plugins"
    }

    $enabled = @()
    if ($IncludeAgents) { $enabled += "agents" }
    if ($IncludeCommands) { $enabled += "prompts" }
    if ($IncludeSkills) { $enabled += "skills" }

    if ($enabled.Count -eq 1) {
        return $enabled[0]
    }
    if ($enabled.Count -eq 0) {
        return "none"
    }
    return "mixed"
}

function Get-StateInstructionNames {
    param($State)

    $nameSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    if (-not $State) {
        return @()
    }

    if (($State.PSObject.Properties.Name -contains "selectedArtifacts") -and $State.selectedArtifacts) {
        if ($State.selectedArtifacts.PSObject.Properties.Name -contains "instructions") {
            foreach ($name in @($State.selectedArtifacts.instructions)) {
                if (-not [string]::IsNullOrWhiteSpace([string]$name)) {
                    [void]$nameSet.Add(([string]$name).Trim())
                }
            }
        }
    }

    if ($State.PSObject.Properties.Name -contains "instructions") {
        foreach ($name in @($State.instructions)) {
            if (-not [string]::IsNullOrWhiteSpace([string]$name)) {
                [void]$nameSet.Add(([string]$name).Trim())
            }
        }
    }

    return @($nameSet | Sort-Object)
}

function Get-StateArtifactTokenSet {
    param(
        $State,
        [Parameter(Mandatory = $true)][ValidateSet("agents", "prompts", "skills")] [string]$Kind
    )

    $tokens = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    if (-not $State) {
        return @()
    }

    if (($State.PSObject.Properties.Name -contains "selectedArtifacts") -and $State.selectedArtifacts) {
        if ($State.selectedArtifacts.PSObject.Properties.Name -contains $Kind) {
            foreach ($token in @($State.selectedArtifacts.$Kind)) {
                if (-not [string]::IsNullOrWhiteSpace([string]$token)) {
                    [void]$tokens.Add(([string]$token).Trim())
                }
            }
        }
    }

    if ($State.PSObject.Properties.Name -contains "plugins") {
        $legacyProperty = $Kind
        if ($Kind -eq "prompts") {
            $legacyProperty = "commands"
        }
        foreach ($entry in @($State.plugins)) {
            if (-not $entry -or [string]::IsNullOrWhiteSpace([string]$entry.name)) {
                continue
            }
            if (-not ($entry.PSObject.Properties.Name -contains $legacyProperty)) {
                continue
            }
            foreach ($token in @($entry.$legacyProperty)) {
                if ([string]::IsNullOrWhiteSpace([string]$token)) {
                    continue
                }
                [void]$tokens.Add(("{0}/{1}" -f ([string]$entry.name).Trim(), ([string]$token).Trim()))
            }
        }
    }

    return @($tokens | ForEach-Object { $_ })
}

function Get-CandidateTokenSet {
    param(
        $Candidate,
        [Parameter(Mandatory = $true)][ValidateSet("agents", "prompts", "skills")] [string]$Kind,
        [Parameter(Mandatory = $true)][string]$RepoRoot
    )

    $tokens = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    if (-not $Candidate) {
        return @()
    }

    $pluginName = $null
    if (($Candidate.PSObject.Properties.Name -contains "Plugin") -and -not [string]::IsNullOrWhiteSpace([string]$Candidate.Plugin)) {
        $pluginName = ([string]$Candidate.Plugin).Trim()
    }

    switch ($Kind) {
        "agents" {
            if (-not [string]::IsNullOrWhiteSpace($pluginName)) {
                [void]$tokens.Add("$pluginName/$($Candidate.Stem)")
            }
            elseif (-not [string]::IsNullOrWhiteSpace([string]$Candidate.Stem)) {
                [void]$tokens.Add(([string]$Candidate.Stem).Trim())
            }
        }
        "prompts" {
            if (-not [string]::IsNullOrWhiteSpace($pluginName)) {
                [void]$tokens.Add("$pluginName/$($Candidate.Stem)")
            }
            else {
                if (($Candidate.PSObject.Properties.Name -contains "Path") -and -not [string]::IsNullOrWhiteSpace([string]$Candidate.Path)) {
                    try {
                        $resolvedPath = (Resolve-Path -LiteralPath ([string]$Candidate.Path) -ErrorAction Stop).Path
                        $resolvedRepoRoot = (Resolve-Path -LiteralPath $RepoRoot -ErrorAction Stop).Path
                        if ($resolvedPath.StartsWith($resolvedRepoRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
                            $relativePath = $resolvedPath.Substring($resolvedRepoRoot.Length).TrimStart('\', '/').Replace('\', '/')
                            if (-not [string]::IsNullOrWhiteSpace($relativePath)) {
                                [void]$tokens.Add($relativePath)
                            }
                        }
                        [void]$tokens.Add([System.IO.Path]::GetFileName($resolvedPath))
                    }
                    catch {
                    }
                }
                if (($Candidate.PSObject.Properties.Name -contains "Display") -and -not [string]::IsNullOrWhiteSpace([string]$Candidate.Display)) {
                    [void]$tokens.Add(([string]$Candidate.Display).Trim())
                }
                if (($Candidate.PSObject.Properties.Name -contains "Stem") -and -not [string]::IsNullOrWhiteSpace([string]$Candidate.Stem)) {
                    [void]$tokens.Add(([string]$Candidate.Stem).Trim())
                }
            }
        }
        "skills" {
            if (-not [string]::IsNullOrWhiteSpace($pluginName)) {
                [void]$tokens.Add("$pluginName/$($Candidate.Name)")
            }
            elseif (($Candidate.PSObject.Properties.Name -contains "Name") -and -not [string]::IsNullOrWhiteSpace([string]$Candidate.Name)) {
                [void]$tokens.Add(([string]$Candidate.Name).Trim())
            }
        }
    }

    return @($tokens | ForEach-Object { $_ })
}

function Get-PreselectedIndexesFromState {
    param(
        $State,
        [Parameter(Mandatory = $true)][array]$Candidates,
        [Parameter(Mandatory = $true)][ValidateSet("agents", "prompts", "skills")] [string]$Kind,
        [Parameter(Mandatory = $true)][string]$RepoRoot
    )

    $candidateList = @($Candidates)

    if (-not $State -or $candidateList.Count -eq 0) {
        return @()
    }

    $stateTokenSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($stateToken in @(Get-StateArtifactTokenSet -State $State -Kind $Kind)) {
        if (-not [string]::IsNullOrWhiteSpace([string]$stateToken)) {
            [void]$stateTokenSet.Add(([string]$stateToken).Trim())
        }
    }
    if ($stateTokenSet.Count -eq 0) {
        return @()
    }

    $indexes = @()
    for ($i = 0; $i -lt $candidateList.Count; $i++) {
        $candidateTokens = @(Get-CandidateTokenSet -Candidate $candidateList[$i] -Kind $Kind -RepoRoot $RepoRoot)
        foreach ($token in $candidateTokens) {
            if (-not [string]::IsNullOrWhiteSpace([string]$token) -and $stateTokenSet.Contains(([string]$token).Trim())) {
                $indexes += $i
                break
            }
        }
    }
    return $indexes
}

function Resolve-MarkdownWrapperTarget {
    param(
        [Parameter(Mandatory = $true)][string]$SourceFile,
        [Parameter(Mandatory = $true)][string]$RepoRoot
    )

    if (-not (Test-Path -LiteralPath $SourceFile)) {
        return $null
    }

    $content = Get-Content -LiteralPath $SourceFile -Raw
    $body = $content
    if ($body -match "(?s)^---\r?\n.*?\r?\n---\r?\n(?<rest>.*)$") {
        $body = $Matches["rest"]
    }
    $trimmed = $body.Trim()

    $singleLink = [regex]::Match($trimmed, "^\s*\[[^\]]+\]\(([^)]+)\)\s*$")
    if (-not $singleLink.Success) {
        return $null
    }

    $target = $singleLink.Groups[1].Value.Trim()
    if ([string]::IsNullOrWhiteSpace($target)) {
        return $null
    }
    if ($target.StartsWith("http://") -or $target.StartsWith("https://") -or $target.StartsWith("mailto:") -or $target.StartsWith("#")) {
        return $null
    }

    $pathPart = $target.Split("#")[0].Trim()
    if ([string]::IsNullOrWhiteSpace($pathPart)) {
        return $null
    }

    $candidate = Join-Path (Split-Path -Parent $SourceFile) $pathPart
    try {
        $resolved = (Resolve-Path -LiteralPath $candidate -ErrorAction Stop).Path
    }
    catch {
        return $null
    }

    $repoResolved = (Resolve-Path -LiteralPath $RepoRoot).Path
    if (-not $resolved.StartsWith($repoResolved, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $null
    }

    return $resolved
}

function Resolve-LinkedMarkdownFile {
    param(
        [Parameter(Mandatory = $true)][string]$SourceFile,
        [Parameter(Mandatory = $true)][string]$RepoRoot
    )

    $target = Resolve-MarkdownWrapperTarget -SourceFile $SourceFile -RepoRoot $RepoRoot
    if ($target -and (Test-Path -LiteralPath $target) -and -not (Get-Item -LiteralPath $target).PSIsContainer) {
        return $target
    }
    return $SourceFile
}

function Resolve-SkillSourceDir {
    param(
        [Parameter(Mandatory = $true)][string]$PluginSkillDir,
        [Parameter(Mandatory = $true)][string]$RepoRoot
    )

    if (-not (Test-Path -LiteralPath $PluginSkillDir)) {
        return $null
    }

    $repoResolved = (Resolve-Path -LiteralPath $RepoRoot -ErrorAction Stop).Path
    $candidateDirs = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    $item = Get-Item -LiteralPath $PluginSkillDir -Force -ErrorAction Stop

    if ($item.PSIsContainer) {
        $skillFile = Join-Path $item.FullName "SKILL.md"
        if (-not (Test-Path -LiteralPath $skillFile)) {
            return $null
        }

        $resolvedSkillFile = Resolve-LinkedMarkdownFile -SourceFile $skillFile -RepoRoot $RepoRoot
        $sourceDir = Split-Path -Parent $resolvedSkillFile
        try {
            $resolvedSourceDir = (Resolve-Path -LiteralPath $sourceDir -ErrorAction Stop).Path
            [void]$candidateDirs.Add($resolvedSourceDir)
        }
        catch {
        }
    }
    else {
        # Symlink-to-dir entries can resolve directly to the real skill directory.
        try {
            $resolvedEntryPath = (Resolve-Path -LiteralPath $item.FullName -ErrorAction Stop).Path
            $resolvedEntryItem = Get-Item -LiteralPath $resolvedEntryPath -Force -ErrorAction Stop
            if ($resolvedEntryItem.PSIsContainer) {
                [void]$candidateDirs.Add($resolvedEntryItem.FullName)
            }
            else {
                [void]$candidateDirs.Add((Split-Path -Parent $resolvedEntryItem.FullName))
            }
        }
        catch {
        }

        # Markdown wrappers that contain a single link to SKILL.md.
        $linkedTarget = Resolve-MarkdownWrapperTarget -SourceFile $item.FullName -RepoRoot $RepoRoot
        if ($linkedTarget) {
            try {
                $linkedItem = Get-Item -LiteralPath $linkedTarget -Force -ErrorAction Stop
                if ($linkedItem.PSIsContainer) {
                    [void]$candidateDirs.Add($linkedItem.FullName)
                }
                else {
                    [void]$candidateDirs.Add((Split-Path -Parent $linkedItem.FullName))
                }
            }
            catch {
            }
        }

        # Git symlinks in ZIP archives can materialize as text files with a relative path payload.
        try {
            $rawContent = (Get-Content -LiteralPath $item.FullName -Raw -ErrorAction Stop).Trim()
            $pathPart = $rawContent.Split("#")[0].Trim()
            if (
                -not [string]::IsNullOrWhiteSpace($pathPart) -and
                -not ($pathPart -match "^(https?://|mailto:|#)")
            ) {
                $candidatePath = Join-Path (Split-Path -Parent $item.FullName) $pathPart
                try {
                    $resolvedCandidatePath = (Resolve-Path -LiteralPath $candidatePath -ErrorAction Stop).Path
                    $resolvedCandidateItem = Get-Item -LiteralPath $resolvedCandidatePath -Force -ErrorAction Stop
                    if ($resolvedCandidateItem.PSIsContainer) {
                        [void]$candidateDirs.Add($resolvedCandidateItem.FullName)
                    }
                    else {
                        [void]$candidateDirs.Add((Split-Path -Parent $resolvedCandidateItem.FullName))
                    }
                }
                catch {
                }
            }
        }
        catch {
        }
    }

    foreach ($dir in $candidateDirs) {
        if ([string]::IsNullOrWhiteSpace([string]$dir)) {
            continue
        }
        $resolvedDir = $null
        try {
            $resolvedDir = (Resolve-Path -LiteralPath $dir -ErrorAction Stop).Path
        }
        catch {
            continue
        }
        if (-not $resolvedDir.StartsWith($repoResolved, [System.StringComparison]::OrdinalIgnoreCase)) {
            continue
        }
        if (Test-Path -LiteralPath (Join-Path $resolvedDir "SKILL.md")) {
            return $resolvedDir
        }
    }

    # No valid skill directory could be resolved from this plugin skill entry.
    return $null
}

function New-AgentCandidate {
    param(
        [Parameter(Mandatory = $true)][string]$Plugin,
        [Parameter(Mandatory = $true)]$FileInfo
    )
    $stem = [System.IO.Path]::GetFileNameWithoutExtension($FileInfo.Name)
    return [PSCustomObject]@{
        Plugin  = $Plugin
        Stem    = $stem
        Path    = $FileInfo.FullName
        Display = $stem
        Label   = "$Plugin/$stem"
    }
}

function New-CommandCandidate {
    param(
        [Parameter(Mandatory = $true)][string]$Plugin,
        [Parameter(Mandatory = $true)]$FileInfo,
        [Parameter(Mandatory = $true)][string]$RepoRoot
    )
    $stem = [System.IO.Path]::GetFileNameWithoutExtension($FileInfo.Name)
    $resolvedSource = Resolve-LinkedMarkdownFile -SourceFile $FileInfo.FullName -RepoRoot $RepoRoot
    return [PSCustomObject]@{
        Plugin  = $Plugin
        Stem    = $stem
        Path    = $resolvedSource
        Display = $stem
        Label   = "$Plugin/$stem"
    }
}

function New-PromptRootCandidate {
    param(
        [Parameter(Mandatory = $true)]$FileInfo,
        [Parameter(Mandatory = $true)][string]$RepoRoot
    )

    $stem = [System.IO.Path]::GetFileNameWithoutExtension($FileInfo.Name)
    $repoResolved = (Resolve-Path -LiteralPath $RepoRoot).Path
    $fullPath = (Resolve-Path -LiteralPath $FileInfo.FullName).Path
    $relative = $FileInfo.Name
    if ($fullPath.StartsWith($repoResolved, [System.StringComparison]::OrdinalIgnoreCase)) {
        $relative = $fullPath.Substring($repoResolved.Length).TrimStart('\', '/').Replace('\', '/')
    }

    return [PSCustomObject]@{
        Plugin  = ""
        Stem    = $stem
        Path    = $fullPath
        Display = $relative
        Label   = $relative
    }
}

function New-SkillCandidate {
    param(
        [AllowEmptyString()][string]$Plugin = "",
        [Parameter(Mandatory = $true)]$DirInfo,
        [Parameter(Mandatory = $true)][string]$RepoRoot
    )
    $sourceDir = Resolve-SkillSourceDir -PluginSkillDir $DirInfo.FullName -RepoRoot $RepoRoot
    if (-not $sourceDir) {
        return $null
    }
    return [PSCustomObject]@{
        Plugin  = $Plugin
        Name    = $DirInfo.Name
        Path    = $sourceDir
        Display = $DirInfo.Name
        Label   = if ([string]::IsNullOrWhiteSpace($Plugin)) { $DirInfo.Name } else { "$Plugin/$($DirInfo.Name)" }
    }
}

function Get-RootSkillCandidates {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot
    )

    $skillsRoot = Join-Path $RepoRoot "skills"
    if (-not (Test-Path -LiteralPath $skillsRoot)) {
        return @()
    }

    $candidates = @()
    foreach ($skillDir in (Get-ChildItem -LiteralPath $skillsRoot -Directory | Sort-Object Name)) {
        $candidate = New-SkillCandidate -Plugin "" -DirInfo $skillDir -RepoRoot $RepoRoot
        if ($candidate) {
            $candidates += $candidate
        }
    }
    return $candidates
}

function New-InstructionCandidate {
    param(
        [Parameter(Mandatory = $true)]$FileInfo,
        [Parameter(Mandatory = $true)][string]$RepoRoot
    )
    $resolvedSource = Resolve-LinkedMarkdownFile -SourceFile $FileInfo.FullName -RepoRoot $RepoRoot
    return [PSCustomObject]@{
        Name    = $FileInfo.Name
        Path    = $resolvedSource
        Display = $FileInfo.Name
        Label   = $FileInfo.Name
    }
}

function Select-ObjectsByPlugin {
    param(
        [Parameter(Mandatory = $true)][array]$Candidates,
        [Parameter(Mandatory = $true)][array]$SelectedPluginObjects,
        [Parameter(Mandatory = $true)][string]$KindLabel,
        [Parameter(Mandatory = $true)][bool]$ExplicitPluginList,
        [switch]$AllowGoBack
    )

    $candidateList = @($Candidates)
    if ($candidateList.Count -eq 0) { return @() }
    if ($ExplicitPluginList) { return $candidateList }

    $result = @()
    foreach ($plugin in $SelectedPluginObjects) {
        $pluginName = $plugin.Name
        $pluginCandidates = @($candidateList | Where-Object { $_.Plugin -eq $pluginName })
        if ($pluginCandidates.Count -eq 0) { continue }
        $displayItems = @($pluginCandidates | ForEach-Object { $_.Display })
        $pickedIndexes = Select-IndicesFromList -Items $displayItems -Label "[$pluginName] Select ${KindLabel} to install" -AllowEmpty -PreselectAll -AllowGoBack:$AllowGoBack
        if ($null -eq $pickedIndexes) {
            return $null
        }
        foreach ($idx in $pickedIndexes) {
            $result += $pluginCandidates[$idx]
        }
    }
    return $result
}

function Select-CandidatesGlobal {
    param(
        [Parameter(Mandatory = $true)][array]$Candidates,
        [Parameter(Mandatory = $true)][string]$Label,
        [switch]$AllowEmpty,
        [switch]$AllowGoBack,
        [int[]]$PreselectedIndexes = @()
    )

    $candidateList = @($Candidates)
    if ($candidateList.Count -eq 0) {
        return @()
    }

    $labels = @($candidateList | ForEach-Object { $_.Label })
    $indexes = Select-IndicesFromList -Items $labels -Label $Label -AllowEmpty:$AllowEmpty -AllowGoBack:$AllowGoBack -PreselectedIndexes $PreselectedIndexes
    if ($null -eq $indexes) {
        return $null
    }

    $selected = @()
    foreach ($idx in $indexes) {
        $selected += $candidateList[$idx]
    }
    Write-Output -NoEnumerate $selected
    return
}

function Build-CandidatesFromPlugins {
    param(
        [Parameter(Mandatory = $true)][array]$Plugins,
        [Parameter(Mandatory = $true)][bool]$IncludeAgents,
        [Parameter(Mandatory = $true)][bool]$IncludeCommands,
        [Parameter(Mandatory = $true)][bool]$IncludeSkills,
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [array]$RootSkillCandidates = @()
    )

    $agents = @()
    $commands = @()
    $skills = @()

    foreach ($plugin in $Plugins) {
        if ($IncludeAgents) {
            foreach ($f in $plugin.AgentFiles) { $agents += New-AgentCandidate -Plugin $plugin.Name -FileInfo $f }
        }
        if ($IncludeCommands) {
            foreach ($f in $plugin.CommandFiles) { $commands += New-CommandCandidate -Plugin $plugin.Name -FileInfo $f -RepoRoot $RepoRoot }
        }
    }

    if ($IncludeSkills -and $RootSkillCandidates -and $RootSkillCandidates.Count -gt 0) {
        $skills = @($RootSkillCandidates)
    }

    return [PSCustomObject]@{
        Agents   = $agents
        Commands = $commands
        Skills   = $skills
    }
}

function Select-InlineInstallItems {
    param(
        [Parameter(Mandatory = $true)][array]$Catalog,
        [Parameter(Mandatory = $true)][bool]$IncludeAgents,
        [Parameter(Mandatory = $true)][bool]$IncludeCommands,
        [Parameter(Mandatory = $true)][bool]$IncludeSkills,
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        $InitialState = $null
    )

    $pluginStates = @()
    foreach ($plugin in $Catalog) {
        $children = @()
        if ($IncludeAgents) {
            foreach ($f in $plugin.AgentFiles) {
                $stem = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
                $children += [PSCustomObject]@{
                    Key       = "agent|$($plugin.Name)|$stem"
                    Kind      = "agent"
                    KindLabel = "agent"
                    File      = $f
                    Stem      = $stem
                    Display   = $stem
                }
            }
        }
        if ($IncludeCommands) {
            foreach ($f in $plugin.CommandFiles) {
                $stem = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
                $children += [PSCustomObject]@{
                    Key       = "prompt|$($plugin.Name)|$stem"
                    Kind      = "prompt"
                    KindLabel = "command"
                    File      = $f
                    Stem      = $stem
                    Display   = $stem
                }
            }
        }
        if ($children.Count -eq 0) { continue }
        $pluginStates += [PSCustomObject]@{
            Plugin   = $plugin
            Expanded = $false
            Children = $children
        }
    }

    if ($pluginStates.Count -eq 0) {
        return [PSCustomObject]@{
            Plugins       = @()
            Agents        = @()
            Commands      = @()
            Skills        = @()
            BackRequested = $false
        }
    }

    $selectedKeys = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $preselectedPluginNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    if ($InitialState -and $InitialState.plugins) {
        foreach ($entry in @($InitialState.plugins)) {
            if (-not $entry.name) { continue }
            $pluginName = [string]$entry.name
            [void]$preselectedPluginNames.Add($pluginName)

            $hasAgentsProperty = ($entry.PSObject.Properties.Name -contains "agents")
            $hasCommandsProperty = ($entry.PSObject.Properties.Name -contains "commands")
            $wantedAgents = @()
            $wantedCommands = @()
            if ($hasAgentsProperty -and $entry.agents) { $wantedAgents = @($entry.agents | ForEach-Object { [string]$_ }) }
            if ($hasCommandsProperty -and $entry.commands) { $wantedCommands = @($entry.commands | ForEach-Object { [string]$_ }) }
            $selectAllAgents = -not $hasAgentsProperty
            $selectAllCommands = -not $hasCommandsProperty

            foreach ($state in $pluginStates) {
                if ($state.Plugin.Name -ne $pluginName) { continue }
                foreach ($child in $state.Children) {
                    if ($child.Kind -eq "agent" -and ($selectAllAgents -or ($wantedAgents -contains $child.Stem))) {
                        [void]$selectedKeys.Add($child.Key)
                    }
                    elseif ($child.Kind -eq "prompt" -and ($selectAllCommands -or ($wantedCommands -contains $child.Stem))) {
                        [void]$selectedKeys.Add($child.Key)
                    }
                }
            }
        }
    }

    foreach ($state in $pluginStates) {
        if ($preselectedPluginNames.Contains($state.Plugin.Name)) {
            $state.Expanded = $true
        }
    }

    $cursor = 0
    $offset = 0
    $headerLines = 7
    $minWidth = 50
    $goBack = $false

    while ($true) {
        $rows = @()
        foreach ($state in $pluginStates) {
            $rows += [PSCustomObject]@{ RowType = "plugin"; State = $state }
            if ($state.Expanded) {
                foreach ($child in $state.Children) {
                    $rows += [PSCustomObject]@{ RowType = "child"; State = $state; Child = $child }
                }
            }
        }

        if ($rows.Count -eq 0) { break }
        if ($cursor -lt 0) { $cursor = 0 }
        if ($cursor -ge $rows.Count) { $cursor = $rows.Count - 1 }

        $windowWidth = 120
        $windowHeight = 30
        try {
            $windowWidth = [Console]::WindowWidth
            $windowHeight = [Console]::WindowHeight
        }
        catch {
            $windowWidth = 120
            $windowHeight = 30
        }

        $width = [Math]::Max($windowWidth - 1, $minWidth)
        $pageSize = $windowHeight - $headerLines - 1
        if ($pageSize -lt 1) { $pageSize = 1 }
        if ($cursor -lt $offset) { $offset = $cursor }
        elseif ($cursor -ge ($offset + $pageSize)) { $offset = $cursor - $pageSize + 1 }
        if ($offset -lt 0) { $offset = 0 }
        if ($offset -gt [Math]::Max($rows.Count - $pageSize, 0)) { $offset = [Math]::Max($rows.Count - $pageSize, 0) }

        $selectedCount = $selectedKeys.Count
        $totalCount = 0
        foreach ($state in $pluginStates) { $totalCount += $state.Children.Count }

        Clear-Host
        Write-Host "Select plugins and items to install (awesome-copilot)" -ForegroundColor Cyan
        Write-Host "Expand plugins inline and select agents/commands. Skills install automatically from repo-root 'skills/' when enabled." -ForegroundColor DarkGray
        Write-Host "Keys: Up/Down PgUp/PgDn Home/End | Right/Left expand/collapse | Space toggle item | T toggle plugin | A toggle all | I invert | Backspace/Delete/Ctrl+H/B/Q go back | Enter confirm | Esc clear all" -ForegroundColor DarkGray
        Write-Host ("Selected {0}/{1}" -f $selectedCount, $totalCount) -ForegroundColor DarkGray
        Write-Host ""

        $end = [Math]::Min($offset + $pageSize - 1, $rows.Count - 1)
        for ($i = $offset; $i -le $end; $i++) {
            $row = $rows[$i]
            $pointer = if ($i -eq $cursor) { ">" } else { " " }
            if ($row.RowType -eq "plugin") {
                $state = $row.State
                $sel = 0
                foreach ($child in $state.Children) {
                    if ($selectedKeys.Contains($child.Key)) { $sel++ }
                }
                $mark = "[ ]"
                $lineColor = "Cyan"
                if ($sel -gt 0 -and $sel -lt $state.Children.Count) { $mark = "[-]"; $lineColor = "Yellow" }
                elseif ($sel -eq $state.Children.Count) { $mark = "[x]"; $lineColor = "Green" }
                $expander = if ($state.Expanded) { "v" } else { ">" }
                $lineText = "$pointer $mark $expander $($state.Plugin.Name) ($sel/$($state.Children.Count))"
            }
            else {
                $child = $row.Child
                $isSelected = $selectedKeys.Contains($child.Key)
                $check = if ($isSelected) { "[x]" } else { "[ ]" }
                $lineText = "$pointer    $check [$($child.KindLabel)] $($child.Display)"
                $lineColor = if ($isSelected) { "Green" } else { "Gray" }
            }
            if ($lineText.Length -gt $width) { $lineText = $lineText.Substring(0, $width - 3) + "..." }
            Write-Host $lineText -ForegroundColor $lineColor
        }

        $done = $false
        $key = [Console]::ReadKey($true)
        $rowAtCursor = $rows[$cursor]
        if (Test-GoBackKeyPress -KeyInfo $key) {
            $goBack = $true
            $done = $true
        }
        else {
            switch ($key.Key) {
                "UpArrow" { if ($cursor -gt 0) { $cursor-- } }
                "DownArrow" { if ($cursor -lt ($rows.Count - 1)) { $cursor++ } }
                "PageUp" { $cursor = [Math]::Max($cursor - $pageSize, 0) }
                "PageDown" { $cursor = [Math]::Min($cursor + $pageSize, $rows.Count - 1) }
                "Home" { $cursor = 0 }
                "End" { $cursor = $rows.Count - 1 }
                "RightArrow" { if ($rowAtCursor.RowType -eq "plugin") { $rowAtCursor.State.Expanded = $true } }
                "LeftArrow" { if ($rowAtCursor.RowType -eq "plugin") { $rowAtCursor.State.Expanded = $false } }
                "Spacebar" {
                    if ($rowAtCursor.RowType -eq "plugin") {
                        $rowAtCursor.State.Expanded = -not $rowAtCursor.State.Expanded
                    }
                    else {
                        $k = $rowAtCursor.Child.Key
                        if ($selectedKeys.Contains($k)) { [void]$selectedKeys.Remove($k) } else { [void]$selectedKeys.Add($k) }
                    }
                }
                "Enter" { $done = $true }
                "Escape" { $selectedKeys.Clear(); $done = $true }
            }
        }

        if (-not $done -and ($key.KeyChar -eq "t" -or $key.KeyChar -eq "T")) {
            if ($rowAtCursor.RowType -eq "plugin") {
                $state = $rowAtCursor.State
                $allSelected = $true
                foreach ($child in $state.Children) {
                    if (-not $selectedKeys.Contains($child.Key)) { $allSelected = $false; break }
                }
                foreach ($child in $state.Children) {
                    if ($allSelected) { [void]$selectedKeys.Remove($child.Key) } else { [void]$selectedKeys.Add($child.Key) }
                }
            }
        }

        if (-not $done -and ($key.KeyChar -eq "a" -or $key.KeyChar -eq "A")) {
            $allSelected = $true
            foreach ($state in $pluginStates) {
                foreach ($child in $state.Children) {
                    if (-not $selectedKeys.Contains($child.Key)) { $allSelected = $false; break }
                }
                if (-not $allSelected) { break }
            }
            foreach ($state in $pluginStates) {
                foreach ($child in $state.Children) {
                    if ($allSelected) { [void]$selectedKeys.Remove($child.Key) } else { [void]$selectedKeys.Add($child.Key) }
                }
            }
        }
        if (-not $done -and ($key.KeyChar -eq "i" -or $key.KeyChar -eq "I")) {
            foreach ($state in $pluginStates) {
                foreach ($child in $state.Children) {
                    if ($selectedKeys.Contains($child.Key)) { [void]$selectedKeys.Remove($child.Key) } else { [void]$selectedKeys.Add($child.Key) }
                }
            }
        }

        if ($done) { break }
    }

    $selectedAgents = @()
    $selectedCommands = @()
    $selectedSkills = @()
    $selectedPluginNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    foreach ($state in $pluginStates) {
        foreach ($child in $state.Children) {
            if (-not $selectedKeys.Contains($child.Key)) { continue }
            [void]$selectedPluginNames.Add($state.Plugin.Name)
            if ($child.Kind -eq "agent") {
                $selectedAgents += New-AgentCandidate -Plugin $state.Plugin.Name -FileInfo $child.File
            }
            elseif ($child.Kind -eq "prompt") {
                $selectedCommands += New-CommandCandidate -Plugin $state.Plugin.Name -FileInfo $child.File -RepoRoot $RepoRoot
            }
        }
    }

    $selectedPlugins = @($Catalog | Where-Object { $selectedPluginNames.Contains($_.Name) })

    return [PSCustomObject]@{
        Plugins       = $selectedPlugins
        Agents        = $selectedAgents
        Commands      = $selectedCommands
        Skills        = $selectedSkills
        BackRequested = $goBack
    }
}

function Select-Instructions {
    param(
        [Parameter(Mandatory = $true)][array]$InstructionCandidates,
        [array]$PreselectedNames = @(),
        [switch]$AllowGoBack
    )

    if ($InstructionCandidates.Count -eq 0) {
        return @()
    }

    $preselectedIndexes = @()
    $nameSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($name in $PreselectedNames) {
        if (-not [string]::IsNullOrWhiteSpace([string]$name)) { [void]$nameSet.Add([string]$name) }
    }
    for ($i = 0; $i -lt $InstructionCandidates.Count; $i++) {
        if ($nameSet.Contains($InstructionCandidates[$i].Name)) { $preselectedIndexes += $i }
    }

    $labels = @($InstructionCandidates | ForEach-Object { $_.Display })
    $indexes = Select-IndicesFromList -Items $labels -Label "Select instruction files to install" -AllowEmpty -PreselectedIndexes $preselectedIndexes -AllowGoBack:$AllowGoBack
    if ($null -eq $indexes) {
        return $null
    }
    $selected = @()
    foreach ($idx in $indexes) { $selected += $InstructionCandidates[$idx] }
    Write-Output -NoEnumerate $selected
    return
}

function Resolve-SelectionsFromState {
    param(
        [Parameter(Mandatory = $true)][array]$Catalog,
        [Parameter(Mandatory = $true)][array]$InstructionCandidates,
        [array]$RootSkillCandidates = @(),
        [Parameter(Mandatory = $true)]$State,
        [Parameter(Mandatory = $true)][bool]$IncludeAgents,
        [Parameter(Mandatory = $true)][bool]$IncludeCommands,
        [Parameter(Mandatory = $true)][bool]$IncludeSkills,
        [Parameter(Mandatory = $true)][bool]$IncludeInstructions,
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [string[]]$PluginFilter
    )

    $filterSet = $null
    if ($PluginFilter -and $PluginFilter.Count -gt 0) {
        $filterSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($name in $PluginFilter) {
            if (-not [string]::IsNullOrWhiteSpace($name)) {
                [void]$filterSet.Add($name.Trim())
            }
        }
    }

    $selectedPlugins = @()
    $selectedPluginNameSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $selectedAgents = @()
    $selectedCommands = @()
    $selectedSkills = @()
    $selectedInstructions = @()

    $statePlugins = @()
    if ($State -and $State.plugins) { $statePlugins = @($State.plugins) }

    foreach ($entry in $statePlugins) {
        if (-not $entry.name) { continue }
        if ($filterSet -and -not $filterSet.Contains([string]$entry.name)) { continue }
        $plugin = $Catalog | Where-Object { $_.Name -eq $entry.name } | Select-Object -First 1
        if (-not $plugin) {
            Write-WarnLine "State references plugin '$($entry.name)' which is not available in source; skipping."
            continue
        }
        if ($selectedPluginNameSet.Add($plugin.Name)) { $selectedPlugins += $plugin }

        if ($IncludeAgents) {
            $hasAgents = ($entry.PSObject.Properties.Name -contains "agents")
            $wantedAgents = @()
            if ($hasAgents -and $entry.agents) { $wantedAgents = @($entry.agents | ForEach-Object { [string]$_ }) }
            $selectAllAgents = -not $hasAgents
            foreach ($f in $plugin.AgentFiles) {
                $stem = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
                if ($selectAllAgents -or ($wantedAgents -contains $stem)) {
                    $selectedAgents += New-AgentCandidate -Plugin $plugin.Name -FileInfo $f
                }
            }
        }

        if ($IncludeCommands) {
            $hasCommands = ($entry.PSObject.Properties.Name -contains "commands")
            $wantedCommands = @()
            if ($hasCommands -and $entry.commands) { $wantedCommands = @($entry.commands | ForEach-Object { [string]$_ }) }
            $selectAllCommands = -not $hasCommands
            foreach ($f in $plugin.CommandFiles) {
                $stem = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
                if ($selectAllCommands -or ($wantedCommands -contains $stem)) {
                    $selectedCommands += New-CommandCandidate -Plugin $plugin.Name -FileInfo $f -RepoRoot $RepoRoot
                }
            }
        }

    }

    if ($IncludeSkills) {
        $rootSkills = @($RootSkillCandidates)
        if ($rootSkills.Count -gt 0) {
            $stateSkillTokenSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
            foreach ($stateToken in @(Get-StateArtifactTokenSet -State $State -Kind "skills")) {
                if (-not [string]::IsNullOrWhiteSpace([string]$stateToken)) {
                    [void]$stateSkillTokenSet.Add(([string]$stateToken).Trim())
                }
            }

            if ($stateSkillTokenSet.Count -eq 0) {
                $selectedSkills = @($rootSkills)
            }
            else {
                foreach ($candidate in $rootSkills) {
                    $candidateTokens = @(Get-CandidateTokenSet -Candidate $candidate -Kind "skills" -RepoRoot $RepoRoot)
                    foreach ($token in $candidateTokens) {
                        if (-not [string]::IsNullOrWhiteSpace([string]$token) -and $stateSkillTokenSet.Contains(([string]$token).Trim())) {
                            $selectedSkills += $candidate
                            break
                        }
                    }
                }
                if ($selectedSkills.Count -eq 0) {
                    $selectedSkills = @($rootSkills)
                }
            }
        }
    }

    if ($IncludeInstructions) {
        $hasInstructions = ($State.PSObject.Properties.Name -contains "instructions")
        $wantedInstructions = @()
        if ($hasInstructions -and $State.instructions) { $wantedInstructions = @($State.instructions | ForEach-Object { [string]$_ }) }
        if (-not $hasInstructions) {
            $selectedInstructions = @($InstructionCandidates)
        }
        else {
            foreach ($candidate in $InstructionCandidates) {
                if ($wantedInstructions -contains $candidate.Name) { $selectedInstructions += $candidate }
            }
        }
    }

    return [PSCustomObject]@{
        Plugins      = $selectedPlugins
        Agents       = $selectedAgents
        Commands     = $selectedCommands
        Skills       = $selectedSkills
        Instructions = $selectedInstructions
    }
}

function Resolve-ArtifactName {
    param(
        [Parameter(Mandatory = $true)][string]$Stem,
        [Parameter(Mandatory = $true)][ValidateSet("agent", "prompt")] [string]$Kind
    )

    if ([string]::IsNullOrWhiteSpace($Stem)) {
        return $null
    }

    $base = [string]$Stem
    if ($base.EndsWith(".agent", [System.StringComparison]::OrdinalIgnoreCase)) {
        $base = $base.Substring(0, $base.Length - 6)
    }
    if ($base.EndsWith(".prompt", [System.StringComparison]::OrdinalIgnoreCase)) {
        $base = $base.Substring(0, $base.Length - 7)
    }
    if ([string]::IsNullOrWhiteSpace($base)) {
        return $null
    }
    return "$base.$Kind.md"
}

function Copy-FileWithLog {
    param(
        [Parameter(Mandatory = $true)][string]$SourcePath,
        [Parameter(Mandatory = $true)][string]$DestinationPath,
        [Parameter(Mandatory = $true)][switch]$Overwrite,
        [Parameter(Mandatory = $true)][switch]$NoWrite
    )

    if ((Test-Path -LiteralPath $DestinationPath) -and -not $Overwrite) {
        Write-WarnLine "Skipped existing file: $DestinationPath (use -Force to overwrite)"
        return $false
    }
    if ($NoWrite) {
        Write-Step "[DryRun] Copy file: '$SourcePath' -> '$DestinationPath'"
        return $true
    }
    Ensure-Directory -Path (Split-Path -Parent $DestinationPath)
    Copy-Item -LiteralPath $SourcePath -Destination $DestinationPath -Force:$Overwrite
    Write-SuccessLine "Copied file: '$SourcePath' -> '$DestinationPath'"
    return $true
}

function Copy-DirectoryWithLog {
    param(
        [Parameter(Mandatory = $true)][string]$SourcePath,
        [Parameter(Mandatory = $true)][string]$DestinationPath,
        [Parameter(Mandatory = $true)][switch]$Overwrite,
        [Parameter(Mandatory = $true)][switch]$NoWrite
    )

    if ((Test-Path -LiteralPath $DestinationPath) -and -not $Overwrite) {
        Write-WarnLine "Skipped existing skill directory: $DestinationPath (use -Force to overwrite)"
        return $false
    }
    if ($NoWrite) {
        Write-Step "[DryRun] Copy dir: '$SourcePath' -> '$DestinationPath'"
        return $true
    }
    if (Test-Path -LiteralPath $DestinationPath) {
        Remove-Item -LiteralPath $DestinationPath -Recurse -Force
    }
    Ensure-Directory -Path (Split-Path -Parent $DestinationPath)
    Copy-Item -LiteralPath $SourcePath -Destination $DestinationPath -Recurse
    Write-SuccessLine "Copied dir: '$SourcePath' -> '$DestinationPath'"
    return $true
}

function Normalize-InstallTargetPath {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $null
    }

    $normalized = [string]$Path
    try {
        $normalized = [System.IO.Path]::GetFullPath($normalized)
    }
    catch {
    }

    return $normalized.TrimEnd('\', '/')
}

function New-InstallTargetSet {
    param([array]$Targets)

    $set = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($target in @($Targets)) {
        $normalized = Normalize-InstallTargetPath -Path ([string]$target)
        if (-not [string]::IsNullOrWhiteSpace($normalized)) {
            [void]$set.Add($normalized)
        }
    }
    return , $set
}

function Test-TargetPathWithinRoot {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$RootPath
    )

    $normalizedPath = Normalize-InstallTargetPath -Path $Path
    $normalizedRoot = Normalize-InstallTargetPath -Path $RootPath
    if ([string]::IsNullOrWhiteSpace($normalizedPath) -or [string]::IsNullOrWhiteSpace($normalizedRoot)) {
        return $false
    }

    if ($normalizedPath.Equals($normalizedRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $true
    }

    foreach ($prefix in @("$normalizedRoot\", "$normalizedRoot/")) {
        if ($normalizedPath.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
            return $true
        }
    }

    return $false
}

function Get-InstalledTargetsFromState {
    param(
        $State,
        [Parameter(Mandatory = $true)][ValidateSet("promptTargets", "skillTargets")] [string]$PropertyName
    )

    $targets = @()
    if (
        $State -and
        ($State.PSObject.Properties.Name -contains "installedArtifacts") -and
        $State.installedArtifacts -and
        ($State.installedArtifacts.PSObject.Properties.Name -contains $PropertyName)
    ) {
        foreach ($target in @($State.installedArtifacts.$PropertyName)) {
            if (-not [string]::IsNullOrWhiteSpace([string]$target)) {
                $targets += [string]$target
            }
        }
    }
    return $targets
}

function Remove-TargetWithLog {
    param(
        [Parameter(Mandatory = $true)][string]$TargetPath,
        [Parameter(Mandatory = $true)][switch]$NoWrite,
        [Parameter(Mandatory = $true)][string]$KindLabel
    )

    if (-not (Test-Path -LiteralPath $TargetPath)) {
        return $false
    }

    $item = Get-Item -LiteralPath $TargetPath -Force
    $itemType = if ($item.PSIsContainer) { "directory" } else { "file" }

    if ($NoWrite) {
        Write-Step "[DryRun] Remove $itemType ($KindLabel): '$TargetPath'"
        return $true
    }

    if ($item.PSIsContainer) {
        Remove-Item -LiteralPath $TargetPath -Recurse -Force
    }
    else {
        Remove-Item -LiteralPath $TargetPath -Force
    }
    Write-SuccessLine "Removed $itemType ($KindLabel): '$TargetPath'"
    return $true
}

$resolvedRepoRoot = Resolve-SourceRepoRoot -Override $RepoRoot -Mode $SourceMode -ArchiveUrl $RemoteArchiveUrl -CacheRootOverride $SourceCacheRoot
$pluginsRoot = Join-Path $resolvedRepoRoot "plugins"
$instructionsRoot = Join-Path $resolvedRepoRoot "instructions"
if (-not (Test-Path -LiteralPath $pluginsRoot)) {
    throw "Could not find plugins directory under '$resolvedRepoRoot'."
}

$catalog = @()
foreach ($pluginDir in (Get-ChildItem -LiteralPath $pluginsRoot -Directory | Sort-Object Name)) {
    $agentsPath = Join-Path $pluginDir.FullName "agents"
    $commandsPath = Join-Path $pluginDir.FullName "commands"

    $agentFiles = @()
    $commandFiles = @()

    if (Test-Path -LiteralPath $agentsPath) {
        $agentFiles = @(Get-ChildItem -LiteralPath $agentsPath -File -Filter "*.md" | Sort-Object Name)
    }
    if (Test-Path -LiteralPath $commandsPath) {
        $commandFiles = @(Get-ChildItem -LiteralPath $commandsPath -File -Filter "*.md" | Sort-Object Name)
    }

    if ($agentFiles.Count -gt 0 -or $commandFiles.Count -gt 0) {
        $catalog += [PSCustomObject]@{
            Name         = $pluginDir.Name
            Path         = $pluginDir.FullName
            AgentFiles   = $agentFiles
            CommandFiles = $commandFiles
        }
    }
}

$instructionCandidates = @()
if (Test-Path -LiteralPath $instructionsRoot) {
    foreach ($f in (Get-ChildItem -LiteralPath $instructionsRoot -File -Filter "*.instructions.md" | Sort-Object Name)) {
        $instructionCandidates += New-InstructionCandidate -FileInfo $f -RepoRoot $resolvedRepoRoot
    }
}

$rootSkillCandidates = @(Get-RootSkillCandidates -RepoRoot $resolvedRepoRoot)

if ($catalog.Count -eq 0 -and $instructionCandidates.Count -eq 0 -and $rootSkillCandidates.Count -eq 0) {
    throw "No installable agents/commands/skills/instructions found under '$resolvedRepoRoot'."
}

Write-Section "Source"
Write-KeyValueLine -Label "Repository" -Value $resolvedRepoRoot -ValueColor "Cyan"
Write-KeyValueLine -Label "Plugins discovered" -Value ([string]$catalog.Count) -ValueColor "Green"
Write-KeyValueLine -Label "Root skills discovered" -Value ([string]$rootSkillCandidates.Count) -ValueColor "Green"
Write-KeyValueLine -Label "Instructions discovered" -Value ([string]$instructionCandidates.Count) -ValueColor "Green"

$interactiveRunConfigSelected = $false
$InstallByPlugin = $true
$SelectionMode = "plugins"
if ($Target -eq "Interactive" -and (Test-InteractiveConsole)) {
    Write-Info "Configure install options (interactive settings override command-line switches in this mode)."
    $runConfig = Select-RunConfiguration -SupportsInstructions:$true
    if ($null -eq $runConfig) {
        Write-WarnLine "Selection canceled."
        return
    }
    $InstallByPlugin = $runConfig.InstallByPlugin
    $SelectionMode = [string]$runConfig.SelectionMode
    $IncludeAgents = $runConfig.IncludeAgents
    $IncludeCommands = $runConfig.IncludePrompts
    $IncludeSkills = $runConfig.IncludeSkills
    $IncludeInstructions = $runConfig.IncludeInstructions
    $UpdateExisting = $runConfig.UpdateExisting
    $DryRun = $runConfig.DryRun
    $Force = $runConfig.Force
    $interactiveRunConfigSelected = $true
}
elseif (-not $IncludeAgents -and -not $IncludeCommands -and -not $IncludeSkills -and -not $IncludeInstructions) {
    $IncludeAgents = $true
    $IncludeCommands = $true
    $IncludeSkills = $true
    $IncludeInstructions = $true
}

$SelectionMode = Resolve-SelectionModeLabel -InstallByPlugin:$InstallByPlugin -IncludeAgents:$IncludeAgents -IncludeCommands:$IncludeCommands -IncludeSkills:$IncludeSkills

$updateExistingProvided = $PSBoundParameters.ContainsKey("UpdateExisting")
if ($interactiveRunConfigSelected) {
    $updateExistingProvided = $true
}
$explicitPluginList = ($Plugins -and $Plugins.Count -gt 0)

$selectedPlugins = @()
$selectedAgents = @()
$selectedCommands = @()
$selectedSkills = @()
$selectedInstructions = @()
$usedInlineSelector = $false

if ($explicitPluginList -and -not $UpdateExisting) {
    $wanted = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($p in $Plugins) {
        if (-not [string]::IsNullOrWhiteSpace($p)) { [void]$wanted.Add($p.Trim()) }
    }
    $selectedPlugins = @($catalog | Where-Object { $wanted.Contains($_.Name) })
    $missing = @($wanted | Where-Object { -not ($selectedPlugins.Name -contains $_) })
    if ($missing.Count -gt 0) {
        throw "Unknown plugin(s): $($missing -join ', ')"
    }
}

$initialTargetMode = $Target
while ($true) {
    $usedInlineSelector = $false
    $selectedAgents = @()
    $selectedCommands = @()
    $selectedSkills = @()
    $selectedInstructions = @()
    if (-not $explicitPluginList -or $UpdateExisting) { $selectedPlugins = @() }

    if ($Target -eq "Interactive") {
        $targetOptions = @(
            "Workspace",
            "UserVSCode",
            "Custom"
        )
        $targetIndex = Select-IndexFromList -Items $targetOptions -Label "Select install location" -AllowGoBack
        if ($null -eq $targetIndex) {
            if (Test-InteractiveConsole) {
                $runConfig = Select-RunConfiguration -SupportsInstructions:$true
                if ($null -eq $runConfig) {
                    Write-WarnLine "Selection canceled."
                    return
                }
                $InstallByPlugin = $runConfig.InstallByPlugin
                $SelectionMode = [string]$runConfig.SelectionMode
                $IncludeAgents = $runConfig.IncludeAgents
                $IncludeCommands = $runConfig.IncludePrompts
                $IncludeSkills = $runConfig.IncludeSkills
                $IncludeInstructions = $runConfig.IncludeInstructions
                $UpdateExisting = $runConfig.UpdateExisting
                $DryRun = $runConfig.DryRun
                $Force = $runConfig.Force
                $interactiveRunConfigSelected = $true
                $updateExistingProvided = $true
                $SelectionMode = Resolve-SelectionModeLabel -InstallByPlugin:$InstallByPlugin -IncludeAgents:$IncludeAgents -IncludeCommands:$IncludeCommands -IncludeSkills:$IncludeSkills
                continue
            }
            throw "Interactive back navigation requires an interactive console."
        }
        switch ($targetIndex) {
            1 { $Target = "UserVSCode" }
            2 { $Target = "Custom" }
            default { $Target = "Workspace" }
        }
    }

    switch ($Target) {
        "Workspace" {
            if (-not $WorkspaceRoot) { $WorkspaceRoot = (Get-Location).Path }
            $PromptsPath = Join-Path $WorkspaceRoot ".github/prompts"
            $SkillsPath = Join-Path $WorkspaceRoot ".github/skills"
        }
        "UserVSCode" {
            $userRoot = Get-VSCodeUserRoot
            $PromptsPath = Join-Path $userRoot "prompts"
            $SkillsPath = Join-Path $userRoot "skills"
        }
        "Custom" {
            if (-not $PromptsPath) { $PromptsPath = Read-Host "Enter prompts target path" }
            if (-not $SkillsPath) { $SkillsPath = Read-Host "Enter skills target path" }
        }
    }

    if (-not $PromptsPath -or -not $SkillsPath) {
        throw "Both prompts and skills target paths must be set."
    }

    $StateFilePath = Get-StateFilePath -PromptsPath $PromptsPath -SkillsPath $SkillsPath -OverridePath $StateFilePath
    Write-Section "Target"
    Write-KeyValueLine -Label "Prompts target" -Value $PromptsPath -ValueColor "Cyan"
    Write-KeyValueLine -Label "Skills target" -Value $SkillsPath -ValueColor "Cyan"
    Write-KeyValueLine -Label "State file" -Value $StateFilePath -ValueColor "Gray"

    $modeChosenInteractively = $false
    $UpdateExisting = $false
    $DryRun = $false
    $Force = $true
    Write-Info "Operation mode: Install/add (overwrite enabled)"

    if (-not $DryRun) {
        Ensure-Directory -Path $PromptsPath
        Ensure-Directory -Path $SkillsPath
    }

    $existingState = $null
    if (Test-Path -LiteralPath $StateFilePath) {
        $existingState = Read-InstallState -Path $StateFilePath
        if (-not $UpdateExisting) {
            Write-Info "Loaded existing state for default plugin/item selections."
        }
    }

    if ($UpdateExisting -and -not $existingState) {
        if ($modeChosenInteractively) {
            Write-WarnLine "No state file found for update mode at '$StateFilePath'. Switching to install/add mode."
            $UpdateExisting = $false
        }
        else {
            throw "Update mode requires an existing state file at '$StateFilePath'. Run a normal install first."
        }
    }

    if ($UpdateExisting) {
        $pluginFilter = @()
        if ($explicitPluginList) {
            $wanted = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
            foreach ($p in $Plugins) {
                if (-not [string]::IsNullOrWhiteSpace($p)) { [void]$wanted.Add($p.Trim()) }
            }
            $missing = @($wanted | Where-Object { -not ($catalog.Name -contains $_) })
            if ($missing.Count -gt 0) { throw "Unknown plugin(s): $($missing -join ', ')" }
            $pluginFilter = @($wanted)
        }
        $stateSelection = Resolve-SelectionsFromState -Catalog $catalog -InstructionCandidates $instructionCandidates -RootSkillCandidates $rootSkillCandidates -State $existingState -IncludeAgents:$IncludeAgents -IncludeCommands:$IncludeCommands -IncludeSkills:$IncludeSkills -IncludeInstructions:$IncludeInstructions -RepoRoot $resolvedRepoRoot -PluginFilter $pluginFilter
        $selectedPlugins = @($stateSelection.Plugins)
        $selectedAgents = @($stateSelection.Agents)
        $selectedCommands = @($stateSelection.Commands)
        $selectedSkills = @($stateSelection.Skills)
        $selectedInstructions = @($stateSelection.Instructions)
        $usedInlineSelector = $true
    }
    elseif ($InstallByPlugin -and (-not $explicitPluginList) -and (Test-InteractiveConsole) -and (-not $UpdateExisting)) {
        $inlineSelection = Select-InlineInstallItems -Catalog $catalog -IncludeAgents:$IncludeAgents -IncludeCommands:$IncludeCommands -IncludeSkills:$IncludeSkills -RepoRoot $resolvedRepoRoot -InitialState $existingState
        if ($inlineSelection.BackRequested) {
            if ($initialTargetMode -eq "Interactive") {
                $Target = "Interactive"
                $PromptsPath = $null
                $SkillsPath = $null
                continue
            }
            Write-WarnLine "Back navigation is only available with Target=Interactive."
            continue
        }
        $selectedPlugins = @($inlineSelection.Plugins)
        $selectedAgents = @($inlineSelection.Agents)
        $selectedCommands = @($inlineSelection.Commands)
        $selectedSkills = if ($IncludeSkills) { @($rootSkillCandidates) } else { @($inlineSelection.Skills) }
        $usedInlineSelector = $true

        if ($IncludeInstructions) {
            $defaultInstructionNames = Get-StateInstructionNames -State $existingState
            $selectedInstructions = Select-Instructions -InstructionCandidates $instructionCandidates -PreselectedNames $defaultInstructionNames -AllowGoBack
            if ($null -eq $selectedInstructions) {
                continue
            }
        }
    }
    elseif (-not $explicitPluginList -and $InstallByPlugin) {
        $pluginLabels = @($catalog | ForEach-Object { "$($_.Name) (agents=$($_.AgentFiles.Count), commands=$($_.CommandFiles.Count))" })
        $preselectedPluginIndexes = @()
        if ($existingState -and $existingState.plugins) {
            $statePluginNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
            foreach ($entry in @($existingState.plugins)) {
                if ($entry.name) { [void]$statePluginNames.Add([string]$entry.name) }
            }
            for ($i = 0; $i -lt $catalog.Count; $i++) {
                if ($statePluginNames.Contains($catalog[$i].Name)) { $preselectedPluginIndexes += $i }
            }
        }
        $chosenIndexes = Select-IndicesFromList -Items $pluginLabels -Label "Select plugin(s) to install" -PreselectedIndexes $preselectedPluginIndexes -AllowGoBack
        if ($null -eq $chosenIndexes) {
            if ($initialTargetMode -eq "Interactive") {
                $Target = "Interactive"
                $PromptsPath = $null
                $SkillsPath = $null
                continue
            }
            Write-WarnLine "Back navigation is only available with Target=Interactive."
            continue
        }
        $selectedPlugins = @($chosenIndexes | ForEach-Object { $catalog[$_] })
    }
    else {
        $candidatePlugins = @()
        if ($explicitPluginList) {
            $candidatePlugins = @($selectedPlugins)
        }
        else {
            $candidatePlugins = @($catalog)
        }

        $candidates = Build-CandidatesFromPlugins -Plugins $candidatePlugins -IncludeAgents:$IncludeAgents -IncludeCommands:$IncludeCommands -IncludeSkills:$IncludeSkills -RepoRoot $resolvedRepoRoot -RootSkillCandidates $rootSkillCandidates
        $agentCandidates = @($candidates.Agents)
        $commandCandidates = @($candidates.Commands)
        $skillCandidates = @($candidates.Skills)

        if ($IncludeCommands) {
            $promptsRoot = Join-Path $resolvedRepoRoot "prompts"
            if (Test-Path -LiteralPath $promptsRoot) {
                $commandCandidates = @()
                foreach ($promptFile in (Get-ChildItem -LiteralPath $promptsRoot -Recurse -File -Filter "*.md" | Sort-Object FullName)) {
                    $commandCandidates += New-PromptRootCandidate -FileInfo $promptFile -RepoRoot $resolvedRepoRoot
                }
            }
        }

        if ($IncludeAgents -and $agentCandidates.Count -gt 0) {
            $preselectedAgentIndexes = Get-PreselectedIndexesFromState -State $existingState -Candidates $agentCandidates -Kind "agents" -RepoRoot $resolvedRepoRoot
            $pickedAgents = Select-CandidatesGlobal -Candidates $agentCandidates -Label "Select agent files to install" -AllowEmpty -AllowGoBack -PreselectedIndexes $preselectedAgentIndexes
            if ($null -eq $pickedAgents) {
                if ($initialTargetMode -eq "Interactive") {
                    $Target = "Interactive"
                    $PromptsPath = $null
                    $SkillsPath = $null
                    continue
                }
                Write-WarnLine "Back navigation is only available with Target=Interactive."
                continue
            }
            $selectedAgents = @($pickedAgents)
        }

        if ($IncludeCommands -and $commandCandidates.Count -gt 0) {
            $preselectedCommandIndexes = Get-PreselectedIndexesFromState -State $existingState -Candidates $commandCandidates -Kind "prompts" -RepoRoot $resolvedRepoRoot
            $pickedCommands = Select-CandidatesGlobal -Candidates $commandCandidates -Label "Select prompt files to install" -AllowEmpty -AllowGoBack -PreselectedIndexes $preselectedCommandIndexes
            if ($null -eq $pickedCommands) {
                if ($initialTargetMode -eq "Interactive") {
                    $Target = "Interactive"
                    $PromptsPath = $null
                    $SkillsPath = $null
                    continue
                }
                Write-WarnLine "Back navigation is only available with Target=Interactive."
                continue
            }
            $selectedCommands = @($pickedCommands)
        }

        if ($IncludeSkills -and $skillCandidates.Count -gt 0) {
            $preselectedSkillIndexes = Get-PreselectedIndexesFromState -State $existingState -Candidates $skillCandidates -Kind "skills" -RepoRoot $resolvedRepoRoot
            $pickedSkills = Select-CandidatesGlobal -Candidates $skillCandidates -Label "Select skills to install" -AllowEmpty -AllowGoBack -PreselectedIndexes $preselectedSkillIndexes
            if ($null -eq $pickedSkills) {
                if ($initialTargetMode -eq "Interactive") {
                    $Target = "Interactive"
                    $PromptsPath = $null
                    $SkillsPath = $null
                    continue
                }
                Write-WarnLine "Back navigation is only available with Target=Interactive."
                continue
            }
            $selectedSkills = @($pickedSkills)
        }

        if ($IncludeInstructions) {
            $defaultInstructionNames = Get-StateInstructionNames -State $existingState
            $selectedInstructions = Select-Instructions -InstructionCandidates $instructionCandidates -PreselectedNames $defaultInstructionNames -AllowGoBack
            if ($null -eq $selectedInstructions) {
                if ($initialTargetMode -eq "Interactive") {
                    $Target = "Interactive"
                    $PromptsPath = $null
                    $SkillsPath = $null
                    continue
                }
                Write-WarnLine "Back navigation is only available with Target=Interactive."
                continue
            }
        }

        $selectedPluginNameSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($item in $selectedAgents) { [void]$selectedPluginNameSet.Add($item.Plugin) }
        foreach ($item in $selectedCommands) { [void]$selectedPluginNameSet.Add($item.Plugin) }
        foreach ($item in $selectedSkills) { [void]$selectedPluginNameSet.Add($item.Plugin) }
        $selectedPlugins = @($catalog | Where-Object { $selectedPluginNameSet.Contains($_.Name) })
        $usedInlineSelector = $true
    }

    break
}

$previousPromptTargetsForSelectionGuard = @()
$previousSkillTargetsForSelectionGuard = @()
if (-not $UpdateExisting -and $existingState) {
    $previousPromptTargetsForSelectionGuard = @(Get-InstalledTargetsFromState -State $existingState -PropertyName "promptTargets")
    $previousSkillTargetsForSelectionGuard = @(Get-InstalledTargetsFromState -State $existingState -PropertyName "skillTargets")
}

$hasAnySelection = (
    $selectedPlugins.Count -gt 0 -or
    $selectedAgents.Count -gt 0 -or
    $selectedCommands.Count -gt 0 -or
    $selectedSkills.Count -gt 0 -or
    $selectedInstructions.Count -gt 0
)
$hasPreviouslyInstalledTargets = (
    $previousPromptTargetsForSelectionGuard.Count -gt 0 -or
    $previousSkillTargetsForSelectionGuard.Count -gt 0
)

if (-not $hasAnySelection) {
    if ($hasPreviouslyInstalledTargets -and -not $UpdateExisting) {
        Write-Info "No new items selected; proceeding to uninstall deselected previously installed artifacts."
    }
    else {
        throw "No items selected."
    }
}

if (-not $usedInlineSelector) {
    $candidates = Build-CandidatesFromPlugins -Plugins $selectedPlugins -IncludeAgents:$IncludeAgents -IncludeCommands:$IncludeCommands -IncludeSkills:$IncludeSkills -RepoRoot $resolvedRepoRoot -RootSkillCandidates $rootSkillCandidates
    $agentCandidates = @($candidates.Agents)
    $commandCandidates = @($candidates.Commands)
    $skillCandidates = @($candidates.Skills)

    if ($IncludeAgents -and $agentCandidates.Count -gt 0) {
        $selectedAgents = Select-ObjectsByPlugin -Candidates $agentCandidates -SelectedPluginObjects $selectedPlugins -KindLabel "agents" -ExplicitPluginList:$explicitPluginList -AllowGoBack
        if ($null -eq $selectedAgents) {
            Write-WarnLine "Selection canceled."
            return
        }
    }
    if ($IncludeCommands -and $commandCandidates.Count -gt 0) {
        $selectedCommands = Select-ObjectsByPlugin -Candidates $commandCandidates -SelectedPluginObjects $selectedPlugins -KindLabel "commands" -ExplicitPluginList:$explicitPluginList -AllowGoBack
        if ($null -eq $selectedCommands) {
            Write-WarnLine "Selection canceled."
            return
        }
    }
    if ($IncludeSkills -and $skillCandidates.Count -gt 0) {
        $selectedSkills = @($skillCandidates)
    }
    if ($IncludeInstructions -and $instructionCandidates.Count -gt 0 -and $selectedInstructions.Count -eq 0) {
        $existingStateForInstructions = Read-InstallState -Path $StateFilePath
        $defaultInstructionNames = Get-StateInstructionNames -State $existingStateForInstructions
        $selectedInstructions = Select-Instructions -InstructionCandidates $instructionCandidates -PreselectedNames $defaultInstructionNames -AllowGoBack
        if ($null -eq $selectedInstructions) {
            Write-WarnLine "Selection canceled."
            return
        }
    }
}

$fileInstallCount = 0
$skillInstallCount = 0
$fileSkippedExistingCount = 0
$skillSkippedExistingCount = 0
$fileSkippedMissingUpdateCount = 0
$skillSkippedMissingUpdateCount = 0
$fileRemovedDeselectedCount = 0
$skillRemovedDeselectedCount = 0
$installedPromptTargets = @()
$installedSkillTargets = @()
$overwriteExistingFromSelectionFlow = $usedInlineSelector -and -not $UpdateExisting
$effectiveForce = $true
if ($overwriteExistingFromSelectionFlow) {
    Write-Info "Overwrite enabled for interactive selection flow."
}

$desiredPromptTargets = @()
foreach ($item in $selectedAgents) {
    $targetName = Resolve-ArtifactName -Stem $item.Stem -Kind "agent"
    if ([string]::IsNullOrWhiteSpace($targetName)) {
        Write-WarnLine "Skipping agent with invalid stem in desired target set."
        continue
    }
    $desiredPromptTargets += (Join-Path $PromptsPath $targetName)
}
foreach ($item in $selectedCommands) {
    $targetName = Resolve-ArtifactName -Stem $item.Stem -Kind "prompt"
    if ([string]::IsNullOrWhiteSpace($targetName)) {
        Write-WarnLine "Skipping prompt with invalid stem in desired target set."
        continue
    }
    $desiredPromptTargets += (Join-Path $PromptsPath $targetName)
}
foreach ($item in $selectedInstructions) {
    $desiredPromptTargets += (Join-Path $PromptsPath $item.Name)
}

$desiredSkillTargets = @()
foreach ($item in $selectedSkills) {
    $desiredSkillTargets += (Join-Path $SkillsPath $item.Name)
}

if (-not $UpdateExisting) {
    $previousPromptTargets = @(Get-InstalledTargetsFromState -State $existingState -PropertyName "promptTargets")
    $previousSkillTargets = @(Get-InstalledTargetsFromState -State $existingState -PropertyName "skillTargets")

    $desiredPromptSet = New-InstallTargetSet -Targets $desiredPromptTargets
    $desiredSkillSet = New-InstallTargetSet -Targets $desiredSkillTargets
    $stalePromptSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $staleSkillSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $stalePromptTargets = @()
    $staleSkillTargets = @()

    foreach ($previousTargetPath in $previousPromptTargets) {
        $normalized = Normalize-InstallTargetPath -Path $previousTargetPath
        if ([string]::IsNullOrWhiteSpace($normalized) -or $desiredPromptSet.Contains($normalized)) {
            continue
        }
        if (-not (Test-TargetPathWithinRoot -Path $previousTargetPath -RootPath $PromptsPath)) {
            Write-WarnLine "Skipping uninstall outside prompts target: $previousTargetPath"
            continue
        }
        if ($stalePromptSet.Add($normalized)) {
            $stalePromptTargets += $previousTargetPath
        }
    }

    foreach ($previousTargetPath in $previousSkillTargets) {
        $normalized = Normalize-InstallTargetPath -Path $previousTargetPath
        if ([string]::IsNullOrWhiteSpace($normalized) -or $desiredSkillSet.Contains($normalized)) {
            continue
        }
        if (-not (Test-TargetPathWithinRoot -Path $previousTargetPath -RootPath $SkillsPath)) {
            Write-WarnLine "Skipping uninstall outside skills target: $previousTargetPath"
            continue
        }
        if ($staleSkillSet.Add($normalized)) {
            $staleSkillTargets += $previousTargetPath
        }
    }

    foreach ($staleTargetPath in $stalePromptTargets) {
        if (Remove-TargetWithLog -TargetPath $staleTargetPath -NoWrite:$DryRun -KindLabel "deselected prompt target") {
            $fileRemovedDeselectedCount++
        }
    }
    foreach ($staleTargetPath in $staleSkillTargets) {
        if (Remove-TargetWithLog -TargetPath $staleTargetPath -NoWrite:$DryRun -KindLabel "deselected skill target") {
            $skillRemovedDeselectedCount++
        }
    }
}

foreach ($item in $selectedAgents) {
    $targetName = Resolve-ArtifactName -Stem $item.Stem -Kind "agent"
    if ([string]::IsNullOrWhiteSpace($targetName)) {
        Write-WarnLine "Skipped agent with invalid stem."
        continue
    }
    $dest = Join-Path $PromptsPath $targetName
    if ($UpdateExisting -and -not (Test-Path -LiteralPath $dest)) {
        Write-WarnLine "Skipped missing target (update mode): $dest"
        $fileSkippedMissingUpdateCount++
        continue
    }
    if ((Test-Path -LiteralPath $dest) -and -not $effectiveForce) {
        Write-WarnLine "Skipped existing file: $dest (use -Force to overwrite)"
        $fileSkippedExistingCount++
        continue
    }
    if (Copy-FileWithLog -SourcePath $item.Path -DestinationPath $dest -Overwrite:$effectiveForce -NoWrite:$DryRun) {
        $fileInstallCount++
        $installedPromptTargets += $dest
    }
}

foreach ($item in $selectedCommands) {
    $targetName = Resolve-ArtifactName -Stem $item.Stem -Kind "prompt"
    if ([string]::IsNullOrWhiteSpace($targetName)) {
        Write-WarnLine "Skipped prompt with invalid stem."
        continue
    }
    $dest = Join-Path $PromptsPath $targetName
    if ($UpdateExisting -and -not (Test-Path -LiteralPath $dest)) {
        Write-WarnLine "Skipped missing target (update mode): $dest"
        $fileSkippedMissingUpdateCount++
        continue
    }
    if ((Test-Path -LiteralPath $dest) -and -not $effectiveForce) {
        Write-WarnLine "Skipped existing file: $dest (use -Force to overwrite)"
        $fileSkippedExistingCount++
        continue
    }
    if (Copy-FileWithLog -SourcePath $item.Path -DestinationPath $dest -Overwrite:$effectiveForce -NoWrite:$DryRun) {
        $fileInstallCount++
        $installedPromptTargets += $dest
    }
}

foreach ($item in $selectedInstructions) {
    $dest = Join-Path $PromptsPath $item.Name
    if ($UpdateExisting -and -not (Test-Path -LiteralPath $dest)) {
        Write-WarnLine "Skipped missing target (update mode): $dest"
        $fileSkippedMissingUpdateCount++
        continue
    }
    if ((Test-Path -LiteralPath $dest) -and -not $effectiveForce) {
        Write-WarnLine "Skipped existing file: $dest (use -Force to overwrite)"
        $fileSkippedExistingCount++
        continue
    }
    if (Copy-FileWithLog -SourcePath $item.Path -DestinationPath $dest -Overwrite:$effectiveForce -NoWrite:$DryRun) {
        $fileInstallCount++
        $installedPromptTargets += $dest
    }
}

foreach ($item in $selectedSkills) {
    $dest = Join-Path $SkillsPath $item.Name
    if ($UpdateExisting -and -not (Test-Path -LiteralPath $dest)) {
        Write-WarnLine "Skipped missing target (update mode): $dest"
        $skillSkippedMissingUpdateCount++
        continue
    }
    if ((Test-Path -LiteralPath $dest) -and -not $effectiveForce) {
        Write-WarnLine "Skipped existing skill directory: $dest (use -Force to overwrite)"
        $skillSkippedExistingCount++
        continue
    }
    if (Copy-DirectoryWithLog -SourcePath $item.Path -DestinationPath $dest -Overwrite:$effectiveForce -NoWrite:$DryRun) {
        $skillInstallCount++
        $installedSkillTargets += $dest
    }
}

if (-not $DryRun) {
    $SelectionMode = Resolve-SelectionModeLabel -InstallByPlugin:$InstallByPlugin -IncludeAgents:$IncludeAgents -IncludeCommands:$IncludeCommands -IncludeSkills:$IncludeSkills
    Write-InstallState -Path $StateFilePath -RepoRoot $resolvedRepoRoot -PromptsPath $PromptsPath -SkillsPath $SkillsPath -SelectedPlugins $selectedPlugins -SelectedAgents $selectedAgents -SelectedCommands $selectedCommands -SelectedSkills $selectedSkills -SelectedInstructions $selectedInstructions -SelectionMode $SelectionMode -IncludeAgents:$IncludeAgents -IncludeCommands:$IncludeCommands -IncludeSkills:$IncludeSkills -IncludeInstructions:$IncludeInstructions -InstalledPromptTargets $installedPromptTargets -InstalledSkillTargets $installedSkillTargets
}

Write-Section "Install Summary"
Write-KeyValueLine -Label "Selection mode" -Value $SelectionMode -ValueColor "Cyan"
Write-KeyValueLine -Label "Plugins selected" -Value ([string]$selectedPlugins.Count) -ValueColor "White"
Write-KeyValueLine -Label "Agents selected" -Value ([string]$selectedAgents.Count) -ValueColor "White"
Write-KeyValueLine -Label "Commands selected" -Value ([string]$selectedCommands.Count) -ValueColor "White"
Write-KeyValueLine -Label "Instructions selected" -Value ([string]$selectedInstructions.Count) -ValueColor "White"
Write-KeyValueLine -Label "Skills selected" -Value ([string]$selectedSkills.Count) -ValueColor "White"
Write-KeyValueLine -Label "Prompt files written" -Value ([string]$fileInstallCount) -ValueColor "Green"
Write-KeyValueLine -Label "Skill dirs written" -Value ([string]$skillInstallCount) -ValueColor "Green"
if ($fileRemovedDeselectedCount -gt 0) {
    Write-KeyValueLine -Label "Prompt removed (deselected)" -Value ([string]$fileRemovedDeselectedCount) -ValueColor "Yellow"
}
if ($skillRemovedDeselectedCount -gt 0) {
    Write-KeyValueLine -Label "Skill removed (deselected)" -Value ([string]$skillRemovedDeselectedCount) -ValueColor "Yellow"
}
if ($fileSkippedExistingCount -gt 0) {
    Write-KeyValueLine -Label "Prompt skipped (existing)" -Value ([string]$fileSkippedExistingCount) -ValueColor "Yellow"
}
if ($skillSkippedExistingCount -gt 0) {
    Write-KeyValueLine -Label "Skill skipped (existing)" -Value ([string]$skillSkippedExistingCount) -ValueColor "Yellow"
}
if ($fileSkippedMissingUpdateCount -gt 0) {
    Write-KeyValueLine -Label "Prompt skipped (missing update)" -Value ([string]$fileSkippedMissingUpdateCount) -ValueColor "Yellow"
}
if ($skillSkippedMissingUpdateCount -gt 0) {
    Write-KeyValueLine -Label "Skill skipped (missing update)" -Value ([string]$skillSkippedMissingUpdateCount) -ValueColor "Yellow"
}
if ($DryRun) {
    Write-WarnLine "Dry run only. No files were written."
}
