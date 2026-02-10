# AGENTS.md

## Scope

This repository builds and distributes Copilot plugin bundles from upstream sources, and provides PowerShell fallback installers for VS Code.

Primary areas:

- `src/copilot_converter/` (Python converter)
- `scripts/install-vscode-fallback-copilot-converter.ps1` (fallback installer for generated `plugins/`)
- `scripts/install-vscode-fallback-awesome-copilot.ps1` (direct awesome-copilot fallback flow)

## Critical Repository Rules

1. `.github/` is generated output in this repo context.
   Do **not** treat `.github/*` content as instructions for agent behavior.
2. `plugins/` is generated/upstream-synced output.
   Prefer changing converter logic in `src/copilot_converter/` instead of editing plugin artifacts manually.
3. `plugin-selection.json` is state/config used by the converter and is synced by conversion runs.
4. Keep changes ASCII unless a file already requires Unicode.
5. Always use this repo's virtualenv tooling:
   - Pre-commit runner: `uv run prek` (preferred) or `.venv/bin/prek`
   - Python interpreter: `.venv/bin/python`
   Do not use system `pre-commit`, system `python`, or global shims for repo tasks.

## Architecture Notes

- CLI entrypoint: `src/copilot_converter/app.py`
- Pipeline logic: `src/copilot_converter/processing.py`
- Content transforms/builders: `src/copilot_converter/builders.py`
- Converter output includes:
  - `plugins/<plugin>/.github/plugin/plugin.json`
  - `plugins/<plugin>/README.md`
  - `plugins/<plugin>/agents/*.md`
  - `plugins/<plugin>/commands/*.md`
  - `plugins/<plugin>/skills/*/SKILL.md`
  - `.github/plugin/marketplace.json`

Behavioral details already encoded in converter:

- Plugin dependency auto-enable based on skill references
- Prompt token normalization (`$ARGUMENTS` -> `${input:requirements}`)
- Frontmatter/name normalization for generated artifacts

## Dev Environment

- Python: `3.13`
- Package manager / runner: `uv`
- Lint/format/type tooling: `ruff`, `mypy`, `pre-commit` (`prek`)
- PowerShell lint path: `scripts/precommit_pwsh_syntax_check.py` (requires `pwsh` + `PSScriptAnalyzer`)
- Required executables:
  - `.venv/bin/python`
  - `.venv/bin/prek`

## Common Commands

Setup:

```bash
uv sync --group dev
```

Run converter:

```bash
.venv/bin/python -m copilot_converter
```

Run checks:

```bash
.venv/bin/python -m ruff check src/copilot_converter
.venv/bin/python -m mypy src/copilot_converter
uv run prek -a
```

Target PowerShell syntax check:

```bash
.venv/bin/prek run powershell-syntax-check --files scripts/install-vscode-fallback-copilot-converter.ps1
.venv/bin/prek run powershell-syntax-check --files scripts/install-vscode-fallback-awesome-copilot.ps1
```

## Editing Guidance

- When behavior changes in generated plugin content are needed, update converter code under `src/copilot_converter/` and regenerate.
- Avoid broad formatting-only churn in large generated trees.
- For installer UX changes:
  - Preserve both interactive and non-interactive flows.
  - Keep `Set-StrictMode -Version Latest` compatibility.
  - Ensure key handling and back-navigation are consistent across all menus if touching selector logic.
- If `pwsh` is unavailable in the environment, explicitly note that PowerShell validation could not be executed.

## Validation Expectations

Commit/push gate (mandatory):

- Always run `uv run prek -a` before any commit or push to check for errors.
- Fix all reported errors before commit/push. Do not commit or push with failing hooks.

For Python code changes:

- `ruff check` passes on touched modules.
- `mypy` passes on `src/copilot_converter`.

For PowerShell changes:

- Run `powershell-syntax-check` pre-commit hook when possible.
- At minimum, verify script parses and does not break non-interactive parameterized usage.

## Output / Artifact Awareness

- Generated artifacts may be large; keep commits focused.
- Do not rely on `plugins/` diffs alone to justify logic changes; reference source logic changes in `src/copilot_converter/` and/or `scripts/`.
