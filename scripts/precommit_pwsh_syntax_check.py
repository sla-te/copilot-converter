r"""Validate and format staged PowerShell scripts.

Uses PSScriptAnalyzer (Invoke-ScriptAnalyzer) for full diagnostics.
Uses PSScriptAnalyzer Invoke-Formatter to auto-format files before analysis.
Uses the Windows PowerShell 7 path from pre-commit issue #2645 as primary
reference path:
  C:\\Program Files\\PowerShell\\7\\pwsh.exe
"""

from __future__ import annotations

import os
import shutil
import subprocess  # nosec B404
import sys
import tempfile
from pathlib import Path

WIN_PWSH_PATH = r"C:\Program Files\PowerShell\7\pwsh.exe"
WSL_PWSH_PATH = "/mnt/c/Program Files/PowerShell/7/pwsh.exe"

PS_SYNTAX_SCRIPT = r"""
param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Files)

$ErrorActionPreference = 'Stop'
$failed = $false

if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
    Write-Error "PSScriptAnalyzer module is required. Install with: Install-Module PSScriptAnalyzer -Scope CurrentUser"
    exit 1
}

$module = Get-Module -ListAvailable -Name PSScriptAnalyzer | Sort-Object Version -Descending | Select-Object -First 1
$minVersion = [version]'1.18.0'
if ($module.Version -lt $minVersion) {
    Write-Error (
        "PSScriptAnalyzer version {0} is too old. Version {1} or newer is required." -f
        $module.Version,
        $minVersion
    )
    exit 1
}

Import-Module PSScriptAnalyzer -RequiredVersion $module.Version -ErrorAction Stop

foreach ($file in $Files) {
    if (-not (Test-Path -LiteralPath $file)) {
        continue
    }

    # Format file first and force re-stage when formatting changed content.
    $originalContent = Get-Content -LiteralPath $file -Raw
    $formattedContent = Invoke-Formatter -ScriptDefinition $originalContent
    if (($null -ne $formattedContent) -and ($formattedContent -ne $originalContent)) {
        $resolvedFilePath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($file)
        [System.IO.File]::WriteAllText(
            $resolvedFilePath,
            $formattedContent,
            [System.Text.UTF8Encoding]::new($false)
        )
        $failed = $true
        [Console]::Error.WriteLine((
            "{0}:0:0 [Info/Invoke-Formatter] File was formatted. Re-stage this file and re-run commit." -f
            $file
        ))
    }

    # Enforce hard failures only (syntax/analysis errors). Warnings are informational.
    $diagnostics = @(Invoke-ScriptAnalyzer -Path $file -Severity @("Error", "ParseError"))
    if ($diagnostics.Count -gt 0) {
        $failed = $true
        foreach ($diag in $diagnostics) {
            [Console]::Error.WriteLine((
                "{0}:{1}:{2} [{3}/{4}] {5}" -f
                $file,
                $diag.Line,
                $diag.Column,
                $diag.Severity,
                $diag.RuleName,
                $diag.Message
            ))
        }
    }
}

if ($failed) {
    exit 1
}
"""


def resolve_pwsh() -> str | None:
    candidates: list[str] = []

    # Explicit override for custom environments.
    env_pwsh = os.environ.get("PWSH_PATH")
    if env_pwsh:
        candidates.append(env_pwsh)

    # Reference paths from pre-commit issue #2645.
    # Keep WSL path first, then native Windows path.
    candidates.extend([WSL_PWSH_PATH, WIN_PWSH_PATH])

    which_pwsh = shutil.which("pwsh")
    if which_pwsh:
        candidates.append(which_pwsh)

    for candidate in candidates:
        if Path(candidate).is_file():
            return candidate

    return None


def main() -> int:
    files = [f for f in sys.argv[1:] if f.lower().endswith(".ps1")]
    if not files:
        return 0

    pwsh = resolve_pwsh()
    if not pwsh:
        sys.stderr.write(f"PowerShell executable not found. Expected path: '{WIN_PWSH_PATH}' (or '{WSL_PWSH_PATH}').\n")
        return 1

    temp_script_path = None
    try:
        with tempfile.NamedTemporaryFile("w", suffix=".ps1", delete=False, encoding="utf-8") as handle:
            handle.write(PS_SYNTAX_SCRIPT)
            temp_script_path = handle.name

        cmd = [
            pwsh,
            "-NoLogo",
            "-NoProfile",
            "-NonInteractive",
            "-ExecutionPolicy",
            "Bypass",
            "-File",
            temp_script_path,
            *files,
        ]

        result = subprocess.run(cmd, check=False)  # nosec B603
        return result.returncode
    finally:
        if temp_script_path and Path(temp_script_path).exists():
            Path(temp_script_path).unlink(missing_ok=True)


if __name__ == "__main__":
    raise SystemExit(main())
