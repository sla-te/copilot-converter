#!/usr/bin/env python3
r"""Validate PowerShell script syntax for staged .ps1 files.

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

foreach ($file in $Files) {
    if (-not (Test-Path -LiteralPath $file)) {
        continue
    }

    $tokens = $null
    $errors = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile($file, [ref]$tokens, [ref]$errors)

    if ($errors -and $errors.Count -gt 0) {
        $failed = $true
        foreach ($err in $errors) {
            Write-Error (
                "{0}:{1}:{2} {3}" -f
                $file,
                $err.Extent.StartLineNumber,
                $err.Extent.StartColumnNumber,
                $err.Message
            )
        }
    }
}

if ($failed) {
    exit 1
}
"""


def resolve_pwsh() -> str | None:
    candidates: list[str] = []

    # Reference path from pre-commit issue #2645.
    if os.name == "nt":
        candidates.append(WIN_PWSH_PATH)
    else:
        candidates.append(WSL_PWSH_PATH)

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
