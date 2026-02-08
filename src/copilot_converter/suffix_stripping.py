import re
from dataclasses import dataclass
from pathlib import Path

from .builders import build_instruction_file, build_prompts_for_plugin
from .file_ops import read_text
from .frontmatter import parse_simple_frontmatter, split_frontmatter
from .models import MappingEntry

_TOKEN_BOUNDARY = re.compile(r"[^a-z0-9]+")
_APPLY_TO_GROUP_EXT = re.compile(r"\.\{([^}]+)\}")
_APPLY_TO_SINGLE_EXT = re.compile(r"\*\.([a-zA-Z0-9_+-]+)")

_GENERIC_TOKENS = {
    "automation",
    "cloud",
    "code",
    "contribution",
    "database",
    "design",
    "development",
    "infrastructure",
    "kubernetes",
    "languages",
    "operations",
    "programming",
    "scripting",
    "shell",
    "systems",
}


@dataclass(frozen=True)
class SuffixStripResult:
    outputs: list[str]
    prompts: list[str]
    command_previews: list[dict[str, str]]
    consumed_skill_files: set[Path]
    consumed_command_files: set[Path]
    reasons: list[str]


def _tokenize(text: str) -> list[str]:
    return [token for token in _TOKEN_BOUNDARY.split(text.lower()) if token]


def _contains_token(text: str, token: str) -> bool:
    if not token:
        return False
    return re.search(rf"(?<![a-z0-9]){re.escape(token)}(?![a-z0-9])", text) is not None


def _extract_apply_to_extensions(apply_to: str) -> set[str]:
    found: set[str] = set()
    for group in _APPLY_TO_GROUP_EXT.findall(apply_to):
        for item in group.split(","):
            ext = item.strip().lower().lstrip(".")
            if ext:
                found.add(ext)
    for ext in _APPLY_TO_SINGLE_EXT.findall(apply_to):
        cleaned = ext.strip().lower().lstrip(".")
        if cleaned:
            found.add(cleaned)
    return found


def _entry_keyword_tokens(plugin_name: str, entry: MappingEntry) -> set[str]:
    prefix = f"{plugin_name}-"
    suffix = entry.name[len(prefix) :] if entry.name.startswith(prefix) else entry.name

    tokens = set(_tokenize(suffix))
    if entry.agent_hint:
        tokens.update(_tokenize(entry.agent_hint))
    tokens.update(_extract_apply_to_extensions(entry.apply_to))

    return {token for token in tokens if len(token) > 1 and token not in _GENERIC_TOKENS}


def _build_signal_text(path: Path) -> str:
    try:
        raw = read_text(path)
    except FileNotFoundError:
        return " ".join(part.lower() for part in path.parts)

    split = split_frontmatter(raw)
    meta = parse_simple_frontmatter(split.frontmatter)
    meta_text = " ".join(
        [
            str(meta.get("name", "")),
            str(meta.get("description", "")),
        ]
    )
    body_excerpt = split.body[:2000]
    path_text = " ".join(part.lower() for part in path.parts)
    return f"{path_text}\n{meta_text.lower()}\n{body_excerpt.lower()}"


def _score_entry(signal_text: str, tokens: set[str], extensions: set[str]) -> int:
    score = 0
    for token in tokens:
        if _contains_token(signal_text, token):
            score += 3
        elif token in signal_text:
            score += 1

    for ext in extensions:
        if re.search(rf"\.{re.escape(ext)}(?![a-z0-9])", signal_text):
            score += 4
        elif _contains_token(signal_text, ext):
            score += 2

    return score


def _assign_files_to_entries(
    files: list[Path], plugin_name: str, entries: list[MappingEntry]
) -> tuple[dict[str, list[Path]], set[Path]]:
    assignments: dict[str, list[Path]] = {entry.name: [] for entry in entries}
    consumed: set[Path] = set()
    if not files or not entries:
        return assignments, consumed

    if len(entries) == 1:
        only_entry = entries[0]
        assignments[only_entry.name] = sorted(files, key=lambda p: p.name)
        return assignments, set(files)

    entry_tokens: dict[str, set[str]] = {}
    entry_exts: dict[str, set[str]] = {}
    for entry in entries:
        exts = _extract_apply_to_extensions(entry.apply_to)
        entry_exts[entry.name] = exts
        entry_tokens[entry.name] = _entry_keyword_tokens(plugin_name, entry)

    for file_path in sorted(files, key=lambda p: p.name):
        signal_text = _build_signal_text(file_path)
        best_entry: MappingEntry | None = None
        best_score = 0
        for entry in entries:
            score = _score_entry(signal_text, entry_tokens[entry.name], entry_exts[entry.name])
            if score > best_score:
                best_score = score
                best_entry = entry

        if best_entry and best_score > 0:
            assignments[best_entry.name].append(file_path)
            consumed.add(file_path)

    return assignments, consumed


def strip_suffix_scoped_artifacts(
    plugin_path: Path,
    instructions_dir: Path,
    prompts_dir: Path,
    mapping_entries: list[MappingEntry],
    skill_files: list[Path],
    command_files: list[Path],
) -> SuffixStripResult:
    ordered_entries = sorted(mapping_entries, key=lambda entry: entry.name)
    if not ordered_entries:
        return SuffixStripResult([], [], [], set(), set(), [])

    plugin_name = plugin_path.name
    reasons = ["explicit_mapping"]

    skill_assignments, consumed_skill_files = _assign_files_to_entries(skill_files, plugin_name, ordered_entries)
    command_assignments, consumed_command_files = _assign_files_to_entries(command_files, plugin_name, ordered_entries)

    outputs: list[str] = []
    for entry in ordered_entries:
        assigned_skills = skill_assignments[entry.name]
        has_commands = bool(command_assignments[entry.name])
        emit_entry = bool(assigned_skills or has_commands or len(ordered_entries) == 1)
        if not emit_entry:
            continue
        created = build_instruction_file(
            plugin_path=plugin_path,
            output_dir=instructions_dir,
            output_name=entry.name,
            apply_to=entry.apply_to,
            agent_persona=None,
            skill_files=assigned_skills,
        )
        if created:
            outputs.append(str(created))
    if outputs:
        reasons.append("suffix_instructions_generated")

    consumed_command_list = sorted(consumed_command_files, key=lambda path: path.name)
    if consumed_command_list:
        prompts, command_previews = build_prompts_for_plugin(
            plugin_path=plugin_path,
            prompts_dir=prompts_dir,
            plugin_name=plugin_name,
            agent_persona=None,
            command_files=consumed_command_list,
        )
    else:
        prompts, command_previews = [], []

    if prompts:
        reasons.append("suffix_commands_prompts_generated")
    if consumed_skill_files:
        reasons.append("suffix_skills_stripped")
    if consumed_command_files:
        reasons.append("suffix_commands_stripped")

    return SuffixStripResult(
        outputs=outputs,
        prompts=prompts,
        command_previews=command_previews,
        consumed_skill_files=consumed_skill_files,
        consumed_command_files=consumed_command_files,
        reasons=reasons,
    )
