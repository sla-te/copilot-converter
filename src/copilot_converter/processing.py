import argparse
import json
import re
from pathlib import Path
from typing import Iterable

from .builders import (
    build_agent_file,
    build_commands_for_plugin,
    build_enhanced_prompt_file,
    build_skill_file,
    collect_skill_previews,
    write_plugin_manifest,
    write_plugin_readme,
)
from .constants import SKILL_GLOB
from .file_ops import ensure_empty_dir, load_json, read_text, write_text
from .models import DecisionRecord
from .persona import safe_preview

_SKILL_LINK_RE = re.compile(r"\.\./([a-z0-9][a-z0-9_-]*)/SKILL\.md")


def _marketplace_suggestion_command_docs() -> dict[str, dict[str, str]]:
    return {
        "suggest-copilot-converter-agents": {
            "description": (
                "Suggest relevant Copilot custom agents from this repository marketplace "
                "(translated from Claude plugins)."
            ),
            "title": "Suggest Marketplace Copilot Agents",
            "target": "`plugins/*/agents/*.md`",
            "local_target": "`.github/agents/*.agent.md`",
        },
        "suggest-copilot-converter-collections": {
            "description": (
                "Suggest relevant plugin collections from this repository marketplace "
                "(translated from Claude plugins)."
            ),
            "title": "Suggest Marketplace Plugin Collections",
            "target": "`plugins/*`",
            "local_target": "installed plugins and local workspace capabilities",
        },
        "suggest-copilot-converter-instructions": {
            "description": (
                "Suggest relevant guidance assets from this repository marketplace "
                "(skills/instructions translated from Claude plugins)."
            ),
            "title": "Suggest Marketplace Instructions",
            "target": "`plugins/*/skills/*/SKILL.md`",
            "local_target": "`.github/instructions/*.instructions.md`",
        },
        "suggest-copilot-converter-prompts": {
            "description": (
                "Suggest relevant prompt files from this repository marketplace "
                "(translated from Claude plugins)."
            ),
            "title": "Suggest Marketplace Prompts",
            "target": "`plugins/*/commands/*.md`",
            "local_target": "`.github/prompts/*.prompt.md`",
        },
    }


def _render_marketplace_suggestion_command(
    *,
    name: str,
    description: str,
    title: str,
    target: str,
    local_target: str,
) -> str:
    return "\n".join(
        [
            "---",
            f'name: "{name}"',
            'agent: "agent"',
            f'description: "{description}"',
            "---",
            "",
            f"# {title}",
            "",
            "Analyze current repository context and suggest relevant assets from this repository marketplace.",
            "",
            "Do not suggest from upstream `github/awesome-copilot` directly for this command.",
            "",
            "## Source of Truth",
            "",
            "- `.github/plugin/marketplace.json`",
            f"- {target}",
            "",
            "## Process",
            "",
            "1. Read `.github/plugin/marketplace.json` and enumerate available plugins.",
            f"2. Scan {target} and extract names and descriptions.",
            "3. Analyze current repository context and recent chat goals.",
            f"4. Compare against existing local assets in {local_target} to avoid duplicates.",
            "5. Rank the best fits and explain why each is relevant now.",
            "6. Wait for explicit user confirmation before performing any install/update action.",
            "",
            "## Output Format",
            "",
            "| Marketplace Plugin | Asset | Description | Why relevant | Install command |",
            "|---|---|---|---|---|",
            (
                "| `plugin-name` | `asset-name` | Short summary | "
                "Specific reason tied to current task | "
                "`copilot plugin install <plugin-name>@<marketplace-name>` |"
            ),
            "",
            "If no strong matches exist, explicitly say so and explain the gap.",
            "",
        ]
    )


def iter_plugin_dirs(source: Path, plugin_filter: set[str] | None) -> Iterable[Path]:
    plugins_dir = source / "plugins"
    if not plugins_dir.exists():
        return []

    plugin_dirs = [p for p in plugins_dir.iterdir() if p.is_dir()]
    if plugin_filter:
        return [p for p in plugin_dirs if p.name in plugin_filter]
    return plugin_dirs


def resolve_source(source_arg: str) -> Path:
    source = Path(source_arg).expanduser().resolve()
    if not source.exists():
        raise SystemExit(f"Source path not found: {source}")
    return source


def resolve_output_root(output_arg: str | None) -> Path:
    output_root = Path(output_arg).expanduser().resolve() if output_arg else Path.cwd() / "plugins"
    output_root.mkdir(parents=True, exist_ok=True)
    return output_root


def _plugin_names(source: Path) -> list[str]:
    plugins_dir = source / "plugins"
    if not plugins_dir.exists():
        return []
    return sorted(item.name for item in plugins_dir.iterdir() if item.is_dir())


def _collect_plugin_skill_index(source: Path) -> tuple[dict[str, list[Path]], dict[str, set[str]]]:
    plugins_dir = source / "plugins"
    skill_paths_by_plugin: dict[str, list[Path]] = {}
    skill_names_by_plugin: dict[str, set[str]] = {}
    if not plugins_dir.exists():
        return skill_paths_by_plugin, skill_names_by_plugin

    for plugin_dir in sorted((p for p in plugins_dir.iterdir() if p.is_dir()), key=lambda p: p.name):
        skill_paths = sorted((plugin_dir / "skills").glob(SKILL_GLOB), key=lambda p: p.parent.name)
        skill_paths_by_plugin[plugin_dir.name] = skill_paths
        skill_names_by_plugin[plugin_dir.name] = {path.parent.name for path in skill_paths}

    return skill_paths_by_plugin, skill_names_by_plugin


def _extract_skill_refs(content: str) -> list[tuple[str | None, str]]:
    refs: list[tuple[str | None, str]] = []
    for token in _SKILL_LINK_RE.findall(content):
        if "__" in token:
            plugin_name, skill_name = token.split("__", 1)
            refs.append((plugin_name, skill_name))
        else:
            refs.append((None, token))
    return refs


def _resolve_plugin_dependencies(source: Path, enabled_plugins: set[str]) -> tuple[set[str], set[str]]:
    skill_paths_by_plugin, skill_names_by_plugin = _collect_plugin_skill_index(source)
    skill_to_plugins: dict[str, set[str]] = {}
    for plugin_name, skill_names in skill_names_by_plugin.items():
        for skill_name in skill_names:
            skill_to_plugins.setdefault(skill_name, set()).add(plugin_name)

    dependencies: dict[str, set[str]] = {plugin: set() for plugin in skill_paths_by_plugin}
    for plugin_name, skill_paths in skill_paths_by_plugin.items():
        own_skills = skill_names_by_plugin.get(plugin_name, set())
        for skill_path in skill_paths:
            for explicit_plugin, skill_name in _extract_skill_refs(read_text(skill_path)):
                if explicit_plugin:
                    provider_skills = skill_names_by_plugin.get(explicit_plugin, set())
                    if skill_name in provider_skills and explicit_plugin != plugin_name:
                        dependencies[plugin_name].add(explicit_plugin)
                    continue
                if skill_name in own_skills:
                    continue
                for provider_plugin in skill_to_plugins.get(skill_name, set()):
                    if provider_plugin != plugin_name:
                        dependencies[plugin_name].add(provider_plugin)

    resolved_enabled = set(enabled_plugins)
    stack = list(enabled_plugins)
    while stack:
        plugin_name = stack.pop()
        for provider_plugin in dependencies.get(plugin_name, set()):
            if provider_plugin not in resolved_enabled:
                resolved_enabled.add(provider_plugin)
                stack.append(provider_plugin)

    auto_enabled = resolved_enabled - enabled_plugins
    return resolved_enabled, auto_enabled


def sync_plugin_selection(source: Path, config_path: Path) -> set[str]:
    plugin_names = _plugin_names(source)
    existing = load_json(config_path) if config_path.exists() else {}
    existing_plugins = existing.get("plugins", {})

    normalized_plugins: dict[str, bool] = {}
    for name in plugin_names:
        raw_value = existing_plugins.get(name, True) if isinstance(existing_plugins, dict) else True
        normalized_plugins[name] = raw_value if isinstance(raw_value, bool) else True

    initially_enabled = {name for name, enabled in normalized_plugins.items() if enabled}
    resolved_enabled, auto_enabled = _resolve_plugin_dependencies(source, initially_enabled)
    for name in plugin_names:
        normalized_plugins[name] = name in resolved_enabled

    payload = {
        "source": str(source),
        "plugins": normalized_plugins,
        "auto_enabled_due_to_skill_references": sorted(auto_enabled),
    }
    write_text(config_path, json.dumps(payload, indent=2, sort_keys=True) + "\n")
    return resolved_enabled


def write_decision_log(path: Path, decisions: list[DecisionRecord]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    serializable: list[dict[str, object]] = []
    for d in decisions:
        serializable.append(
            {
                "plugin": d.plugin,
                "classification": d.classification,
                "mapping_entries": [],
                "outputs": d.outputs,
                "prompts": d.prompts,
                "agents": d.agents,
                "commands": d.commands,
                "skills": d.skills,
                "plugin_path": d.plugin_path,
                "selected_agent": d.selected_agent,
                "agent_persona_preview": d.agent_persona_preview,
                "command_previews": d.command_previews,
                "skill_previews": d.skill_previews,
                "notes": d.notes,
                "reasons": d.reasons,
                "command_neighbors": [],
            }
        )
    path.write_text(json.dumps(serializable, indent=2, sort_keys=True), encoding="utf-8")


def _process_plugin_agents(plugin_path: Path, agents_dir: Path) -> tuple[list[str], list[str]]:
    produced_paths: list[str] = []
    agent_names: list[str] = []
    for agent_file in sorted((plugin_path / "agents").glob("*.md"), key=lambda p: p.name):
        destination = agents_dir / agent_file.name
        build_agent_file(agent_file, destination)
        produced_paths.append(str(destination))
        agent_names.append(agent_file.stem)
    return produced_paths, agent_names


def _process_plugin_skills(plugin_path: Path, skills_dir: Path) -> tuple[list[str], list[str]]:
    produced_paths: list[str] = []
    skill_names: list[str] = []
    for skill_file in sorted((plugin_path / "skills").glob(SKILL_GLOB), key=lambda p: p.parent.name):
        skill_name = skill_file.parent.name
        skill_output_dir = skills_dir / skill_name
        destination = skill_output_dir / "SKILL.md"
        build_skill_file(skill_file, destination)
        produced_paths.append(str(destination))
        skill_names.append(skill_name)
    return produced_paths, skill_names


def process_plugins(plugin_dirs: Iterable[Path], output_root: Path, args: argparse.Namespace) -> list[DecisionRecord]:
    ensure_empty_dir(output_root, args.overwrite)

    decisions: list[DecisionRecord] = []
    for plugin_path in sorted(plugin_dirs, key=lambda p: p.name):
        plugin_name = plugin_path.name
        plugin_output_dir = output_root / plugin_name

        agents_dir = plugin_output_dir / "agents"
        commands_dir = plugin_output_dir / "commands"
        skills_dir = plugin_output_dir / "skills"
        for directory in (agents_dir, commands_dir, skills_dir):
            directory.mkdir(parents=True, exist_ok=True)

        manifest = write_plugin_manifest(plugin_path, plugin_output_dir)

        agent_outputs, agent_names = _process_plugin_agents(plugin_path, agents_dir)
        skill_outputs, skill_names = _process_plugin_skills(plugin_path, skills_dir)

        command_files = sorted((plugin_path / "commands").glob("*.md"), key=lambda p: p.name)
        prompt_outputs, command_previews = build_commands_for_plugin(
            plugin_path=plugin_path,
            commands_dir=commands_dir,
            command_files=command_files,
        )
        command_names = [item.stem for item in command_files]

        write_plugin_readme(
            plugin_dir=plugin_output_dir,
            manifest=manifest,
            command_names=command_names,
            agent_names=agent_names,
            skill_names=skill_names,
        )

        outputs = [
            str(plugin_output_dir / ".github" / "plugin" / "plugin.json"),
            str(plugin_output_dir / "README.md"),
            *agent_outputs,
            *skill_outputs,
            *prompt_outputs,
        ]

        decisions.append(
            DecisionRecord(
                plugin=plugin_name,
                classification="copilot-plugin",
                mapping_entries=[],
                outputs=outputs,
                prompts=prompt_outputs,
                agents=agent_names,
                commands=command_names,
                skills=skill_names,
                plugin_path=str(plugin_path),
                selected_agent=None,
                agent_persona_preview=None,
                command_previews=command_previews,
                skill_previews=collect_skill_previews(plugin_path),
                notes=None,
                reasons=[
                    "claude_plugin_to_copilot_plugin",
                    "agents_to_agents_directory",
                    "commands_to_commands_directory",
                    "skills_to_skills_directory",
                    "emit_plugin_manifest",
                ],
                command_neighbors=[],
            )
        )

    return decisions


def process_awesome_meta_agent(awesome_source: Path, output_root: Path) -> DecisionRecord | None:
    source_plugin_name = "awesome-copilot"
    plugin_name = "copilot-converter"
    agent_source = awesome_source / "agents" / "meta-agentic-project-scaffold.agent.md"
    if not agent_source.exists():
        return None

    plugin_output_dir = output_root / plugin_name
    agents_dir = plugin_output_dir / "agents"
    commands_dir = plugin_output_dir / "commands"
    skills_dir = plugin_output_dir / "skills"
    for directory in (agents_dir, commands_dir, skills_dir):
        directory.mkdir(parents=True, exist_ok=True)

    source_manifest_path = awesome_source / "plugins" / source_plugin_name / ".github" / "plugin" / "plugin.json"
    source_manifest = load_json(source_manifest_path) if source_manifest_path.exists() else {}
    manifest: dict[str, object] = {
        "name": plugin_name,
        "description": str(
            source_manifest.get("description")
            or "Meta prompts that help discover and scaffold Copilot workflows from awesome-copilot."
        ),
        "version": str(source_manifest.get("version") or "1.0.0"),
        "author": source_manifest.get("author") or {"name": "Awesome Copilot Community"},
        "repository": source_manifest.get("repository") or "https://github.com/github/awesome-copilot",
        "license": source_manifest.get("license") or "MIT",
    }
    write_text(
        plugin_output_dir / ".github" / "plugin" / "plugin.json",
        json.dumps(manifest, indent=2, sort_keys=False) + "\n",
    )

    agent_destination = agents_dir / "meta-agentic-project-scaffold.md"
    build_agent_file(agent_source, agent_destination)

    prompt_outputs: list[str] = []
    command_names: list[str] = []
    for command_name, command_doc in _marketplace_suggestion_command_docs().items():
        rendered = _render_marketplace_suggestion_command(
            name=command_name,
            description=command_doc["description"],
            title=command_doc["title"],
            target=command_doc["target"],
            local_target=command_doc["local_target"],
        )
        prompt_destination = commands_dir / f"{command_name}.md"
        write_text(prompt_destination, rendered)
        prompt_outputs.append(str(prompt_destination))
        command_names.append(command_name)

    # Keep create-readme available as a direct convenience prompt.
    create_readme_source = awesome_source / "prompts" / "create-readme.prompt.md"
    if create_readme_source.exists() and "create-readme" not in command_names:
        prompt_destination = commands_dir / "create-readme.md"
        build_enhanced_prompt_file(create_readme_source, prompt_destination)
        prompt_outputs.append(str(prompt_destination))
        command_names.append("create-readme")

    write_plugin_readme(
        plugin_dir=plugin_output_dir,
        manifest=manifest,
        command_names=command_names,
        agent_names=["meta-agentic-project-scaffold"],
        skill_names=[],
    )

    outputs = [
        str(plugin_output_dir / ".github" / "plugin" / "plugin.json"),
        str(plugin_output_dir / "README.md"),
        str(agent_destination),
        *prompt_outputs,
    ]

    return DecisionRecord(
        plugin=plugin_name,
        classification="copilot-plugin",
        mapping_entries=[],
        outputs=outputs,
        prompts=prompt_outputs,
        agents=["meta-agentic-project-scaffold"],
        commands=command_names,
        skills=[],
        plugin_path=str(agent_source),
        selected_agent="meta-agentic-project-scaffold",
        agent_persona_preview=safe_preview(read_text(agent_source)),
        command_previews=[],
        skill_previews=[],
        notes="Injected from github/awesome-copilot.",
        reasons=[
            "inject_copilot_converter_meta_plugin",
            "add_meta_agentic_project_scaffold_to_marketplace",
        ],
        command_neighbors=[],
    )


def _slugify_marketplace_name(name: str) -> str:
    slug = re.sub(r"[^a-z0-9-]+", "-", name.lower()).strip("-")
    return slug or "local-marketplace"


def _marketplace_path(target: Path, workspace_root: Path) -> str:
    target_resolved = target.resolve()
    workspace_resolved = workspace_root.resolve()
    try:
        relative = target_resolved.relative_to(workspace_resolved)
        return f"./{relative.as_posix()}"
    except ValueError:
        return str(target_resolved)


def write_marketplace_manifest(workspace_root: Path, output_root: Path) -> Path:
    plugin_entries: list[dict[str, str]] = []
    for plugin_dir in sorted((p for p in output_root.iterdir() if p.is_dir()), key=lambda p: p.name):
        plugin_manifest_path = plugin_dir / ".github" / "plugin" / "plugin.json"
        if not plugin_manifest_path.exists():
            continue
        plugin_manifest = load_json(plugin_manifest_path)
        plugin_entries.append(
            {
                "name": str(plugin_manifest.get("name") or plugin_dir.name),
                "source": _marketplace_path(plugin_dir, workspace_root),
                "description": str(plugin_manifest.get("description") or f"Plugin {plugin_dir.name}"),
                "version": str(plugin_manifest.get("version") or "1.0.0"),
            }
        )

    marketplace = {
        "name": _slugify_marketplace_name(workspace_root.name),
        "metadata": {
            "description": "Generated Copilot plugin marketplace from wshobson/agents via copilot-converter.",
            "version": "1.0.0",
            "pluginRoot": _marketplace_path(output_root, workspace_root),
        },
        "owner": {
            "name": "copilot-converter",
            "email": "noreply@copilot-converter.local",
        },
        "plugins": plugin_entries,
    }

    destination = workspace_root / ".github" / "plugin" / "marketplace.json"
    write_text(destination, json.dumps(marketplace, indent=2, sort_keys=False) + "\n")
    return destination
