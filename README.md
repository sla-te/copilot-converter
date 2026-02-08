# Copilot Converter

Utilities for converting Claude Code agents/plugins into GitHub Copilot (custom agents), prompts (deprecated), instructions and skills.

## Project layout

- `src/copilot_converter/` holds the converter package.
- Output is written to `<source>/.github/` by default.

## Conversion flow

1. **Suffix pass**: mapped plugins are stripped into `*.instructions.md` files keyed by `applyTo` patterns.
2. **Residual pass**: any skills/commands not consumed in the suffix pass are processed normally.
3. **No double-processing**: stripped artifacts are excluded from the residual pass.

## Optional external skill merge

You can merge additional skill repositories into the generated `.github/skills` set with gated deduplication:

```bash
uv run python -m copilot_converter \
  --source /path/to/agents \
  --output /path/to/repo/.github \
  --overwrite \
  --merge-skills-from /path/to/awesome-copilot
```

Useful flags:

- `--merge-skills-report` custom merge report path (default `<output>/skills-merge-report.json`)
- `--merge-skills-auto-dedupe-threshold` high-confidence duplicate threshold (default `0.88`)
- `--merge-skills-manual-review-threshold` ambiguous overlap threshold (default `0.55`)
- `--merge-skills-import-manual-review` import ambiguous items too (default off)

## Getting started (uv)

1. Ensure you have Python 3.13 available.
2. Install [uv](https://docs.astral.sh/uv/).
3. (Optional) Sync the dev environment if you want linting/testing tools:

   ```bash
   uv sync --group dev
   ```

4. Run the converter:

   ```bash
   uv run python -m copilot_converter --help
   ```

uv will create and manage `.venv/` and `uv.lock` automatically. Check both into version control once generated.
