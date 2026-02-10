# Copilot Converter

Convert source plugin repositories into Copilot plugin bundles, then optionally install them as VS Code fallback artifacts when marketplace installs are not available.

## Repository Structure

- `src/copilot_converter/`: converter implementation
- `plugins/`: generated plugin output (upstream-synced content)
- `scripts/install-vscode-fallback.ps1`: VS Code fallback installer
- `scripts/precommit_pwsh_syntax_check.py`: local PowerShell syntax hook helper
- `.github/plugin/marketplace.json`: generated marketplace index
- `plugin-selection.json`: plugin enable/disable state for conversion

## Converter

Input sources:

- `wshobson/agents` (default: `/home/toor/code/agents`)
- `github/awesome-copilot` (default: `/home/toor/code/awesome-copilot`)

CLI:

- Positional args: `<agents_source> <awesome_source>`
- Optional: `--output <path>`
- Optional: `--decision-log <path>`

Run with defaults:

```bash
uv run python -m copilot_converter
```

Run with explicit sources/output:

```bash
uv run python -m copilot_converter /home/toor/code/agents /home/toor/code/awesome-copilot --output ./plugins
```

Converter output:

- `plugins/<plugin>/.github/plugin/plugin.json`
- `plugins/<plugin>/README.md`
- `plugins/<plugin>/agents/*.md` (when source agents exist)
- `plugins/<plugin>/commands/*.md` (when source commands exist)
- `plugins/<plugin>/skills/*/SKILL.md` (when source skills exist)
- Skill support folders are preserved when present (`assets/`, `references/`, `scripts/`, `examples/`, `resources/`)
- `.github/plugin/marketplace.json` is regenerated at repo root
- Extra generated plugin: `plugins/copilot-converter/agents/meta-agentic-project-scaffold.md`

Plugin selection behavior:

- `plugin-selection.json` is synced on each run
- New plugins are added as enabled by default
- Existing enable/disable choices are preserved
- Skill-linked dependencies are auto-enabled

## Copilot CLI Marketplace

Register this repo as a marketplace:

```bash
copilot plugin marketplace add github/<org>/<repo>
copilot plugin marketplace browse <marketplace-name>
copilot plugin install <plugin-name>@<marketplace-name>
```

Local marketplace test:

```bash
copilot plugin marketplace add /absolute/path/to/this/repo
```

## VS Code Fallback Installer

Run:

```powershell
pwsh -File ./scripts/install-vscode-fallback.ps1
```

No-clone one-liner:

```powershell
irm https://raw.githubusercontent.com/sla-te/copilot-converter/main/scripts/install-vscode-fallback.ps1 | iex
```

What it installs:

- `plugins/<plugin>/agents/*.md` -> `<prompts>/<name>.agent.md`
- `plugins/<plugin>/commands/*.md` -> `<prompts>/<name>.prompt.md`
- `plugins/<plugin>/skills/<skill-dir>` -> `<skills>/<skill-dir>` (whole folder, including `assets/` and `references/` if present)

Target modes:

- `Workspace`: `<workspace>/.github/prompts` and `<workspace>/.github/skills`
- `UserVSCode`: VS Code user profile `prompts/` and `skills/`
- `Custom`: manually provided paths

Source modes:

- `Auto`: prefer local source, fallback to remote archive
- `Local`: require local `plugins/` under `-RepoRoot`
- `Remote`: always use archive from `-RemoteArchiveUrl`

Remote source cache:

- Default Windows cache root: `%TEMP%\copilot-converter`
- Default macOS cache root: `~/Library/Caches/copilot-converter`
- Default Linux cache root: `~/.cache/copilot-converter`
- Override with `-SourceCacheRoot`
- Cache uses per-URL foldering and metadata (`ETag`/`Last-Modified`) to avoid unnecessary downloads
- `-KeepDownloadedSource` is retained for compatibility but persistent cache is now the default behavior

Interactive selector behavior:

- Plugins are expandable inline
- Agents/commands are selectable per plugin
- Skills are auto-included for selected plugins
- Existing state is preloaded when available
- `Backspace` goes back to target selection in interactive target mode
- Interactive selection flow overwrites existing artifacts automatically

State file:

- Default path: `<prompts-parent>/copilot-converter-install-state.json`
- Override with `-StateFilePath`
- Stores selected plugins, agents, commands, and skills
- Used to preselect values and power update mode

Operation modes:

- Install/add mode: select plugins/items and install them
- Update mode: update existing installed artifacts tracked by state
- In interactive target mode, operation mode can be chosen in CLI prompt

Examples:

```powershell
pwsh -File ./scripts/install-vscode-fallback.ps1 `
  -Target Workspace `
  -WorkspaceRoot C:\src\my-repo `
  -Plugins conductor,backend-development
```

```powershell
pwsh -File ./scripts/install-vscode-fallback.ps1 `
  -SourceMode Remote `
  -Target UserVSCode `
  -UpdateExisting
```

```powershell
pwsh -File ./scripts/install-vscode-fallback.ps1 `
  -SourceMode Remote `
  -Target UserVSCode `
  -SourceCacheRoot C:\temp\copilot-cache
```

## Development Checks

Install dev dependencies:

```bash
uv sync --group dev
```

Run pre-commit hooks:

```bash
uv run prek -a
```

Targeted checks:

```bash
uv run ruff check src/copilot_converter
uv run mypy src/copilot_converter
uv run prek run powershell-syntax-check --files scripts/install-vscode-fallback.ps1
```

Note:

- Pre-commit excludes `plugins/` because that content is upstream-generated/synced.
