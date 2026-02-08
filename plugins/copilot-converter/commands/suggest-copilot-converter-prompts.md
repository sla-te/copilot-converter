---
name: "suggest-copilot-converter-prompts"
agent: "agent"
description: "Suggest relevant prompt files from this repository marketplace (translated from Claude plugins)."
---

# Suggest Marketplace Prompts

Analyze current repository context and suggest relevant assets from this repository marketplace.

Do not suggest from upstream `github/awesome-copilot` directly for this command.

## Source of Truth

- `.github/plugin/marketplace.json`
- `plugins/*/commands/*.md`

## Process

1. Read `.github/plugin/marketplace.json` and enumerate available plugins.
2. Scan `plugins/*/commands/*.md` and extract names and descriptions.
3. Analyze current repository context and recent chat goals.
4. Compare against existing local assets in `.github/prompts/*.prompt.md` to avoid duplicates.
5. Rank the best fits and explain why each is relevant now.
6. Wait for explicit user confirmation before performing any install/update action.

## Output Format

| Marketplace Plugin | Asset | Description | Why relevant | Install command |
|---|---|---|---|---|
| `plugin-name` | `asset-name` | Short summary | Specific reason tied to current task | `copilot plugin install <plugin-name>@<marketplace-name>` |

If no strong matches exist, explicitly say so and explain the gap.
