<#
.SYNOPSIS
Install converted plugin content as VS Code fallback artifacts.

.DESCRIPTION
For users who cannot use Copilot CLI plugin marketplaces yet, this script copies:
- `plugins/*/agents/*.md` -> `<prompts>/<name>.agent.md`
- `plugins/*/commands/*.md` -> `<prompts>/<name>.prompt.md`
- `plugins/*/skills/<skill-dir>` -> `<skills>/<skill-dir>`

It supports interactive selection of plugins, categories, and items, and lets you
target workspace, user-level, copilot-level, or custom directories.

.EXAMPLE
pwsh -File ./scripts/install-vscode-fallback.ps1

.EXAMPLE
# Run directly from GitHub (no clone, no git required)
irm https://raw.githubusercontent.com/sla-te/copilot-converter/main/scripts/install-vscode-fallback.ps1 | iex

.EXAMPLE
pwsh -File ./scripts/install-vscode-fallback.ps1 -Target Workspace -WorkspaceRoot C:\src\my-repo -Plugins backend-development,conductor -DryRun
#>

[CmdletBinding()]
param(
    [string]$RepoRoot = "",
    [ValidateSet("Auto", "Local", "Remote")]
    [string]$SourceMode = "Auto",
    [string]$RemoteArchiveUrl = "https://github.com/sla-te/copilot-converter/archive/refs/heads/main.zip",
    [switch]$KeepDownloadedSource,
    [ValidateSet("Interactive", "Workspace", "UserVSCode", "UserCopilot", "Custom")]
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
    [bool]$PrefixWithPlugin = $true
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

function Ensure-Directory {
    param([Parameter(Mandatory = $true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Get-VSCodeUserRoot {
    if ($IsWindows) {
        if (-not $env:APPDATA) {
            throw "APPDATA is not set. Provide -PromptsPath and -SkillsPath (Target=Custom)."
        }
        return Join-Path $env:APPDATA "Code\User"
    }
    if ($IsMacOS) {
        return Join-Path $HOME "Library/Application Support/Code/User"
    }
    return Join-Path $HOME ".config/Code/User"
}

function Get-CopilotUserRoot {
    if ($IsWindows) {
        return Join-Path $env:USERPROFILE ".copilot"
    }
    return Join-Path $HOME ".copilot"
}

function Parse-SelectionInput {
    param(
        [Parameter(Mandatory = $true)][string]$InputValue,
        [Parameter(Mandatory = $true)][int]$MaxIndex
    )

    $raw = $InputValue.Trim().ToLowerInvariant()
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
    return @($indexes | Sort-Object)
}

function Select-FromList {
    param(
        [Parameter(Mandatory = $true)][array]$Items,
        [Parameter(Mandatory = $true)][string]$Label,
        [switch]$AllowEmpty
    )

    if ($Items.Count -eq 0) {
        return @()
    }

    for ($i = 0; $i -lt $Items.Count; $i++) {
        $n = $i + 1
        Write-Host ("[{0}] {1}" -f $n.ToString().PadLeft(2, " "), $Items[$i])
    }

    while ($true) {
        $suffix = if ($AllowEmpty) { " (Enter to skip)" } else { "" }
        $answer = Read-Host "$Label (comma/range/all)$suffix"
        if ($AllowEmpty -and [string]::IsNullOrWhiteSpace($answer)) {
            return @()
        }
        try {
            $selectedIndexes = Parse-SelectionInput -InputValue $answer -MaxIndex $Items.Count
            return @($selectedIndexes | ForEach-Object { $Items[$_] })
        }
        catch {
            Write-WarnLine $_.Exception.Message
        }
    }
}

function Resolve-ArtifactName {
    param(
        [Parameter(Mandatory = $true)][string]$Plugin,
        [Parameter(Mandatory = $true)][string]$Stem,
        [Parameter(Mandatory = $true)][ValidateSet("agent", "prompt")] [string]$Kind,
        [Parameter(Mandatory = $true)][bool]$UsePrefix
    )

    $base = $Stem
    if ($base.EndsWith(".agent", [System.StringComparison]::OrdinalIgnoreCase)) {
        $base = $base.Substring(0, $base.Length - 6)
    }
    if ($base.EndsWith(".prompt", [System.StringComparison]::OrdinalIgnoreCase)) {
        $base = $base.Substring(0, $base.Length - 7)
    }

    if ($UsePrefix -and -not $base.StartsWith("$Plugin`__", [System.StringComparison]::OrdinalIgnoreCase)) {
        $base = "$Plugin`__$base"
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
        Write-Info "[DryRun] Copy file: '$SourcePath' -> '$DestinationPath'"
        return $true
    }

    Ensure-Directory -Path (Split-Path -Parent $DestinationPath)
    Copy-Item -LiteralPath $SourcePath -Destination $DestinationPath -Force:$Overwrite
    Write-Info "Copied file: '$SourcePath' -> '$DestinationPath'"
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
        Write-Info "[DryRun] Copy dir: '$SourcePath' -> '$DestinationPath'"
        return $true
    }

    if (Test-Path -LiteralPath $DestinationPath) {
        Remove-Item -LiteralPath $DestinationPath -Recurse -Force
    }
    Ensure-Directory -Path (Split-Path -Parent $DestinationPath)
    Copy-Item -LiteralPath $SourcePath -Destination $DestinationPath -Recurse
    Write-Info "Copied dir: '$SourcePath' -> '$DestinationPath'"
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

$cleanupPath = $null

try {
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
        $cleanupPath = Join-Path ([System.IO.Path]::GetTempPath()) ("copilot-converter-source-" + [Guid]::NewGuid().ToString("N"))
        $zipPath = Join-Path $cleanupPath "source.zip"
        $extractPath = Join-Path $cleanupPath "extract"
        Ensure-Directory -Path $cleanupPath
        Ensure-Directory -Path $extractPath

        Write-Info "Downloading source archive: $RemoteArchiveUrl"
        Invoke-WebRequest -Uri $RemoteArchiveUrl -OutFile $zipPath
        Expand-Archive -LiteralPath $zipPath -DestinationPath $extractPath -Force

        $extractedRoots = @(Get-ChildItem -LiteralPath $extractPath -Directory | Sort-Object Name)
        if ($extractedRoots.Count -eq 0) {
            throw "Archive extracted but no repository directory was found."
        }
        $resolvedRepoRoot = $extractedRoots[0].FullName
        $pluginsRoot = Resolve-PluginsRootFromRepoRoot -CandidateRepoRoot $resolvedRepoRoot
        if (-not $pluginsRoot) {
            throw "Downloaded archive does not contain a 'plugins' directory under '$resolvedRepoRoot'."
        }
        Write-Info "Using downloaded source repository: $resolvedRepoRoot"
        if ($KeepDownloadedSource) {
            Write-WarnLine "Keeping downloaded source at: $cleanupPath"
        }
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

    Write-Info "Discovered $($catalog.Count) plugins under '$pluginsRoot'."

    $selectedPlugins = @()
    if ($Plugins -and $Plugins.Count -gt 0) {
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
    else {
        $pluginLabels = @($catalog | ForEach-Object { "$($_.Name) (agents=$($_.AgentFiles.Count), commands=$($_.CommandFiles.Count), skills=$($_.SkillDirs.Count))" })
        $chosenLabels = Select-FromList -Items $pluginLabels -Label "Select plugin(s) to install"
        $chosenNames = @($chosenLabels | ForEach-Object { ($_ -split " ")[0] })
        $selectedPlugins = @($catalog | Where-Object { $chosenNames -contains $_.Name })
    }

    if ($selectedPlugins.Count -eq 0) {
        throw "No plugins selected."
    }

    if (-not $IncludeAgents -and -not $IncludeCommands -and -not $IncludeSkills) {
        $IncludeAgents = $true
        $IncludeCommands = $true
        $IncludeSkills = $true
    }

    if ($Target -eq "Interactive") {
        $scopeAnswer = Read-Host "Target location: [W]orkspace, [U]serVSCode, [C]ustom, user-[P]copilot (default: W)"
        switch ($scopeAnswer.Trim().ToUpperInvariant()) {
            "U" { $Target = "UserVSCode" }
            "C" { $Target = "Custom" }
            "P" { $Target = "UserCopilot" }
            default { $Target = "Workspace" }
        }
    }

    switch ($Target) {
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
            $SkillsPath = Join-Path $userRoot "skills"
        }
        "UserCopilot" {
            $userRoot = Get-CopilotUserRoot
            $PromptsPath = Join-Path $userRoot "prompts"
            $SkillsPath = Join-Path $userRoot "skills"
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

    Write-Info "Prompts target: $PromptsPath"
    Write-Info "Skills target:  $SkillsPath"

    if (-not $DryRun) {
        Ensure-Directory -Path $PromptsPath
        Ensure-Directory -Path $SkillsPath
    }

    $agentCandidates = @()
    $commandCandidates = @()
    $skillCandidates = @()

    foreach ($plugin in $selectedPlugins) {
        foreach ($f in $plugin.AgentFiles) {
            $stem = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
            $agentCandidates += [PSCustomObject]@{
                Plugin = $plugin.Name
                Stem   = $stem
                Path   = $f.FullName
                Label  = "$($plugin.Name)/$stem"
            }
        }
        foreach ($f in $plugin.CommandFiles) {
            $stem = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
            $commandCandidates += [PSCustomObject]@{
                Plugin = $plugin.Name
                Stem   = $stem
                Path   = $f.FullName
                Label  = "$($plugin.Name)/$stem"
            }
        }
        foreach ($d in $plugin.SkillDirs) {
            $skillCandidates += [PSCustomObject]@{
                Plugin = $plugin.Name
                Name   = $d.Name
                Path   = $d.FullName
                Label  = "$($plugin.Name)/$($d.Name)"
            }
        }
    }

    $selectedAgents = @()
    $selectedCommands = @()
    $selectedSkills = @()

    if ($IncludeAgents -and $agentCandidates.Count -gt 0) {
        $installAll = $true
        if (-not $Plugins) {
            $ans = Read-Host "Install all selected plugins' agents? [Y/n]"
            if ($ans.Trim().ToLowerInvariant() -eq "n") { $installAll = $false }
        }
        if ($installAll) {
            $selectedAgents = $agentCandidates
        }
        else {
            $labels = @($agentCandidates | ForEach-Object { $_.Label })
            $picked = Select-FromList -Items $labels -Label "Select agents to install" -AllowEmpty
            $selectedAgents = @($agentCandidates | Where-Object { $picked -contains $_.Label })
        }
    }

    if ($IncludeCommands -and $commandCandidates.Count -gt 0) {
        $installAll = $true
        if (-not $Plugins) {
            $ans = Read-Host "Install all selected plugins' commands? [Y/n]"
            if ($ans.Trim().ToLowerInvariant() -eq "n") { $installAll = $false }
        }
        if ($installAll) {
            $selectedCommands = $commandCandidates
        }
        else {
            $labels = @($commandCandidates | ForEach-Object { $_.Label })
            $picked = Select-FromList -Items $labels -Label "Select commands to install" -AllowEmpty
            $selectedCommands = @($commandCandidates | Where-Object { $picked -contains $_.Label })
        }
    }

    if ($IncludeSkills -and $skillCandidates.Count -gt 0) {
        $installAll = $true
        if (-not $Plugins) {
            $ans = Read-Host "Install all selected plugins' skills? [Y/n]"
            if ($ans.Trim().ToLowerInvariant() -eq "n") { $installAll = $false }
        }
        if ($installAll) {
            $selectedSkills = $skillCandidates
        }
        else {
            $labels = @($skillCandidates | ForEach-Object { $_.Label })
            $picked = Select-FromList -Items $labels -Label "Select skills to install" -AllowEmpty
            $selectedSkills = @($skillCandidates | Where-Object { $picked -contains $_.Label })
        }
    }

    $fileInstallCount = 0
    $skillInstallCount = 0

    foreach ($item in $selectedAgents) {
        $targetName = Resolve-ArtifactName -Plugin $item.Plugin -Stem $item.Stem -Kind "agent" -UsePrefix $PrefixWithPlugin
        $dest = Join-Path $PromptsPath $targetName
        if (Copy-FileWithLog -SourcePath $item.Path -DestinationPath $dest -Overwrite:$Force -NoWrite:$DryRun) {
            $fileInstallCount++
        }
    }

    foreach ($item in $selectedCommands) {
        $targetName = Resolve-ArtifactName -Plugin $item.Plugin -Stem $item.Stem -Kind "prompt" -UsePrefix $PrefixWithPlugin
        $dest = Join-Path $PromptsPath $targetName
        if (Copy-FileWithLog -SourcePath $item.Path -DestinationPath $dest -Overwrite:$Force -NoWrite:$DryRun) {
            $fileInstallCount++
        }
    }

    foreach ($item in $selectedSkills) {
        $dest = Join-Path $SkillsPath $item.Name
        if (Copy-DirectoryWithLog -SourcePath $item.Path -DestinationPath $dest -Overwrite:$Force -NoWrite:$DryRun) {
            $skillInstallCount++
        }
    }

    Write-Host ""
    Write-Host "Install summary" -ForegroundColor Green
    Write-Host "  Plugins selected : $($selectedPlugins.Count)"
    Write-Host "  Agents installed : $($selectedAgents.Count)"
    Write-Host "  Commands installed: $($selectedCommands.Count)"
    Write-Host "  Skills installed : $($selectedSkills.Count)"
    Write-Host "  Prompt files written: $fileInstallCount"
    Write-Host "  Skill directories written: $skillInstallCount"
    if ($DryRun) {
        Write-WarnLine "Dry run only. No files were written."
    }
}
finally {
    if ($cleanupPath -and (Test-Path -LiteralPath $cleanupPath) -and -not $KeepDownloadedSource) {
        Remove-Item -LiteralPath $cleanupPath -Recurse -Force -ErrorAction SilentlyContinue
    }
}
