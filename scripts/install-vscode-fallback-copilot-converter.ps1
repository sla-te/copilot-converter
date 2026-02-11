<#
.SYNOPSIS
Install converted plugin content as VS Code fallback artifacts.

.DESCRIPTION
For users who cannot use Copilot CLI plugin marketplaces yet, this script copies:
- `plugins/*/agents/*.md` -> `<prompts>/<name>.agent.md`
- `plugins/*/commands/*.md` -> `<prompts>/<name>.prompt.md`
- `plugins/*/skills/<skill-dir>` -> `<skills>/<skill-dir>`

It supports interactive selection of plugins, categories, and items, and lets you
target workspace, user-level, or custom directories.

.EXAMPLE
pwsh -File ./scripts/install-vscode-fallback-copilot-converter.ps1

.EXAMPLE
# Run directly from GitHub (no clone, no git required)
irm https://raw.githubusercontent.com/sla-te/copilot-converter/main/scripts/install-vscode-fallback-copilot-converter.ps1 | iex

.EXAMPLE
pwsh -File ./scripts/install-vscode-fallback-copilot-converter.ps1 -Target Workspace -WorkspaceRoot C:\src\my-repo -Plugins backend-development,conductor -DryRun
#>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSAvoidUsingWriteHost',
    '',
    Justification = 'Interactive installer UI uses direct host rendering and colors.'
)]
[CmdletBinding()]
param(
    [string]$RepoRoot = "",
    [ValidateSet("Auto", "Local", "Remote")]
    [string]$SourceMode = "Auto",
    [string]$RemoteArchiveUrl = "https://github.com/sla-te/copilot-converter/archive/refs/heads/main.zip",
    [string]$SourceCacheRoot = "",
    [switch]$KeepDownloadedSource,
    [ValidateSet("Interactive", "Workspace", "UserVSCode", "Custom")]
    [string]$Target = "Interactive",
    [string]$WorkspaceRoot,
    [string]$PromptsPath,
    [string]$SkillsPath,
    [string[]]$Plugins,
    [switch]$IncludeAgents,
    [switch]$IncludeCommands,
    [switch]$IncludeSkills,
    [switch]$Force,
    [switch]$DryRun,
    [switch]$UpdateExisting,
    [string]$StateFilePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$script:CopilotConverterCleanupPath = $null
$script:CopilotConverterKeepDownloadedSource = $false
$script:CopilotConverterCleanupRegistered = $false
$script:CopilotConverterCleanupSubscriptionIds = @()

function Invoke-TempCleanup {
    if ($script:CopilotConverterKeepDownloadedSource) {
        return
    }
    $path = $script:CopilotConverterCleanupPath
    if ($path -and (Test-Path -LiteralPath $path)) {
        Remove-Item -LiteralPath $path -Recurse -Force -ErrorAction SilentlyContinue
        $script:CopilotConverterCleanupPath = $null
    }
}

function Clear-StaleTempFolderCache {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    if ($script:CopilotConverterKeepDownloadedSource) {
        return
    }

    $tempRoot = [System.IO.Path]::GetTempPath()
    if ([string]::IsNullOrWhiteSpace($tempRoot) -or -not (Test-Path -LiteralPath $tempRoot)) {
        return
    }

    $now = Get-Date
    $folders = Get-ChildItem -LiteralPath $tempRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
        $_.Name -like "copilot-converter-source-*"
    }

    foreach ($folder in $folders) {
        if ($folder.FullName -eq $script:CopilotConverterCleanupPath) {
            continue
        }

        $age = $now - $folder.LastWriteTime
        if ($age.TotalHours -lt 1) {
            continue
        }

        if ($PSCmdlet.ShouldProcess($folder.FullName, "Remove stale temporary source folder")) {
            Remove-Item -LiteralPath $folder.FullName -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

function Register-CleanupHandler {
    if ($script:CopilotConverterCleanupRegistered) {
        return
    }
    try {
        $exitSub = Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action { Invoke-TempCleanup }
        if ($exitSub) {
            $script:CopilotConverterCleanupSubscriptionIds += $exitSub.SubscriptionId
        }
    }
    catch {
        Write-Verbose "Register-EngineEvent not available in this host; cleanup falls back to finally block."
    }
    try {
        $ctrlSub = Register-ObjectEvent -InputObject ([Console]) -EventName CancelKeyPress -Action { Invoke-TempCleanup }
        if ($ctrlSub) {
            $script:CopilotConverterCleanupSubscriptionIds += $ctrlSub.SubscriptionId
        }
    }
    catch {
        Write-Verbose "CancelKeyPress event not available in this host; continuing without Ctrl+C cleanup handler."
    }
    $script:CopilotConverterCleanupRegistered = $true
}

function Unregister-CleanupHandler {
    foreach ($id in $script:CopilotConverterCleanupSubscriptionIds) {
        Unregister-Event -SubscriptionId $id -ErrorAction SilentlyContinue
    }
    $script:CopilotConverterCleanupSubscriptionIds = @()
    $script:CopilotConverterCleanupRegistered = $false
}

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

function New-DirectoryIfMissing {
    [CmdletBinding(SupportsShouldProcess)]
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not $PSCmdlet.ShouldProcess($Path, "Create directory when missing")) {
        return
    }

    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Get-CopilotConverterCacheRoot {
    param([string]$OverridePath)

    if (-not [string]::IsNullOrWhiteSpace($OverridePath)) {
        return $OverridePath
    }

    if ($env:OS -eq "Windows_NT") {
        return Join-Path ([System.IO.Path]::GetTempPath()) "copilot-converter"
    }

    $homePath = [Environment]::GetFolderPath("UserProfile")
    if ([string]::IsNullOrWhiteSpace($homePath)) {
        $homePath = $HOME
    }

    $macCacheRoot = Join-Path $homePath "Library/Caches"
    if (Test-Path -LiteralPath $macCacheRoot) {
        return Join-Path $macCacheRoot "copilot-converter"
    }

    return Join-Path $homePath ".cache/copilot-converter"
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
        Write-Verbose "Header '$Name' lookup failed; trying normalized casing."
    }

    if (-not $value) {
        try {
            $value = $Headers[$Name.ToLowerInvariant()]
        }
        catch {
            Write-Verbose "Lowercase header '$Name' lookup failed."
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
        return Join-Path $promptsParent "copilot-converter-install-state.json"
    }

    return Join-Path $promptsParent "copilot-converter-install-state.json"
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
        [Parameter(Mandatory = $true)][string]$PromptsPath,
        [Parameter(Mandatory = $true)][string]$SkillsPath,
        [array]$SelectedPlugins = @(),
        [array]$SelectedAgents = @(),
        [array]$SelectedCommands = @(),
        [array]$SelectedSkills = @(),
        [array]$InstalledPromptTargets = @(),
        [array]$InstalledSkillTargets = @()
    )

    if (-not $SelectedPlugins) {
        $SelectedPlugins = @()
    }
    if (-not $SelectedAgents) {
        $SelectedAgents = @()
    }
    if (-not $SelectedCommands) {
        $SelectedCommands = @()
    }
    if (-not $SelectedSkills) {
        $SelectedSkills = @()
    }
    if (-not $InstalledPromptTargets) {
        $InstalledPromptTargets = @()
    }
    if (-not $InstalledSkillTargets) {
        $InstalledSkillTargets = @()
    }

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
        $agents = @($SelectedAgents | Where-Object { $_.Plugin -eq $pluginName } | ForEach-Object { $_.Stem } | Sort-Object -Unique)
        $commands = @($SelectedCommands | Where-Object { $_.Plugin -eq $pluginName } | ForEach-Object { $_.Stem } | Sort-Object -Unique)
        $skills = @($SelectedSkills | Where-Object { $_.Plugin -eq $pluginName } | ForEach-Object { $_.Name } | Sort-Object -Unique)

        $pluginEntries += [PSCustomObject]@{
            name     = $pluginName
            agents   = $agents
            commands = $commands
            skills   = $skills
        }
    }

    $state = [PSCustomObject]@{
        schemaVersion      = 2
        updatedAt          = (Get-Date).ToString("o")
        promptsPath        = $PromptsPath
        skillsPath         = $SkillsPath
        plugins            = $pluginEntries
        installedArtifacts = [PSCustomObject]@{
            promptTargets = @($InstalledPromptTargets | Sort-Object -Unique)
            skillTargets  = @($InstalledSkillTargets | Sort-Object -Unique)
        }
    }

    New-DirectoryIfMissing -Path (Split-Path -Parent $Path)
    $json = $state | ConvertTo-Json -Depth 8
    Set-Content -LiteralPath $Path -Value $json -Encoding UTF8
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

function Get-CopilotUserRoot {
    $homePath = [Environment]::GetFolderPath("UserProfile")
    if ([string]::IsNullOrWhiteSpace($homePath)) {
        $homePath = $HOME
    }

    return Join-Path $homePath ".copilot"
}

function ConvertFrom-SelectionInput {
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
            if ($AllowEmpty -and [string]::IsNullOrWhiteSpace($answerText)) {
                Write-Output -NoEnumerate @()
                return
            }
            try {
                return ConvertFrom-SelectionInput -InputValue $answerText -MaxIndex $Items.Count
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

    $useInteractive = $true
    try {
        if ([Console]::WindowHeight -le ($headerLines + 2) -or [Console]::WindowWidth -lt $minWidth) {
            $useInteractive = $false
        }
    }
    catch {
        $useInteractive = $false
    }

    if (-not $useInteractive) {
        for ($i = 0; $i -lt $Items.Count; $i++) {
            $n = $i + 1
            Write-Host ("[{0}] {1}" -f $n.ToString().PadLeft(2, " "), $Items[$i])
        }

        while ($true) {
            $suffix = if ($AllowEmpty) { " (Enter to skip)" } else { "" }
            $answerRaw = Read-Host "$Label (comma/range/all)$suffix"
            $answerText = if ($null -eq $answerRaw) { "" } else { [string]$answerRaw }
            if ($AllowEmpty -and [string]::IsNullOrWhiteSpace($answerText)) {
                Write-Output -NoEnumerate @()
                return
            }
            try {
                return ConvertFrom-SelectionInput -InputValue $answerText -MaxIndex $Items.Count
            }
            catch {
                Write-WarnLine $_.Exception.Message
            }
        }
    }

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
        if ($pageSize -lt 1) {
            $pageSize = 1
        }

        if ($cursor -lt $offset) {
            $offset = $cursor
        }
        elseif ($cursor -ge ($offset + $pageSize)) {
            $offset = $cursor - $pageSize + 1
        }
        if ($offset -lt 0) {
            $offset = 0
        }
        if ($offset -gt [Math]::Max($Items.Count - $pageSize, 0)) {
            $offset = [Math]::Max($Items.Count - $pageSize, 0)
        }

        Clear-Host
        Write-Host $Label -ForegroundColor Cyan
        Write-Host "Use Up/Down to move, Space to toggle, A=toggle all, I=invert, PgUp/PgDn/Home/End to navigate, Enter to confirm, Esc to clear" -ForegroundColor DarkGray
        $selectedCount = 0
        for ($i = 0; $i -lt $selected.Length; $i++) {
            if ($selected[$i]) {
                $selectedCount++
            }
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

        if ($Items.Count -gt $pageSize) {
            $rangeText = "{0}-{1} of {2}" -f ($offset + 1), ($end + 1), $Items.Count
            Write-Host ""
            Write-Host $rangeText -ForegroundColor DarkGray
        }

        $done = $false
        $key = [Console]::ReadKey($true)
        switch ($key.Key) {
            "UpArrow" {
                if ($cursor -gt 0) { $cursor-- }
            }
            "DownArrow" {
                if ($cursor -lt ($Items.Count - 1)) { $cursor++ }
            }
            "PageUp" {
                $cursor = [Math]::Max($cursor - $pageSize, 0)
            }
            "PageDown" {
                $cursor = [Math]::Min($cursor + $pageSize, $Items.Count - 1)
            }
            "Home" {
                $cursor = 0
            }
            "End" {
                $cursor = $Items.Count - 1
            }
            "Spacebar" {
                $selected[$cursor] = -not $selected[$cursor]
            }
            "Enter" {
                $done = $true
            }
            "Escape" {
                if ($AllowEmpty) {
                    for ($i = 0; $i -lt $selected.Length; $i++) {
                        $selected[$i] = $false
                    }
                    $done = $true
                }
            }
        }

        if ($done) {
            break
        }

        if ($key.KeyChar -eq "a" -or $key.KeyChar -eq "A") {
            $allSelected = $true
            for ($i = 0; $i -lt $selected.Length; $i++) {
                if (-not $selected[$i]) {
                    $allSelected = $false
                    break
                }
            }
            for ($i = 0; $i -lt $selected.Length; $i++) {
                $selected[$i] = -not $allSelected
            }
        }
        if ($key.KeyChar -eq "i" -or $key.KeyChar -eq "I") {
            for ($i = 0; $i -lt $selected.Length; $i++) {
                $selected[$i] = -not $selected[$i]
            }
        }
    }

    $indexes = @()
    for ($i = 0; $i -lt $selected.Length; $i++) {
        if ($selected[$i]) {
            $indexes += $i
        }
    }
    Write-Host ""
    Write-Output -NoEnumerate $indexes
    return
}

function Select-IndexFromList {
    param(
        [Parameter(Mandatory = $true)][array]$Items,
        [Parameter(Mandatory = $true)][string]$Label,
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
        Write-Host "Use Up/Down to move, Enter to select" -ForegroundColor DarkGray
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
    param()

    if (-not (Test-InteractiveConsole)) {
        return $null
    }

    $runtimeModes = @(
        "Install/add (overwrite existing)",
        "Update existing",
        "Dry run"
    )
    $runtimeModeIndex = Select-IndexFromList -Items $runtimeModes -Label "Select runtime mode"

    return [PSCustomObject]@{
        UpdateExisting = ($runtimeModeIndex -eq 1)
        DryRun         = ($runtimeModeIndex -eq 2)
        Force          = ($runtimeModeIndex -eq 0)
    }
}

function Select-FromList {
    param(
        [Parameter(Mandatory = $true)][array]$Items,
        [Parameter(Mandatory = $true)][string]$Label,
        [switch]$AllowEmpty,
        [switch]$PreselectAll
    )
    $indexes = Select-IndicesFromList -Items $Items -Label $Label -AllowEmpty:$AllowEmpty -PreselectAll:$PreselectAll
    $values = @()
    foreach ($idx in $indexes) {
        $values += $Items[$idx]
    }
    Write-Output -NoEnumerate $values
    return
}

function Select-ObjectsByPlugin {
    param(
        [Parameter(Mandatory = $true)][array]$Candidates,
        [Parameter(Mandatory = $true)][array]$SelectedPluginObjects,
        [Parameter(Mandatory = $true)][string]$KindLabel,
        [Parameter(Mandatory = $true)][bool]$ExplicitPluginList
    )

    if ($Candidates.Count -eq 0) {
        return @()
    }
    if ($ExplicitPluginList) {
        return $Candidates
    }

    $result = @()
    foreach ($plugin in $SelectedPluginObjects) {
        $pluginName = $plugin.Name
        $pluginCandidates = @($Candidates | Where-Object { $_.Plugin -eq $pluginName })
        if ($pluginCandidates.Count -eq 0) {
            continue
        }

        $displayItems = @($pluginCandidates | ForEach-Object { $_.Display })
        $pickedIndexes = Select-IndicesFromList -Items $displayItems -Label "[$pluginName] Select ${KindLabel} to install" -AllowEmpty -PreselectAll
        foreach ($idx in $pickedIndexes) {
            $result += $pluginCandidates[$idx]
        }
    }
    return $result
}

function Select-CandidatesByPlugin {
    param(
        [Parameter(Mandatory = $true)][array]$Candidates,
        [Parameter(Mandatory = $true)][array]$SelectedPluginObjects,
        [Parameter(Mandatory = $true)][string]$KindLabel,
        [Parameter(Mandatory = $true)][bool]$ExplicitPluginList
    )
    return Select-ObjectsByPlugin -Candidates $Candidates -SelectedPluginObjects $SelectedPluginObjects -KindLabel $KindLabel -ExplicitPluginList:$ExplicitPluginList
}

function Get-CandidateSet {
    param(
        [Parameter(Mandatory = $true)][array]$Plugins,
        [Parameter(Mandatory = $true)][bool]$IncludeAgents,
        [Parameter(Mandatory = $true)][bool]$IncludeCommands,
        [Parameter(Mandatory = $true)][bool]$IncludeSkills
    )

    $agents = @()
    $commands = @()
    $skills = @()

    foreach ($plugin in $Plugins) {
        if ($IncludeAgents) {
            foreach ($f in $plugin.AgentFiles) {
                $stem = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
                $agents += [PSCustomObject]@{
                    Plugin  = $plugin.Name
                    Stem    = $stem
                    Path    = $f.FullName
                    Display = $stem
                    Label   = "$($plugin.Name)/$stem"
                }
            }
        }

        if ($IncludeCommands) {
            foreach ($f in $plugin.CommandFiles) {
                $stem = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
                $commands += [PSCustomObject]@{
                    Plugin  = $plugin.Name
                    Stem    = $stem
                    Path    = $f.FullName
                    Display = $stem
                    Label   = "$($plugin.Name)/$stem"
                }
            }
        }

        if ($IncludeSkills) {
            foreach ($d in $plugin.SkillDirs) {
                $skills += [PSCustomObject]@{
                    Plugin  = $plugin.Name
                    Name    = $d.Name
                    Path    = $d.FullName
                    Display = $d.Name
                    Label   = "$($plugin.Name)/$($d.Name)"
                }
            }
        }
    }

    return [PSCustomObject]@{
        Agents   = $agents
        Commands = $commands
        Skills   = $skills
    }
}

function Resolve-SelectionsFromState {
    param(
        [Parameter(Mandatory = $true)][array]$Catalog,
        [Parameter(Mandatory = $true)]$State,
        [Parameter(Mandatory = $true)][bool]$IncludeAgents,
        [Parameter(Mandatory = $true)][bool]$IncludeCommands,
        [Parameter(Mandatory = $true)][bool]$IncludeSkills,
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

    $statePlugins = @()
    if ($State -and $State.plugins) {
        $statePlugins = @($State.plugins)
    }

    foreach ($entry in $statePlugins) {
        if (-not $entry.name) {
            continue
        }
        if ($filterSet -and -not $filterSet.Contains([string]$entry.name)) {
            continue
        }

        $plugin = $Catalog | Where-Object { $_.Name -eq $entry.name } | Select-Object -First 1
        if (-not $plugin) {
            Write-WarnLine "State references plugin '$($entry.name)' which is not available in source; skipping."
            continue
        }

        if ($selectedPluginNameSet.Add($plugin.Name)) {
            $selectedPlugins += $plugin
        }

        if ($IncludeAgents) {
            $hasAgentsProperty = ($entry.PSObject.Properties.Name -contains "agents")
            $wantedAgents = @()
            if ($hasAgentsProperty -and $entry.agents) {
                $wantedAgents = @($entry.agents | ForEach-Object { [string]$_ })
            }
            $selectAllAgents = -not $hasAgentsProperty
            foreach ($f in $plugin.AgentFiles) {
                $stem = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
                if ($selectAllAgents -or ($wantedAgents -contains $stem)) {
                    $selectedAgents += [PSCustomObject]@{
                        Plugin  = $plugin.Name
                        Stem    = $stem
                        Path    = $f.FullName
                        Display = $stem
                        Label   = "$($plugin.Name)/$stem"
                    }
                }
            }
        }

        if ($IncludeCommands) {
            $hasCommandsProperty = ($entry.PSObject.Properties.Name -contains "commands")
            $wantedCommands = @()
            if ($hasCommandsProperty -and $entry.commands) {
                $wantedCommands = @($entry.commands | ForEach-Object { [string]$_ })
            }
            $selectAllCommands = -not $hasCommandsProperty
            foreach ($f in $plugin.CommandFiles) {
                $stem = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
                if ($selectAllCommands -or ($wantedCommands -contains $stem)) {
                    $selectedCommands += [PSCustomObject]@{
                        Plugin  = $plugin.Name
                        Stem    = $stem
                        Path    = $f.FullName
                        Display = $stem
                        Label   = "$($plugin.Name)/$stem"
                    }
                }
            }
        }

        if ($IncludeSkills) {
            $hasSkillsProperty = ($entry.PSObject.Properties.Name -contains "skills")
            $wantedSkills = @()
            if ($hasSkillsProperty -and $entry.skills) {
                $wantedSkills = @($entry.skills | ForEach-Object { [string]$_ })
            }
            $selectAllSkills = -not $hasSkillsProperty
            foreach ($d in $plugin.SkillDirs) {
                if ($selectAllSkills -or ($wantedSkills -contains $d.Name)) {
                    $selectedSkills += [PSCustomObject]@{
                        Plugin  = $plugin.Name
                        Name    = $d.Name
                        Path    = $d.FullName
                        Display = $d.Name
                        Label   = "$($plugin.Name)/$($d.Name)"
                    }
                }
            }
        }
    }

    return [PSCustomObject]@{
        Plugins  = $selectedPlugins
        Agents   = $selectedAgents
        Commands = $selectedCommands
        Skills   = $selectedSkills
    }
}

function Select-InlineInstallItemSet {
    param(
        [Parameter(Mandatory = $true)][array]$Catalog,
        [Parameter(Mandatory = $true)][bool]$IncludeAgents,
        [Parameter(Mandatory = $true)][bool]$IncludeCommands,
        [Parameter(Mandatory = $true)][bool]$IncludeSkills,
        $InitialState = $null
    )

    $pluginStates = @()
    foreach ($plugin in $Catalog) {
        $children = @()

        if ($IncludeAgents) {
            foreach ($f in $plugin.AgentFiles) {
                $stem = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
                $candidate = [PSCustomObject]@{
                    Plugin  = $plugin.Name
                    Stem    = $stem
                    Path    = $f.FullName
                    Display = $stem
                    Label   = "$($plugin.Name)/$stem"
                }
                $children += [PSCustomObject]@{
                    Key       = "agent|$($plugin.Name)|$stem"
                    Kind      = "agent"
                    KindLabel = "agent"
                    Candidate = $candidate
                }
            }
        }

        if ($IncludeCommands) {
            foreach ($f in $plugin.CommandFiles) {
                $stem = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
                $candidate = [PSCustomObject]@{
                    Plugin  = $plugin.Name
                    Stem    = $stem
                    Path    = $f.FullName
                    Display = $stem
                    Label   = "$($plugin.Name)/$stem"
                }
                $children += [PSCustomObject]@{
                    Key       = "prompt|$($plugin.Name)|$stem"
                    Kind      = "prompt"
                    KindLabel = "command"
                    Candidate = $candidate
                }
            }
        }

        if ($children.Count -eq 0) {
            continue
        }

        $pluginStates += [PSCustomObject]@{
            Plugin   = $plugin
            Expanded = $false
            Children = $children
        }
    }

    if ($pluginStates.Count -eq 0) {
        return [PSCustomObject]@{
            Plugins  = @()
            Agents   = @()
            Commands = @()
            Skills   = @()
        }
    }

    $selectedKeys = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $preselectedPluginNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    if ($InitialState -and $InitialState.plugins) {
        foreach ($entry in @($InitialState.plugins)) {
            if (-not $entry.name) {
                continue
            }

            $pluginName = [string]$entry.name
            [void]$preselectedPluginNames.Add($pluginName)

            $hasAgentsProperty = ($entry.PSObject.Properties.Name -contains "agents")
            $wantedAgents = @()
            if ($hasAgentsProperty -and $entry.agents) {
                $wantedAgents = @($entry.agents | ForEach-Object { [string]$_ })
            }

            $hasCommandsProperty = ($entry.PSObject.Properties.Name -contains "commands")
            $wantedCommands = @()
            if ($hasCommandsProperty -and $entry.commands) {
                $wantedCommands = @($entry.commands | ForEach-Object { [string]$_ })
            }

            $selectAllAgents = -not $hasAgentsProperty
            $selectAllCommands = -not $hasCommandsProperty

            foreach ($state in $pluginStates) {
                if ($state.Plugin.Name -ne $pluginName) {
                    continue
                }

                foreach ($child in $state.Children) {
                    if ($child.Kind -eq "agent") {
                        if ($selectAllAgents -or ($wantedAgents -contains $child.Candidate.Stem)) {
                            [void]$selectedKeys.Add($child.Key)
                        }
                    }
                    elseif ($child.Kind -eq "prompt") {
                        if ($selectAllCommands -or ($wantedCommands -contains $child.Candidate.Stem)) {
                            [void]$selectedKeys.Add($child.Key)
                        }
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
    $selectionMutated = $false
    $clearAllRequested = $false
    $visiblePluginNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($state in $pluginStates) {
        [void]$visiblePluginNames.Add($state.Plugin.Name)
    }

    while ($true) {
        $rows = @()
        foreach ($state in $pluginStates) {
            $rows += [PSCustomObject]@{
                RowType = "plugin"
                State   = $state
            }
            if ($state.Expanded) {
                foreach ($child in $state.Children) {
                    $rows += [PSCustomObject]@{
                        RowType = "child"
                        State   = $state
                        Child   = $child
                    }
                }
            }
        }

        if ($rows.Count -eq 0) {
            break
        }

        if ($cursor -lt 0) {
            $cursor = 0
        }
        if ($cursor -ge $rows.Count) {
            $cursor = $rows.Count - 1
        }

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
        if ($pageSize -lt 1) {
            $pageSize = 1
        }

        if ($cursor -lt $offset) {
            $offset = $cursor
        }
        elseif ($cursor -ge ($offset + $pageSize)) {
            $offset = $cursor - $pageSize + 1
        }
        if ($offset -lt 0) {
            $offset = 0
        }
        if ($offset -gt [Math]::Max($rows.Count - $pageSize, 0)) {
            $offset = [Math]::Max($rows.Count - $pageSize, 0)
        }

        $selectedCount = $selectedKeys.Count
        $totalCount = 0
        foreach ($state in $pluginStates) {
            $totalCount += $state.Children.Count
        }

        Clear-Host
        Write-Host "Select plugins and items to install" -ForegroundColor Cyan
        Write-Host "Expand plugins inline and select agents/commands. Skills install automatically for selected plugins." -ForegroundColor DarkGray
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
                    if ($selectedKeys.Contains($child.Key)) {
                        $sel++
                    }
                }
                $mark = "[ ]"
                $lineColor = "Cyan"
                if ($sel -gt 0 -and $sel -lt $state.Children.Count) {
                    $mark = "[-]"
                    $lineColor = "Yellow"
                }
                elseif ($sel -eq $state.Children.Count) {
                    $mark = "[x]"
                    $lineColor = "Green"
                }
                $expander = if ($state.Expanded) { "v" } else { ">" }
                $lineText = "$pointer $mark $expander $($state.Plugin.Name) ($sel/$($state.Children.Count))"
            }
            else {
                $child = $row.Child
                $isSelected = $selectedKeys.Contains($child.Key)
                $check = if ($isSelected) { "[x]" } else { "[ ]" }
                $label = $child.Candidate.Display
                $lineText = "$pointer    $check [$($child.KindLabel)] $label"
                $lineColor = if ($isSelected) { "Green" } else { "Gray" }
            }

            if ($lineText.Length -gt $width) {
                $lineText = $lineText.Substring(0, $width - 3) + "..."
            }
            Write-Host $lineText -ForegroundColor $lineColor
        }

        if ($rows.Count -gt $pageSize) {
            $rangeText = "{0}-{1} of {2}" -f ($offset + 1), ($end + 1), $rows.Count
            Write-Host ""
            Write-Host $rangeText -ForegroundColor DarkGray
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
                "RightArrow" {
                    if ($rowAtCursor.RowType -eq "plugin") {
                        $rowAtCursor.State.Expanded = $true
                    }
                }
                "LeftArrow" {
                    if ($rowAtCursor.RowType -eq "plugin") {
                        $rowAtCursor.State.Expanded = $false
                    }
                }
                "Spacebar" {
                    if ($rowAtCursor.RowType -eq "plugin") {
                        $rowAtCursor.State.Expanded = -not $rowAtCursor.State.Expanded
                    }
                    else {
                        $selectionMutated = $true
                        $k = $rowAtCursor.Child.Key
                        if ($selectedKeys.Contains($k)) {
                            [void]$selectedKeys.Remove($k)
                        }
                        else {
                            [void]$selectedKeys.Add($k)
                        }
                    }
                }
                "Enter" { $done = $true }
                "Escape" {
                    $selectionMutated = $true
                    $clearAllRequested = $true
                    $selectedKeys.Clear()
                    $done = $true
                }
            }
        }

        if (-not $done -and ($key.KeyChar -eq "t" -or $key.KeyChar -eq "T")) {
            if ($rowAtCursor.RowType -eq "plugin") {
                $selectionMutated = $true
                $state = $rowAtCursor.State
                $allSelected = $true
                foreach ($child in $state.Children) {
                    if (-not $selectedKeys.Contains($child.Key)) {
                        $allSelected = $false
                        break
                    }
                }
                foreach ($child in $state.Children) {
                    if ($allSelected) {
                        [void]$selectedKeys.Remove($child.Key)
                    }
                    else {
                        [void]$selectedKeys.Add($child.Key)
                    }
                }
            }
        }

        if (-not $done -and ($key.KeyChar -eq "a" -or $key.KeyChar -eq "A")) {
            $selectionMutated = $true
            $allSelected = $true
            foreach ($state in $pluginStates) {
                foreach ($child in $state.Children) {
                    if (-not $selectedKeys.Contains($child.Key)) {
                        $allSelected = $false
                        break
                    }
                }
                if (-not $allSelected) {
                    break
                }
            }
            foreach ($state in $pluginStates) {
                foreach ($child in $state.Children) {
                    if ($allSelected) {
                        [void]$selectedKeys.Remove($child.Key)
                    }
                    else {
                        [void]$selectedKeys.Add($child.Key)
                    }
                }
            }
        }

        if (-not $done -and ($key.KeyChar -eq "i" -or $key.KeyChar -eq "I")) {
            $selectionMutated = $true
            foreach ($state in $pluginStates) {
                foreach ($child in $state.Children) {
                    if ($selectedKeys.Contains($child.Key)) {
                        [void]$selectedKeys.Remove($child.Key)
                    }
                    else {
                        [void]$selectedKeys.Add($child.Key)
                    }
                }
            }
        }

        if ($done) {
            break
        }
    }

    $selectedAgents = @()
    $selectedCommands = @()
    $selectedSkills = @()
    $selectedPluginNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    foreach ($state in $pluginStates) {
        foreach ($child in $state.Children) {
            if (-not $selectedKeys.Contains($child.Key)) {
                continue
            }

            [void]$selectedPluginNames.Add($state.Plugin.Name)
            switch ($child.Kind) {
                "agent" { $selectedAgents += $child.Candidate }
                "prompt" { $selectedCommands += $child.Candidate }
            }
        }
    }

    if (-not $clearAllRequested) {
        foreach ($pluginName in $preselectedPluginNames) {
            if (-not $visiblePluginNames.Contains($pluginName)) {
                [void]$selectedPluginNames.Add($pluginName)
            }
        }
        if (-not $selectionMutated) {
            foreach ($pluginName in $preselectedPluginNames) {
                [void]$selectedPluginNames.Add($pluginName)
            }
        }
    }

    $selectedPlugins = @($Catalog | Where-Object { $selectedPluginNames.Contains($_.Name) })
    if ($IncludeSkills) {
        foreach ($plugin in $selectedPlugins) {
            foreach ($d in $plugin.SkillDirs) {
                $selectedSkills += [PSCustomObject]@{
                    Plugin  = $plugin.Name
                    Name    = $d.Name
                    Path    = $d.FullName
                    Display = $d.Name
                    Label   = "$($plugin.Name)/$($d.Name)"
                }
            }
        }
    }

    return [PSCustomObject]@{
        Plugins       = $selectedPlugins
        Agents        = $selectedAgents
        Commands      = $selectedCommands
        Skills        = $selectedSkills
        BackRequested = $goBack
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

    New-DirectoryIfMissing -Path (Split-Path -Parent $DestinationPath)
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
    New-DirectoryIfMissing -Path (Split-Path -Parent $DestinationPath)
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
    foreach ($targetPath in @($Targets)) {
        $normalized = Normalize-InstallTargetPath -Path ([string]$targetPath)
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
        [Parameter(Mandatory = $true)][ValidateSet("promptTargets", "skillTargets")] [string]$PropertyName,
        [string]$PromptsPath = "",
        [string]$SkillsPath = ""
    )

    $targets = @()
    if (
        $State -and
        ($State.PSObject.Properties.Name -contains "installedArtifacts") -and
        $State.installedArtifacts -and
        ($State.installedArtifacts.PSObject.Properties.Name -contains $PropertyName)
    ) {
        foreach ($targetPath in @($State.installedArtifacts.$PropertyName)) {
            if (-not [string]::IsNullOrWhiteSpace([string]$targetPath)) {
                $targets += [string]$targetPath
            }
        }
    }

    if ($targets.Count -gt 0) {
        return $targets
    }

    if (-not $State -or -not ($State.PSObject.Properties.Name -contains "plugins")) {
        return @()
    }

    foreach ($pluginEntry in @($State.plugins)) {
        if (-not $pluginEntry) {
            continue
        }

        if ($PropertyName -eq "promptTargets") {
            if (-not [string]::IsNullOrWhiteSpace($PromptsPath)) {
                foreach ($agentStem in @($pluginEntry.agents)) {
                    if ([string]::IsNullOrWhiteSpace([string]$agentStem)) {
                        continue
                    }
                    $artifactName = Resolve-ArtifactName -Stem ([string]$agentStem) -Kind "agent"
                    if ([string]::IsNullOrWhiteSpace($artifactName)) {
                        continue
                    }
                    $targets += (Join-Path $PromptsPath $artifactName)
                }
                foreach ($commandStem in @($pluginEntry.commands)) {
                    if ([string]::IsNullOrWhiteSpace([string]$commandStem)) {
                        continue
                    }
                    $artifactName = Resolve-ArtifactName -Stem ([string]$commandStem) -Kind "prompt"
                    if ([string]::IsNullOrWhiteSpace($artifactName)) {
                        continue
                    }
                    $targets += (Join-Path $PromptsPath $artifactName)
                }
            }
        }
        elseif ($PropertyName -eq "skillTargets") {
            if (-not [string]::IsNullOrWhiteSpace($SkillsPath)) {
                foreach ($skillName in @($pluginEntry.skills)) {
                    if ([string]::IsNullOrWhiteSpace([string]$skillName)) {
                        continue
                    }
                    $targets += (Join-Path $SkillsPath ([string]$skillName))
                }
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

try {
    $script:CopilotConverterKeepDownloadedSource = $KeepDownloadedSource
    Register-CleanupHandler
    Clear-StaleTempFolderCache

    $pluginsRoot = $null
    $resolvedRepoRoot = $null

    $localRepoCandidate = $RepoRoot
    if ([string]::IsNullOrWhiteSpace($localRepoCandidate)) {
        if ($PSScriptRoot) {
            $localRepoCandidate = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
        }
        else {
            $localRepoCandidate = (Get-Location).Path
        }
    }

    if ($SourceMode -in @("Auto", "Local")) {
        $localPlugins = Resolve-PluginsRootFromRepoRoot -CandidateRepoRoot $localRepoCandidate
        if ($localPlugins) {
            $pluginsRoot = $localPlugins
            $resolvedRepoRoot = $localRepoCandidate
            Write-Info "Using local source repository: $resolvedRepoRoot"
        }
        elseif ($SourceMode -eq "Local") {
            throw "Local source mode requested, but no plugins directory was found under '$localRepoCandidate'."
        }
    }

    if (-not $pluginsRoot -and $SourceMode -in @("Auto", "Remote")) {
        $cacheRoot = Get-CopilotConverterCacheRoot -OverridePath $SourceCacheRoot
        New-DirectoryIfMissing -Path $cacheRoot

        $urlHash = Get-StringSha256 -InputText $RemoteArchiveUrl
        $cachePath = Join-Path $cacheRoot ("source-" + $urlHash)
        New-DirectoryIfMissing -Path $cachePath

        $zipPath = Join-Path $cachePath "source.zip"
        $extractPath = Join-Path $cachePath "extract"
        $metaPath = Join-Path $cachePath "metadata.json"

        if ($KeepDownloadedSource) {
            Write-WarnLine "-KeepDownloadedSource is no longer needed. Remote source is cached persistently at '$cachePath'."
        }

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
        $headResponse = $null
        $headEtag = $null
        $headLastModified = $null

        if ($hasCachedZip) {
            try {
                Write-Info "Checking remote archive metadata (HEAD): $RemoteArchiveUrl"
                $headResponse = Invoke-WebRequest -Uri $RemoteArchiveUrl -Method Head -MaximumRedirection 5
                $headEtag = Get-HeaderValue -Headers $headResponse.Headers -Name "ETag"
                $headLastModified = Get-HeaderValue -Headers $headResponse.Headers -Name "Last-Modified"

                $cachedEtag = $null
                $cachedLastModified = $null
                if ($cacheMeta) {
                    if ($cacheMeta.etag) {
                        $cachedEtag = [string]$cacheMeta.etag
                    }
                    if ($cacheMeta.lastModified) {
                        $cachedLastModified = [string]$cacheMeta.lastModified
                    }
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
            Write-Info "Downloading source archive: $RemoteArchiveUrl"
            $downloadResponse = Invoke-WebRequest -Uri $RemoteArchiveUrl -OutFile $zipPath -PassThru
            $downloadEtag = Get-HeaderValue -Headers $downloadResponse.Headers -Name "ETag"
            $downloadLastModified = Get-HeaderValue -Headers $downloadResponse.Headers -Name "Last-Modified"

            $cacheMetaOut = [PSCustomObject]@{
                remoteArchiveUrl = $RemoteArchiveUrl
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
            New-DirectoryIfMissing -Path $extractPath
            Expand-Archive -LiteralPath $zipPath -DestinationPath $extractPath -Force
        }

        $extractedRoots = @(Get-ChildItem -LiteralPath $extractPath -Directory | Sort-Object Name)
        if ($extractedRoots.Count -eq 0) {
            throw "Archive extracted but no repository directory was found in cache path '$extractPath'."
        }
        $resolvedRepoRoot = $extractedRoots[0].FullName
        $pluginsRoot = Resolve-PluginsRootFromRepoRoot -CandidateRepoRoot $resolvedRepoRoot
        if (-not $pluginsRoot) {
            throw "Cached archive does not contain a 'plugins' directory under '$resolvedRepoRoot'."
        }
        Write-Info "Using cached source repository: $resolvedRepoRoot"
    }

    if (-not $pluginsRoot) {
        throw "Could not resolve plugin source. Try -SourceMode Remote or provide -RepoRoot."
    }

    $catalog = @()
    foreach ($pluginDir in (Get-ChildItem -LiteralPath $pluginsRoot -Directory | Sort-Object Name)) {
        $agentsPath = Join-Path $pluginDir.FullName "agents"
        $commandsPath = Join-Path $pluginDir.FullName "commands"
        $skillsPathLocal = Join-Path $pluginDir.FullName "skills"

        $agentFiles = @()
        $commandFiles = @()
        $skillDirs = @()

        if (Test-Path -LiteralPath $agentsPath) {
            $agentFiles = @(Get-ChildItem -LiteralPath $agentsPath -File -Filter "*.md" | Sort-Object Name)
        }
        if (Test-Path -LiteralPath $commandsPath) {
            $commandFiles = @(Get-ChildItem -LiteralPath $commandsPath -File -Filter "*.md" | Sort-Object Name)
        }
        if (Test-Path -LiteralPath $skillsPathLocal) {
            foreach ($skillDir in (Get-ChildItem -LiteralPath $skillsPathLocal -Directory | Sort-Object Name)) {
                if (Test-Path -LiteralPath (Join-Path $skillDir.FullName "SKILL.md")) {
                    $skillDirs += $skillDir
                }
            }
        }

        if ($agentFiles.Count -gt 0 -or $commandFiles.Count -gt 0 -or $skillDirs.Count -gt 0) {
            $catalog += [PSCustomObject]@{
                Name         = $pluginDir.Name
                Path         = $pluginDir.FullName
                AgentFiles   = $agentFiles
                CommandFiles = $commandFiles
                SkillDirs    = $skillDirs
            }
        }
    }

    if ($catalog.Count -eq 0) {
        throw "No plugins with agents/commands/skills found under $pluginsRoot"
    }

    Write-Section "Source"
    Write-KeyValueLine -Label "Repository" -Value $resolvedRepoRoot -ValueColor "Cyan"
    Write-KeyValueLine -Label "Plugins discovered" -Value ([string]$catalog.Count) -ValueColor "Green"

    $interactiveRunConfigSelected = $false
    if ($Target -eq "Interactive" -and (Test-InteractiveConsole)) {
        Write-Info "Configure runtime options (plugin tree selection is always used in this mode)."
        $runConfig = Select-RunConfiguration
        $UpdateExisting = $runConfig.UpdateExisting
        $DryRun = $runConfig.DryRun
        $Force = $runConfig.Force
        $interactiveRunConfigSelected = $true
    }

    # This installer is always plugin-first: install selections can include
    # agents and commands inline, and skills from selected plugins.
    $IncludeAgents = $true
    $IncludeCommands = $true
    $IncludeSkills = $true

    $updateExistingProvided = $PSBoundParameters.ContainsKey("UpdateExisting")
    if ($interactiveRunConfigSelected) {
        $updateExistingProvided = $true
    }
    $explicitPluginList = ($Plugins -and $Plugins.Count -gt 0)
    $canSelectInlineItems = $true

    $selectedPlugins = @()
    $selectedAgents = @()
    $selectedCommands = @()
    $selectedSkills = @()
    $usedInlineSelector = $false

    if ($explicitPluginList -and -not $UpdateExisting) {
        $wanted = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($p in $Plugins) {
            if (-not [string]::IsNullOrWhiteSpace($p)) {
                [void]$wanted.Add($p.Trim())
            }
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
        if (-not $explicitPluginList -or $UpdateExisting) {
            $selectedPlugins = @()
        }

        if ($Target -eq "Interactive") {
            $scopeAnswer = Read-Host "Target location: [W]orkspace, [U]serVSCode, [C]ustom (default: W)"
            $scopeAnswerText = if ($null -eq $scopeAnswer) { "" } else { [string]$scopeAnswer }
            switch ($scopeAnswerText.Trim().ToUpperInvariant()) {
                "U" { $Target = "UserVSCode" }
                "C" { $Target = "Custom" }
                default { $Target = "Workspace" }
            }
        }

        $resolvedTarget = $Target

        switch ($resolvedTarget) {
            "Workspace" {
                if (-not $WorkspaceRoot) {
                    $WorkspaceRoot = (Get-Location).Path
                }
                $PromptsPath = Join-Path $WorkspaceRoot ".github/prompts"
                $SkillsPath = Join-Path $WorkspaceRoot ".github/skills"
            }
            "UserVSCode" {
                $userRoot = Get-VSCodeUserRoot
                $PromptsPath = Join-Path $userRoot "prompts"
                $SkillsPath = Join-Path (Get-CopilotUserRoot) "skills"
            }
            "Custom" {
                if (-not $PromptsPath) {
                    $PromptsPath = Read-Host "Enter prompts target path"
                }
                if (-not $SkillsPath) {
                    $SkillsPath = Read-Host "Enter skills target path"
                }
            }
            default {
                throw "Unsupported target: $Target"
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
        if ($initialTargetMode -eq "Interactive" -and (Test-InteractiveConsole) -and (-not $updateExistingProvided)) {
            $modeAnswer = Read-Host "Operation mode: [I]nstall/add selections, [U]pdate existing (default: I)"
            $modeAnswerText = if ($null -eq $modeAnswer) { "" } else { [string]$modeAnswer }
            $UpdateExisting = $modeAnswerText.Trim().ToUpperInvariant() -eq "U"
            $modeChosenInteractively = $true
        }

        if ($UpdateExisting) {
            Write-Info "Operation mode: Update existing"
        }
        else {
            Write-Info "Operation mode: Install/add"
        }

        $interactiveSelectorEnabled = (-not $explicitPluginList) -and (-not $UpdateExisting) -and $canSelectInlineItems -and (Test-InteractiveConsole)

        if (-not $DryRun) {
            New-DirectoryIfMissing -Path $PromptsPath
            New-DirectoryIfMissing -Path $SkillsPath
        }

        $existingState = $null
        if (Test-Path -LiteralPath $StateFilePath) {
            $existingState = Read-InstallState -Path $StateFilePath
            if (-not $UpdateExisting) {
                Write-Info "Loaded existing state for default plugin/item selections."
            }
        }

        if ($UpdateExisting) {
            if (-not $existingState) {
                if ($modeChosenInteractively) {
                    Write-WarnLine "No state file found for update mode at '$StateFilePath'. Switching to install/add mode."
                    $UpdateExisting = $false
                    $interactiveSelectorEnabled = (-not $explicitPluginList) -and $canSelectInlineItems -and (Test-InteractiveConsole)
                }
                else {
                    throw "Update mode requires an existing state file at '$StateFilePath'. Run a normal install first."
                }
            }
        }

        if ($UpdateExisting) {

            $pluginFilter = @()
            if ($explicitPluginList) {
                $wanted = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
                foreach ($p in $Plugins) {
                    if (-not [string]::IsNullOrWhiteSpace($p)) {
                        [void]$wanted.Add($p.Trim())
                    }
                }
                $missing = @($wanted | Where-Object { -not ($catalog.Name -contains $_) })
                if ($missing.Count -gt 0) {
                    throw "Unknown plugin(s): $($missing -join ', ')"
                }
                $pluginFilter = @($wanted)
            }

            $stateSelection = Resolve-SelectionsFromState -Catalog $catalog -State $existingState -IncludeAgents:$IncludeAgents -IncludeCommands:$IncludeCommands -IncludeSkills:$IncludeSkills -PluginFilter $pluginFilter
            $selectedPlugins = @($stateSelection.Plugins)
            $selectedAgents = @($stateSelection.Agents)
            $selectedCommands = @($stateSelection.Commands)
            $selectedSkills = @($stateSelection.Skills)
            $usedInlineSelector = $true
        }
        elseif ($interactiveSelectorEnabled) {
            $inlineSelection = Select-InlineInstallItemSet -Catalog $catalog -IncludeAgents:$IncludeAgents -IncludeCommands:$IncludeCommands -IncludeSkills:$IncludeSkills -InitialState $existingState
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
            $selectedSkills = @($inlineSelection.Skills)
            $usedInlineSelector = $true
        }
        elseif (-not $explicitPluginList) {
            $pluginLabels = @($catalog | ForEach-Object { "$($_.Name) (agents=$($_.AgentFiles.Count), commands=$($_.CommandFiles.Count), skills=$($_.SkillDirs.Count))" })
            $preselectedPluginIndexes = @()
            if ($existingState -and $existingState.plugins) {
                $statePluginNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
                foreach ($entry in @($existingState.plugins)) {
                    if ($entry.name) {
                        [void]$statePluginNames.Add([string]$entry.name)
                    }
                }
                for ($i = 0; $i -lt $catalog.Count; $i++) {
                    if ($statePluginNames.Contains($catalog[$i].Name)) {
                        $preselectedPluginIndexes += $i
                    }
                }
            }
            $chosenIndexes = Select-IndicesFromList -Items $pluginLabels -Label "Select plugin(s) to install" -PreselectedIndexes $preselectedPluginIndexes -AllowEmpty
            $selectedPlugins = @($chosenIndexes | ForEach-Object { $catalog[$_] })
        }

        break
    }

    $selectionIsEmpty = (
        $selectedPlugins.Count -eq 0 -and
        $selectedAgents.Count -eq 0 -and
        $selectedCommands.Count -eq 0 -and
        $selectedSkills.Count -eq 0
    )
    if ($selectionIsEmpty -and -not $UpdateExisting) {
        Write-Info "No items selected; proceeding to remove deselected previously installed targets (if any)."
    }

    if (-not $usedInlineSelector) {
        $candidates = Get-CandidateSet -Plugins $selectedPlugins -IncludeAgents:$IncludeAgents -IncludeCommands:$IncludeCommands -IncludeSkills:$IncludeSkills
        $agentCandidates = @($candidates.Agents)
        $commandCandidates = @($candidates.Commands)
        $skillCandidates = @($candidates.Skills)

        if ($IncludeAgents -and $agentCandidates.Count -gt 0) {
            $selectedAgents = Select-CandidatesByPlugin -Candidates $agentCandidates -SelectedPluginObjects $selectedPlugins -KindLabel "agents" -ExplicitPluginList:$explicitPluginList
        }

        if ($IncludeCommands -and $commandCandidates.Count -gt 0) {
            $selectedCommands = Select-CandidatesByPlugin -Candidates $commandCandidates -SelectedPluginObjects $selectedPlugins -KindLabel "commands" -ExplicitPluginList:$explicitPluginList
        }

        if ($IncludeSkills -and $skillCandidates.Count -gt 0) {
            $selectedSkills = @($skillCandidates)
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
    $effectiveForce = $Force -or $UpdateExisting -or $overwriteExistingFromSelectionFlow

    if ($overwriteExistingFromSelectionFlow) {
        Write-Info "Overwrite enabled for interactive selection flow."
    }

    $desiredPromptTargets = @()
    foreach ($item in $selectedAgents) {
        $artifactName = Resolve-ArtifactName -Stem $item.Stem -Kind "agent"
        if ([string]::IsNullOrWhiteSpace($artifactName)) {
            Write-WarnLine "Skipped agent with empty artifact name (plugin=$($item.Plugin), stem=$($item.Stem))."
            continue
        }
        $desiredPromptTargets += (Join-Path $PromptsPath $artifactName)
    }
    foreach ($item in $selectedCommands) {
        $artifactName = Resolve-ArtifactName -Stem $item.Stem -Kind "prompt"
        if ([string]::IsNullOrWhiteSpace($artifactName)) {
            Write-WarnLine "Skipped command with empty artifact name (plugin=$($item.Plugin), stem=$($item.Stem))."
            continue
        }
        $desiredPromptTargets += (Join-Path $PromptsPath $artifactName)
    }

    $desiredSkillTargets = @()
    foreach ($item in $selectedSkills) {
        $desiredSkillTargets += (Join-Path $SkillsPath $item.Name)
    }

    if (-not $UpdateExisting) {
        $previousPromptTargets = @(Get-InstalledTargetsFromState -State $existingState -PropertyName "promptTargets" -PromptsPath $PromptsPath -SkillsPath $SkillsPath)
        $previousSkillTargets = @(Get-InstalledTargetsFromState -State $existingState -PropertyName "skillTargets" -PromptsPath $PromptsPath -SkillsPath $SkillsPath)

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
            Write-WarnLine "Skipped agent install with empty artifact name (plugin=$($item.Plugin), stem=$($item.Stem))."
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
            Write-WarnLine "Skipped command install with empty artifact name (plugin=$($item.Plugin), stem=$($item.Stem))."
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
        Write-InstallState -Path $StateFilePath -PromptsPath $PromptsPath -SkillsPath $SkillsPath -SelectedPlugins $selectedPlugins -SelectedAgents $selectedAgents -SelectedCommands $selectedCommands -SelectedSkills $selectedSkills -InstalledPromptTargets $installedPromptTargets -InstalledSkillTargets $installedSkillTargets
    }

    Write-Section "Install Summary"
    Write-KeyValueLine -Label "Plugins selected" -Value ([string]$selectedPlugins.Count) -ValueColor "White"
    Write-KeyValueLine -Label "Agents selected" -Value ([string]$selectedAgents.Count) -ValueColor "White"
    Write-KeyValueLine -Label "Commands selected" -Value ([string]$selectedCommands.Count) -ValueColor "White"
    Write-KeyValueLine -Label "Skills selected" -Value ([string]$selectedSkills.Count) -ValueColor "White"
    Write-KeyValueLine -Label "Prompt files written" -Value ([string]$fileInstallCount) -ValueColor "Green"
    Write-KeyValueLine -Label "Skill directories written" -Value ([string]$skillInstallCount) -ValueColor "Green"
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
}
finally {
    Invoke-TempCleanup
    Unregister-CleanupHandler
}
