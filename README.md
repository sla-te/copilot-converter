# Copilot Converter

Convert plugin sources into installable Copilot plugin bundles.

## Source

The converter consumes two source repositories:

- `wshobson/agents` (default: `/home/toor/code/agents`) as the primary plugin source
- `github/awesome-copilot` (default: `/home/toor/code/awesome-copilot`) for the `meta-agentic-project-scaffold` agent

CLI positional arguments:

- `<agents_source> <awesome_source>`

## Output Contract

Generated output root defaults to `./plugins`.

For each source plugin at `plugins/<plugin_name>/`, the converter emits:

- `plugins/<plugin_name>/.github/plugin/plugin.json`
- `plugins/<plugin_name>/README.md`
- `plugins/<plugin_name>/agents/*.md`
- `plugins/<plugin_name>/commands/*.md`
- `plugins/<plugin_name>/skills/*/SKILL.md`

Additionally, the converter writes a marketplace index at:

- `.github/plugin/marketplace.json`

This lets you register the current repository as a Copilot CLI marketplace.

The generated market also includes a `copilot-converter` plugin containing:

- `agents/meta-agentic-project-scaffold.md`

Skill support folders are preserved when present:

- `assets/`
- `references/`
- `scripts/`
- `examples/`
- `resources/`

If a generated `SKILL.md` references missing local relative files, placeholder files are created so links resolve.

## Plugin Selection

On every run, the app syncs `plugin-selection.json` in the workspace root.

- Newly discovered plugins are added with `true`
- Existing `true`/`false` toggles are preserved
- Plugins referenced by enabled plugins' `SKILL.md` dependency links are auto-enabled
- `auto_enabled_due_to_skill_references` records auto-enabled plugins

## Usage

Run with default sources and default output (`./plugins`):

```bash
uv run python -m copilot_converter
```

Run with explicit sources:

```bash
uv run python -m copilot_converter /home/toor/code/agents /home/toor/code/awesome-copilot
```

Run with explicit output:

```bash
uv run python -m copilot_converter /home/toor/code/agents /home/toor/code/awesome-copilot --output /path/to/plugins
```

Optional flags:

- `--decision-log <path>` writes JSON conversion metadata

## Marketplace Usage

After generation and pushing this repository to GitHub:

```bash
copilot plugin marketplace add github/<org>/<repo>
copilot plugin marketplace browse <marketplace-name>
copilot plugin install <plugin-name>@<marketplace-name>
```

For local testing without pushing:

```bash
copilot plugin marketplace add /absolute/path/to/this/repo
```

## Validation

```bash
uv sync --group dev
uv run ruff check src/copilot_converter
uv run mypy src/copilot_converter
uv run python -m copilot_converter /home/toor/code/agents /home/toor/code/awesome-copilot --output ./plugins
```
