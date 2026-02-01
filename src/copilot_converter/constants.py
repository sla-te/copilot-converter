FRONTMATTER_DELIM = "---"
# Tokens are placeholders rather than secrets; mark to silence Bandit false positives.
ARGUMENTS_TOKEN = "$ARGUMENTS"  # nosec B105
PROMPT_INPUT_TOKEN = "${input:requirements}"  # nosec B105
SKILL_GLOB = "*/SKILL.md"
