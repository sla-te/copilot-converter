import re

from .constants import FRONTMATTER_DELIM
from .models import FrontmatterSplit


def split_frontmatter(text: str) -> FrontmatterSplit:
    lines = text.splitlines()
    if not lines or lines[0].strip() != FRONTMATTER_DELIM:
        return FrontmatterSplit(frontmatter=None, body=text)

    end_idx = None
    for idx in range(1, len(lines)):
        if lines[idx].strip() == FRONTMATTER_DELIM:
            end_idx = idx
            break

    if end_idx is None:
        return FrontmatterSplit(frontmatter=None, body=text)

    frontmatter = "\n".join(lines[1:end_idx]).strip()
    body = "\n".join(lines[end_idx + 1 :]).lstrip()
    return FrontmatterSplit(frontmatter=frontmatter, body=body)


def parse_simple_frontmatter(frontmatter: str | None) -> dict[str, str]:
    if not frontmatter:
        return {}
    data: dict[str, str] = {}
    for line in frontmatter.splitlines():
        if not line.strip() or line.strip().startswith("#"):
            continue
        if ":" not in line:
            continue
        key, value = line.split(":", 1)
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        data[key] = value
    return data


def yaml_quote(value: str | None) -> str:
    if value is None:
        return '""'
    escaped = value.replace('"', '\\"')
    return f'"{escaped}"'


def sanitize_description(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip()


def find_header_index(lines: list[str]) -> int | None:
    for idx, line in enumerate(lines):
        if line.startswith("# "):
            return idx
    return None


def collect_intro_lines(lines: list[str], start_idx: int) -> list[str]:
    intro_lines: list[str] = []
    for line in lines[start_idx:]:
        if line.startswith("#"):
            break
        if line.strip() == "":
            if intro_lines:
                break
            continue
        intro_lines.append(line.strip())
    return intro_lines


def extract_intro(text: str, fallback_name: str) -> str:
    lines = text.splitlines()
    header_idx = find_header_index(lines)
    title = fallback_name if header_idx is None else lines[header_idx][2:].strip()

    start_idx = header_idx + 1 if header_idx is not None else 0
    intro_lines = collect_intro_lines(lines, start_idx)
    intro = " ".join(intro_lines).strip()
    return intro or title
