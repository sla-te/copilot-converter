from pathlib import Path

from .file_ops import read_text
from .frontmatter import parse_simple_frontmatter, split_frontmatter


def extract_agent_name(agent_path: Path) -> str:
    content = read_text(agent_path)
    split = split_frontmatter(content)
    meta = parse_simple_frontmatter(split.frontmatter)
    return meta.get("name", agent_path.stem)


def extract_agent_persona(plugin_path: Path, agent_hint: str | None = None) -> tuple[str | None, str | None]:
    agents_dir = plugin_path / "agents"
    if not agents_dir.exists():
        return None, None
    agent_files = list(agents_dir.glob("*.md"))
    if not agent_files:
        return None, None

    plugin_name = plugin_path.name.lower()
    parts = plugin_name.split("-")

    def get_score(path: Path) -> int:
        name = extract_agent_name(path).lower()
        score = 0
        if agent_hint and agent_hint.lower() in name:
            score += 50
        if name == plugin_name:
            score += 100
        for part in parts:
            if part in name:
                score += 10
        if "pro" in name:
            score += 5
        return score

    agent_files.sort(key=get_score, reverse=True)
    selected_agent = agent_files[0]
    content = read_text(selected_agent)
    split = split_frontmatter(content)
    return split.body, selected_agent.stem


def preview_text(text: str | None, limit: int = 400) -> str | None:
    if not text:
        return None
    cleaned = " ".join(text.split())
    if len(cleaned) <= limit:
        return cleaned
    return cleaned[: limit - 3] + "..."


def safe_preview(text: str | None, default: str = "") -> str:
    return preview_text(text) or default
