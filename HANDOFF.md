# Handoff

## Current Status

- Conversion target is now **Copilot plugin bundles**, not flattened workspace artifacts.
- Runtime sources:
  - `wshobson/agents` for primary plugin conversion
  - `github/awesome-copilot` to inject the `meta-agentic-project-scaffold` agent
- Default output root is `./plugins`.
- For each enabled source plugin, converter emits:
  - `.github/plugin/plugin.json`
  - `README.md`
  - `agents/*.md`
  - `commands/*.md`
  - `skills/*/SKILL.md` (+ bundled support folders)
- Converter now also emits a repository-level marketplace index:
  - `.github/plugin/marketplace.json`
  - includes generated plugin list and plugin source paths under `./plugins`
- Converter injects an additional generated plugin:
  - `plugins/copilot-converter`
  - includes `agents/meta-agentic-project-scaffold.md`
- `plugin-selection.json` is synced on every run and controls plugin enable/disable.
- Plugin dependency resolution is enabled:
  - if enabled plugins reference skills in disabled plugins, provider plugins are auto-enabled
  - `plugin-selection.json` includes `auto_enabled_due_to_skill_references`
- Missing local skill references are materialized as placeholders:
  - missing `references/*`, `assets/*`, `scripts/*` links in `SKILL.md` are created in output
  - missing sibling `../<skill>/SKILL.md` targets are generated as placeholder skills
- VS Code fallback installer added for users not using Copilot plugin marketplaces:
  - `scripts/install-vscode-fallback-copilot-converter.ps1`
  - installs selected plugin `agents` and `commands` into prompt files
  - installs selected plugin `skills` directories into target skills folder
  - supports interactive selection and target scopes (`Workspace`, `UserVSCode`, `Custom`)
  - supports source modes to avoid local clone dependency:
    - `Auto` (default): local repo if present, otherwise download public GitHub ZIP
    - `Remote`: always download from `RemoteArchiveUrl`
    - `Local`: local-only source
  - interactive install supports per-plugin expansion with checkbox-based item selection

## Key Files Changed

- `src/copilot_converter/builders.py`
- `src/copilot_converter/processing.py`
- `src/copilot_converter/app.py`
- `README.md`
- `HANDOFF.md`
- `scripts/install-vscode-fallback-copilot-converter.ps1`

## Verification

- Static checks:
  - `uv run ruff check src/copilot_converter`
  - `uv run mypy src/copilot_converter`
- End-to-end generation:
  - `uv run python -m copilot_converter /home/toor/code/agents /home/toor/code/awesome-copilot --output ./plugins`
- Fallback installer:
  - not executed in this Linux CI shell because `pwsh` is not installed (`pwsh: command not found`)
  - logic documented in `README.md` and intended for PowerShell environments (Windows / pwsh)

## Notes

- Overwrite mode is forced in the CLI (`args.overwrite = True`) to keep output deterministic.
- Commands are normalized as Copilot prompt files (frontmatter ensured, `$ARGUMENTS` converted to `${input:requirements}`).
- Agent and skill names are normalized to generated file/folder names in frontmatter.
