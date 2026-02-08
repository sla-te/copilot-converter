import json
import re
import shutil
from pathlib import Path

from .constants import ARGUMENTS_TOKEN, FRONTMATTER_DELIM, PROMPT_INPUT_TOKEN, SKILL_GLOB
from .file_ops import read_text, write_text
from .frontmatter import (
    extract_intro,
    parse_simple_frontmatter,
    sanitize_description,
    split_frontmatter,
    yaml_quote,
)
from .persona import safe_preview

SUPPORT_DIR_NAMES = (
    "assets",
    "references",
    "scripts",
    "examples",
    "resources",
)

_MARKDOWN_LINK_RE = re.compile(r"\[[^\]]+\]\(([^)]+)\)")


def _ensure_trailing_newline(content: str) -> str:
    return content if content.endswith("\n") else content + "\n"


def _replace_or_add_name(frontmatter: str, name: str) -> str:
    updated_lines: list[str] = []
    replaced = False
    for line in frontmatter.splitlines():
        if not replaced and line.strip().startswith("name:"):
            updated_lines.append(f"name: {yaml_quote(name)}")
            replaced = True
            continue
        updated_lines.append(line)
    if not replaced:
        updated_lines.insert(0, f"name: {yaml_quote(name)}")
    return "\n".join(updated_lines)


def _frontmatter_has_key(frontmatter: str, key: str) -> bool:
    needle = f"{key}:"
    for line in frontmatter.splitlines():
        if line.strip().startswith(needle):
            return True
    return False


def _append_frontmatter_key(frontmatter: str, key: str, value: str) -> str:
    lines = frontmatter.splitlines()
    lines.append(f"{key}: {yaml_quote(value)}")
    return "\n".join(lines)


def _ensure_frontmatter_name(content: str, name: str) -> str:
    split = split_frontmatter(content)
    if split.frontmatter is None:
        rendered = "\n".join(
            [
                FRONTMATTER_DELIM,
                f"name: {yaml_quote(name)}",
                FRONTMATTER_DELIM,
                "",
                split.body.strip(),
            ]
        )
        return _ensure_trailing_newline(rendered)

    updated_frontmatter = _replace_or_add_name(split.frontmatter, name)
    rendered = "\n".join(
        [
            FRONTMATTER_DELIM,
            updated_frontmatter,
            FRONTMATTER_DELIM,
            "",
            split.body.strip(),
        ]
    )
    return _ensure_trailing_newline(rendered)


def build_agent_file(agent_path: Path, destination: Path) -> None:
    """Copy plugin agent files for Copilot plugin output."""
    generated_name = destination.stem
    content = read_text(agent_path)
    write_text(destination, _ensure_frontmatter_name(content, generated_name))


def _ensure_prompt_header(command_path: Path, content: str, prompt_name: str) -> str:
    split = split_frontmatter(content)

    if split.frontmatter is not None:
        metadata = parse_simple_frontmatter(split.frontmatter)
        description = metadata.get("description") or sanitize_description(extract_intro(split.body, command_path.stem))
        updated_frontmatter = _replace_or_add_name(split.frontmatter, prompt_name)
        if not _frontmatter_has_key(updated_frontmatter, "description"):
            updated_frontmatter = _append_frontmatter_key(updated_frontmatter, "description", description)
        if ARGUMENTS_TOKEN in split.body and not _frontmatter_has_key(updated_frontmatter, "argument-hint"):
            updated_frontmatter = _append_frontmatter_key(updated_frontmatter, "argument-hint", "requirements")
        body = split.body.replace(ARGUMENTS_TOKEN, PROMPT_INPUT_TOKEN).strip()
        return _ensure_trailing_newline(
            "\n".join(
                [
                    FRONTMATTER_DELIM,
                    updated_frontmatter,
                    FRONTMATTER_DELIM,
                    "",
                    body,
                ]
            )
        )

    intro = extract_intro(content, command_path.stem)
    description = sanitize_description(intro)
    body = content.replace(ARGUMENTS_TOKEN, PROMPT_INPUT_TOKEN)

    frontmatter_lines = [
        FRONTMATTER_DELIM,
        f"name: {yaml_quote(prompt_name)}",
        f"description: {yaml_quote(description)}",
    ]
    if ARGUMENTS_TOKEN in content:
        frontmatter_lines.append(f"argument-hint: {yaml_quote('requirements')}")
    frontmatter_lines.extend([FRONTMATTER_DELIM, ""])

    rendered = "\n".join(frontmatter_lines + [body.strip()])
    return _ensure_trailing_newline(rendered)


def build_enhanced_prompt_file(command_path: Path, destination: Path) -> None:
    content = read_text(command_path)
    prompt_name = destination.stem
    rendered = _ensure_prompt_header(command_path, content, prompt_name)
    write_text(destination, rendered)


def copy_support_dirs(source_skill_dir: Path, destination_dir: Path) -> None:
    for name in SUPPORT_DIR_NAMES:
        source_dir = source_skill_dir / name
        if not source_dir.exists() or not source_dir.is_dir():
            continue
        shutil.copytree(source_dir, destination_dir / name, dirs_exist_ok=True)


def _is_relative_link_target(value: str) -> bool:
    if not value:
        return False
    if value.startswith(("#", "/", "${", "mailto:")):
        return False
    if re.match(r"^[a-zA-Z][a-zA-Z0-9+.-]*://", value):
        return False
    return True


def _extract_relative_link_targets(markdown: str) -> set[str]:
    targets: set[str] = set()
    for raw_target in _MARKDOWN_LINK_RE.findall(markdown):
        token = raw_target.strip().split()[0]
        path_token = token.split("#", 1)[0]
        if _is_relative_link_target(path_token):
            targets.add(path_token)
    return targets


def _placeholder_content(
    target: Path,
    source_skill_path: Path,
    link_target: str,
) -> str:
    note = (
        f"This file was generated automatically because `{source_skill_path}` references "
        f"`{link_target}`, but the source repository did not provide that file."
    )
    if target.name == "SKILL.md":
        folder_name = target.parent.name
        return "\n".join(
            [
                FRONTMATTER_DELIM,
                f"name: {yaml_quote(folder_name)}",
                f"description: {yaml_quote('Placeholder skill generated from missing source reference.')}",
                FRONTMATTER_DELIM,
                "",
                "# Placeholder Skill",
                "",
                note,
                "",
            ]
        )
    if target.suffix in {".md", ".markdown"}:
        return "\n".join(
            [
                "# Placeholder",
                "",
                note,
                "",
            ]
        )
    if target.suffix in {".yml", ".yaml"}:
        return f"# Placeholder generated by converter\n# {note}\n"
    if target.suffix == ".xml":
        return f"<!-- Placeholder generated by converter: {note} -->\n"
    if target.suffix == ".sh":
        return "\n".join(
            [
                "#!/usr/bin/env bash",
                "# Placeholder generated by converter.",
                f"# {note}",
                "exit 0",
                "",
            ]
        )
    return f"Placeholder generated by converter.\n{note}\n"


def _materialize_missing_local_links(
    destination: Path,
    skill_markdown: str,
    source_skill_path: Path,
) -> None:
    skill_root = destination.parent
    skills_root = skill_root.parent
    for link_target in sorted(_extract_relative_link_targets(skill_markdown)):
        resolved_target = (skill_root / link_target).resolve()
        if resolved_target.exists():
            continue
        try:
            resolved_target.relative_to(skills_root.resolve())
        except ValueError:
            continue
        placeholder = _placeholder_content(resolved_target, source_skill_path, link_target)
        write_text(resolved_target, _ensure_trailing_newline(placeholder))


def build_skill_file(skill_path: Path, destination: Path) -> None:
    """Copy plugin skill files and preserve bundled skill resources."""
    generated_name = destination.parent.name
    content = read_text(skill_path)
    rendered_skill = _ensure_frontmatter_name(content, generated_name)
    write_text(destination, rendered_skill)
    copy_support_dirs(skill_path.parent, destination.parent)
    _materialize_missing_local_links(destination, rendered_skill, skill_path)


def build_commands_for_plugin(
    plugin_path: Path,
    commands_dir: Path,
    command_files: list[Path] | None = None,
) -> tuple[list[str], list[dict[str, str]]]:
    outputs: list[str] = []
    previews: list[dict[str, str]] = []
    files = (
        sorted(command_files, key=lambda p: p.name)
        if command_files is not None
        else sorted((plugin_path / "commands").glob("*.md"), key=lambda p: p.name)
    )

    for command_file in files:
        destination = commands_dir / f"{command_file.stem}.md"
        build_enhanced_prompt_file(command_file, destination)
        outputs.append(str(destination))
        previews.append(
            {
                "name": command_file.name,
                "path": str(command_file),
                "preview": safe_preview(read_text(command_file)),
            }
        )

    return outputs, previews


def collect_skill_previews(plugin_path: Path) -> list[dict[str, str]]:
    previews: list[dict[str, str]] = []
    for skill_file in (plugin_path / "skills").glob(SKILL_GLOB):
        split = split_frontmatter(read_text(skill_file))
        previews.append(
            {
                "name": skill_file.parent.name,
                "path": str(skill_file),
                "preview": safe_preview(split.body),
            }
        )
    return previews


def read_source_plugin_metadata(plugin_path: Path) -> dict[str, object]:
    metadata_path = plugin_path / ".claude-plugin" / "plugin.json"
    if metadata_path.exists():
        try:
            return json.loads(read_text(metadata_path))
        except json.JSONDecodeError:
            return {}
    return {}


def write_plugin_manifest(plugin_path: Path, destination_plugin_dir: Path) -> dict[str, object]:
    source_metadata = read_source_plugin_metadata(plugin_path)

    manifest: dict[str, object] = {
        "name": str(source_metadata.get("name") or plugin_path.name),
        "description": str(source_metadata.get("description") or f"Converted plugin from {plugin_path.name}."),
        "version": str(source_metadata.get("version") or "1.0.0"),
        "author": source_metadata.get("author") or {"name": "copilot-converter"},
        "repository": source_metadata.get("repository") or "https://github.com/wshobson/agents",
        "license": source_metadata.get("license") or "MIT",
    }

    manifest_path = destination_plugin_dir / ".github" / "plugin" / "plugin.json"
    write_text(manifest_path, json.dumps(manifest, indent=2, sort_keys=False) + "\n")
    return manifest


def _render_markdown_table(title: str, rows: list[tuple[str, str]]) -> list[str]:
    lines: list[str] = [f"## {title}", ""]
    if not rows:
        lines.append("_None_")
        lines.append("")
        return lines

    lines.extend(["| Name | Description |", "|---|---|"])
    for name, description in rows:
        cleaned_description = description.replace("|", "\\|").strip() or "-"
        lines.append(f"| `{name}` | {cleaned_description} |")
    lines.append("")
    return lines


def write_plugin_readme(
    plugin_dir: Path,
    manifest: dict[str, object],
    command_names: list[str],
    agent_names: list[str],
    skill_names: list[str],
) -> None:
    plugin_name = str(manifest.get("name", plugin_dir.name))
    description = str(manifest.get("description", ""))

    command_rows = [(name, f"/{plugin_name}:{name} prompt") for name in command_names]
    agent_rows = [(name, "Custom Copilot agent") for name in agent_names]
    skill_rows = [(name, "Agent Skill") for name in skill_names]

    lines: list[str] = [
        f"# {plugin_name}",
        "",
        description,
        "",
        "Converted from Claude plugin source to Copilot plugin layout.",
        "",
    ]
    lines.extend(_render_markdown_table("Commands", command_rows))
    lines.extend(_render_markdown_table("Agents", agent_rows))
    lines.extend(_render_markdown_table("Skills", skill_rows))

    repository = str(manifest.get("repository", ""))
    if repository:
        lines.extend(["## Source", "", f"- `{repository}`", ""])

    write_text(plugin_dir / "README.md", "\n".join(lines))
