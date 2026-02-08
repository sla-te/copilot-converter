import json
import shutil
from pathlib import Path

from .constants import (
    ARGUMENTS_TOKEN,
    FRONTMATTER_DELIM,
    PROMPT_INPUT_TOKEN,
    SKILL_GLOB,
)
from .file_ops import read_text, write_text
from .frontmatter import (
    extract_intro,
    parse_simple_frontmatter,
    sanitize_description,
    split_frontmatter,
    yaml_quote,
)
from .persona import safe_preview


def build_agent_file(agent_path: Path, destination: Path) -> None:
    content = read_text(agent_path)
    split = split_frontmatter(content)
    meta = parse_simple_frontmatter(split.frontmatter)

    name = meta.get("name", agent_path.stem)
    description = meta.get("description", "Custom agent")

    frontmatter = "\n".join(
        [
            FRONTMATTER_DELIM,
            f"name: {yaml_quote(name)}",
            f"description: {yaml_quote(sanitize_description(description))}",
            FRONTMATTER_DELIM,
            "",
        ]
    )

    write_text(destination, frontmatter + split.body.lstrip())


def build_enhanced_prompt_file(
    command_path: Path,
    destination: Path,
    plugin_name: str,
    agent_persona: str | None,
    skill_links_block: str | None,
) -> None:
    content = read_text(command_path)
    intro = extract_intro(content, command_path.stem)

    prompt_name = f"{plugin_name}-{command_path.stem}"
    description = sanitize_description(intro)

    if ARGUMENTS_TOKEN in content:
        body = content.replace(ARGUMENTS_TOKEN, PROMPT_INPUT_TOKEN)
    else:
        body = content

    frontmatter_lines = [
        FRONTMATTER_DELIM,
        f"name: {yaml_quote(prompt_name)}",
        f"description: {yaml_quote(description)}",
        f"argument-hint: {yaml_quote('requirements')}",
        FRONTMATTER_DELIM,
        "",
    ]
    frontmatter = "\n".join(frontmatter_lines)

    parts = []
    if agent_persona:
        parts.append("# Expert Context")
        parts.append(f"> Acting as expert for: {plugin_name}\n")
        parts.append(agent_persona.strip())
        parts.append("\n")

    if skill_links_block:
        parts.append(skill_links_block)
        parts.append("\n")

    parts.append(body.strip())
    write_text(destination, frontmatter + "\n".join(parts))


SUPPORT_DIR_NAMES = (
    "assets",
    "references",
    "scripts",
    "examples",
    "resources",
)


def copy_support_dirs(source_skill_dir: Path, destination_dir: Path) -> None:
    for name in SUPPORT_DIR_NAMES:
        source_dir = source_skill_dir / name
        if not source_dir.exists() or not source_dir.is_dir():
            continue
        destination = destination_dir / name
        shutil.copytree(source_dir, destination, dirs_exist_ok=True)


def build_skill_file(skill_path: Path, destination: Path, plugin_name: str) -> None:
    content = read_text(skill_path)
    split = split_frontmatter(content)
    meta = parse_simple_frontmatter(split.frontmatter)

    original_name = meta.get("name", skill_path.parent.name)
    description = meta.get("description", "")

    prefixed_name = f"{plugin_name}-{original_name}"
    description = sanitize_description(description)
    if description:
        description = f"{description} (Plugin: {plugin_name})"
    else:
        description = f"Plugin: {plugin_name}"

    frontmatter = "\n".join(
        [
            FRONTMATTER_DELIM,
            f"name: {yaml_quote(prefixed_name)}",
            f"description: {yaml_quote(description)}",
            FRONTMATTER_DELIM,
            "",
        ]
    )

    write_text(destination, frontmatter + split.body.lstrip())
    copy_support_dirs(skill_path.parent, destination.parent)


def build_instruction_file(
    plugin_path: Path,
    output_dir: Path,
    output_name: str,
    apply_to: str | None,
    agent_persona: str | None,
    skill_files: list[Path] | None = None,
) -> Path | None:
    if skill_files is None:
        skills_dir = plugin_path / "skills"
        files = sorted(skills_dir.glob(SKILL_GLOB), key=lambda p: p.parent.name) if skills_dir.exists() else []
    else:
        files = sorted(skill_files, key=lambda p: p.parent.name)

    if not files and not apply_to:
        return None

    plugin_name = plugin_path.name
    content_parts = []

    if apply_to:
        content_parts.append(f"---\napplyTo: {yaml_quote(apply_to)}\n---\n")

    content_parts.append(f"# {plugin_name.replace('-', ' ').title()} Guidelines\n")

    if agent_persona:
        content_parts.append(f"\n{agent_persona.strip()}\n")

    content_parts.append(f"\nThese guidelines provide practices for {plugin_name.replace('-', ' ')}.\n")

    for skill_file in files:
        skill_content = read_text(skill_file)
        split = split_frontmatter(skill_content)
        body = split.body

        skill_name = skill_file.parent.name.replace("-", " ").title()
        content_parts.append(f"\n## {skill_name}\n")
        content_parts.append(body.strip())
        content_parts.append("\n")

    ext = ".instructions.md" if apply_to else ".md"
    output_path = output_dir / f"{output_name}{ext}"

    if len(content_parts) > 3:
        write_text(output_path, "\n".join(content_parts))
        return output_path
    return None


def create_instruction_outputs(
    plugin_path: Path,
    instructions_dir: Path,
    entries: list,
    agent_persona: str | None,
    skill_files: list[Path] | None = None,
) -> list[str]:
    outputs: list[str] = []
    for entry in entries:
        created = build_instruction_file(
            plugin_path,
            instructions_dir,
            entry.name,
            entry.apply_to,
            agent_persona,
            skill_files,
        )
        if created:
            outputs.append(str(created))
    return outputs


def create_skill_output(
    plugin_path: Path,
    skills_dir: Path,
    plugin_name: str,
    agent_persona: str | None,
    skill_files: list[Path] | None = None,
) -> list[str]:
    output_dir = skills_dir / plugin_name
    created = build_instruction_file(plugin_path, output_dir, "SKILL", None, agent_persona, skill_files)
    return [str(created)] if created else []


def build_prompts_for_plugin(
    plugin_path: Path,
    prompts_dir: Path,
    plugin_name: str,
    agent_persona: str | None,
    command_files: list[Path] | None = None,
) -> tuple[list[str], list[dict[str, str]]]:
    prompts: list[str] = []
    previews: list[dict[str, str]] = []
    files = (
        sorted(command_files, key=lambda p: p.name)
        if command_files is not None
        else sorted((plugin_path / "commands").glob("*.md"), key=lambda p: p.name)
    )
    for command_file in files:
        destination = prompts_dir / f"{plugin_name}__{command_file.stem}.prompt.md"
        build_enhanced_prompt_file(command_file, destination, plugin_name, agent_persona, None)
        prompts.append(str(destination))
        previews.append(
            {
                "name": command_file.name,
                "path": str(command_file),
                "preview": safe_preview(read_text(command_file)),
            }
        )
    return prompts, previews


def collect_command_previews(plugin_path: Path) -> list[dict[str, str]]:
    previews: list[dict[str, str]] = []
    for command_file in (plugin_path / "commands").glob("*.md"):
        previews.append(
            {
                "name": command_file.name,
                "path": str(command_file),
                "preview": safe_preview(read_text(command_file)),
            }
        )
    return previews


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


def write_copilot_instructions(output_root: Path) -> None:
    instructions_path = output_root / "copilot-instructions.md"

    block = """
## Custom Agent Library

This repository contains a library of custom agents, prompts, and skills converted from Claude plugins.

**Locations:**
- `.github/instructions/` — File-specific guidelines auto-loaded by Copilot.
- `.github/skills/` — General knowledge base and documentation (reference using @file).
- `.github/prompts/` — Reusable prompt files (run with `/` in chat).

**Guidance:**
- Context is auto-loaded for specific file types (e.g. Python).
- For general questions (Git, Architecture), reference the file in
`.github/skills/` (e.g. `@workspace #file skills/git.md`).
"""

    if not instructions_path.exists():
        content = f"# Copilot Instructions\n{block}"
        write_text(instructions_path, content)
        return

    current_content = read_text(instructions_path)
    if ".github/instructions/" in current_content:
        return

    new_content = current_content.rstrip() + "\n" + block
    write_text(instructions_path, new_content)


def write_vscode_settings(repo_root: Path) -> None:
    settings_path = repo_root / ".vscode" / "settings.json"
    settings_path.parent.mkdir(parents=True, exist_ok=True)

    settings = {}
    if settings_path.exists():
        try:
            settings = json.loads(read_text(settings_path))
        except json.JSONDecodeError:
            settings = {}

    if "chat.promptFiles" not in settings:
        settings["chat.promptFiles"] = True
        write_text(settings_path, json.dumps(settings, indent=2, sort_keys=True) + "\n")
