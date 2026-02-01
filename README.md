# Copilot Converter

Utilities for converting Claude Code agents/plugins into GitHub Copilot custom agents, prompts, and skills.

## Project layout

- `scripts/` holds the converter logic (`copilot_agents_converter.py`).
- `.github/` contains Copilot instructions, prompts, and skills.

## Getting started (uv)

1. Ensure you have Python 3.12 available (see `.python-version`).
2. Install [uv](https://docs.astral.sh/uv/).
3. (Optional) Sync the dev environment if you want linting/testing tools:

   ```bash
   uv sync --group dev
   ```

4. Run the converter:

   ```bash
   uv run scripts/copilot_agents_converter.py --help
   ```

uv will create and manage `.venv/` and `uv.lock` automatically. Check both into version control once generated.
