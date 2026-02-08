# Handoff

## Current status

- Implemented a two-pass conversion flow:
  - suffix-oriented stripping for mapped plugins
  - residual processing for unconsumed skills/commands
- Ensured stripped artifacts are not reprocessed in the residual pass.
- Added suffix assignment heuristics for multi-mapping plugins (for example, systems language split by extension/topic signals).
- Added CLI-integrated external skill merge with gated dedup + manual-review queue.

## Key files changed

- `src/copilot_converter/suffix_stripping.py` (new)
- `src/copilot_converter/processing.py`
- `src/copilot_converter/builders.py`
- `README.md`
- `src/copilot_converter/skill_merge.py` (new)

## Verification

- `uv run ruff check src/copilot_converter`
- `uv run mypy src/copilot_converter`
- Dry run:
  - `uv run python -m copilot_converter --source /home/toor/code/agents --output /tmp/copilot-converter-test-2 --include-plugins systems-programming,python-development,jvm-languages --overwrite --decision-log /tmp/copilot-converter-test-2/decisions.json`
  - `uv run python -m copilot_converter --source /home/toor/code/agents --output /tmp/copilot-merge-cli --overwrite --merge-skills-from /home/toor/code/awesome-copilot`

## Notes

- `.github` in target repos is treated as generated output.
- For plugins with multiple mappings, only matched suffix buckets are emitted; unmatched content stays in residual handling.
