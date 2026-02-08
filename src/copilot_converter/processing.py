import argparse
import json
from pathlib import Path
from typing import Iterable

from .builders import (
    build_prompts_for_plugin,
    collect_skill_previews,
    create_skill_output,
    write_copilot_instructions,
    write_vscode_settings,
)
from .clustering import (
    build_cluster_prompts,
    build_command_docs,
    build_command_neighbors,
    cluster_commands,
    compute_tfidf_vectors,
    write_cluster_report,
)
from .constants import SKILL_GLOB
from .file_ops import ensure_empty_dir, read_text
from .mappings import get_mapping_entries
from .models import DecisionRecord
from .persona import extract_agent_persona, preview_text
from .suffix_stripping import strip_suffix_scoped_artifacts


def load_marketplace_plugins(source: Path) -> set[str]:
    marketplace = source / ".claude-plugin" / "marketplace.json"
    if not marketplace.exists():
        return set()
    try:
        data = json.loads(read_text(marketplace))
    except json.JSONDecodeError:
        return set()
    plugins = {item.get("name") for item in data.get("plugins", []) if item.get("name")}
    return {p for p in plugins if isinstance(p, str)}


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


def resolve_output_root(source: Path, output_arg: str | None) -> Path:
    output_root = Path(output_arg).expanduser().resolve() if output_arg else source / ".github"
    output_root.mkdir(parents=True, exist_ok=True)
    return output_root


def resolve_plugin_filter(source: Path, include_plugins: str | None) -> set[str] | None:
    if not include_plugins:
        return None
    plugin_filter = {p.strip() for p in include_plugins.split(",") if p.strip()}
    marketplace_plugins = load_marketplace_plugins(source)
    if marketplace_plugins:
        plugin_filter = {p for p in plugin_filter if p in marketplace_plugins}
    return plugin_filter


def write_decision_log(path: Path, decisions: list[DecisionRecord]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    serializable: list[dict[str, object]] = []
    for d in decisions:
        serializable.append(
            {
                "plugin": d.plugin,
                "classification": d.classification,
                "mapping_entries": [
                    {
                        "name": m.name,
                        "applyTo": m.apply_to,
                        "agentHint": m.agent_hint,
                        "description": m.description,
                        "source": m.source,
                    }
                    for m in d.mapping_entries
                ],
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
                "command_neighbors": d.command_neighbors,
            }
        )
    path.write_text(json.dumps(serializable, indent=2, sort_keys=True), encoding="utf-8")


def process_plugin_agents(plugin_path: Path, agents_dir: Path, skip_agents: bool) -> None:
    if skip_agents:
        return
    plugin_name = plugin_path.name
    for agent_file in (plugin_path / "agents").glob("*.md"):
        destination = agents_dir / f"{plugin_name}__{agent_file.name}"
        from copilot_converter.builders import (
            build_agent_file,  # local import to avoid cycle
        )

        build_agent_file(agent_file, destination)


def process_plugin_skills(
    plugin_path: Path,
    skills_dir: Path,
    skip_skills: bool,
    skill_files: list[Path] | None = None,
) -> None:
    if skip_skills:
        return
    plugin_name = plugin_path.name
    files = (
        sorted(skill_files, key=lambda p: p.parent.name)
        if skill_files is not None
        else sorted((plugin_path / "skills").glob(SKILL_GLOB), key=lambda p: p.parent.name)
    )
    for skill_file in files:
        skill_name = skill_file.parent.name
        from copilot_converter.builders import (
            build_skill_file,  # local import to avoid cycle
        )

        skill_output_dir = skills_dir / f"{plugin_name}__{skill_name}"
        destination = skill_output_dir / "SKILL.md"
        build_skill_file(skill_file, destination, plugin_name)


def process_remaining_artifacts(
    plugin_path: Path,
    skills_dir: Path,
    prompts_dir: Path,
    plugin_name: str,
    skill_files: list[Path],
    command_files: list[Path],
    agent_persona: str | None,
):
    reasons: list[str] = []

    outputs: list[str] = []
    if skill_files:
        outputs.extend(create_skill_output(plugin_path, skills_dir, plugin_name, agent_persona, skill_files))
        if outputs:
            reasons.append("remaining_skills_generated")
    else:
        reasons.append("no_remaining_skills")

    prompts: list[str] = []
    command_previews: list[dict[str, str]] = []
    if command_files:
        prompts, command_previews = build_prompts_for_plugin(
            plugin_path,
            prompts_dir,
            plugin_name,
            agent_persona,
            command_files=command_files,
        )
        reasons.append("remaining_commands_prompts_generated")
    else:
        reasons.append("no_remaining_commands")

    return (
        outputs,
        prompts,
        command_previews,
        reasons,
    )


def process_single_plugin(
    plugin_path: Path,
    output_root: Path,
    neighbor_map: dict[str, list[dict[str, object]]],
    cluster_map: dict[str, int],
):
    plugin_name = plugin_path.name
    instructions_dir = output_root / "instructions"
    prompts_dir = output_root / "prompts"
    skills_dir = output_root / "skills"

    mapping_entries = get_mapping_entries(plugin_name)
    skill_files = sorted((plugin_path / "skills").glob(SKILL_GLOB), key=lambda p: p.parent.name)
    command_files = sorted((plugin_path / "commands").glob("*.md"), key=lambda p: p.name)
    agents = [p.name for p in sorted((plugin_path / "agents").glob("*.md"), key=lambda p: p.name)]
    commands = [p.name for p in command_files]
    skills = [p.parent.name for p in skill_files]
    classification = "instruction" if mapping_entries else "skill"

    agent_hint = mapping_entries[0].agent_hint if mapping_entries else None
    agent_persona, selected_agent_name = extract_agent_persona(plugin_path, agent_hint)

    suffix_result = strip_suffix_scoped_artifacts(
        plugin_path=plugin_path,
        instructions_dir=instructions_dir,
        prompts_dir=prompts_dir,
        mapping_entries=mapping_entries,
        skill_files=skill_files,
        command_files=command_files,
    )

    remaining_skill_files = [path for path in skill_files if path not in suffix_result.consumed_skill_files]
    remaining_command_files = [path for path in command_files if path not in suffix_result.consumed_command_files]

    process_plugin_skills(
        plugin_path=plugin_path,
        skills_dir=skills_dir,
        skip_skills=not remaining_skill_files,
        skill_files=remaining_skill_files,
    )

    cmd_neighbors: list[dict[str, object]] = []
    for cmd in commands:
        key = f"{plugin_name}::{Path(cmd).stem}" if "::" not in cmd else cmd
        cmd_neighbors.append(
            {
                "command": cmd,
                "neighbors": neighbor_map.get(key, []),
                "cluster_id": cluster_map.get(key),
            }
        )

    outputs = list(suffix_result.outputs)
    prompts = list(suffix_result.prompts)
    command_previews = list(suffix_result.command_previews)
    reasons = list(suffix_result.reasons)

    remaining_outputs, remaining_prompts, remaining_previews, remaining_reasons = process_remaining_artifacts(
        plugin_path=plugin_path,
        skills_dir=skills_dir,
        prompts_dir=prompts_dir,
        plugin_name=plugin_name,
        skill_files=remaining_skill_files,
        command_files=remaining_command_files,
        agent_persona=agent_persona,
    )
    outputs.extend(remaining_outputs)
    prompts.extend(remaining_prompts)
    command_previews.extend(remaining_previews)
    reasons.extend(remaining_reasons)

    if agent_persona is None:
        reasons.append("persona_missing")

    agent_persona_preview = preview_text(agent_persona)
    skill_previews = collect_skill_previews(plugin_path)

    return DecisionRecord(
        plugin=plugin_name,
        classification=classification,
        mapping_entries=mapping_entries,
        outputs=outputs,
        prompts=prompts,
        agents=agents,
        commands=commands,
        skills=skills,
        plugin_path=str(plugin_path),
        selected_agent=selected_agent_name,
        agent_persona_preview=agent_persona_preview,
        command_previews=command_previews,
        skill_previews=skill_previews,
        notes=None,
        reasons=reasons,
        command_neighbors=cmd_neighbors,
    )


def process_plugins(plugin_dirs: Iterable[Path], output_root: Path, args: argparse.Namespace) -> list[DecisionRecord]:
    command_docs = build_command_docs(plugin_dirs)
    vectors = compute_tfidf_vectors(command_docs) if command_docs else []
    neighbor_map = build_command_neighbors(command_docs, vectors) if command_docs else {}
    cluster_map = cluster_commands(command_docs, vectors) if command_docs else {}

    instructions_dir = output_root / "instructions"
    prompts_dir = output_root / "prompts"
    skills_dir = output_root / "skills"
    cluster_prompts_dir = output_root / "prompts_clusters"

    ensure_empty_dir(instructions_dir, args.overwrite)
    ensure_empty_dir(skills_dir, args.overwrite)
    ensure_empty_dir(prompts_dir, args.overwrite)
    ensure_empty_dir(cluster_prompts_dir, args.overwrite)

    decisions: list[DecisionRecord] = []
    for plugin_path in plugin_dirs:
        decisions.append(process_single_plugin(plugin_path, output_root, neighbor_map, cluster_map))

    if args.decision_log and command_docs and vectors and cluster_map:
        cluster_report_path = Path(args.decision_log).with_name("cluster_report.json")
        write_cluster_report(cluster_report_path, command_docs, vectors, cluster_map)

        cluster_prompt_records = build_cluster_prompts(
            cluster_prompts_dir,
            cluster_map,
            command_docs,
            vectors,
            args.cluster_include_singletons,
        )
        cluster_prompt_report_path = Path(args.decision_log).with_name("cluster_prompts_report.json")
        cluster_prompt_report_path.parent.mkdir(parents=True, exist_ok=True)
        cluster_prompt_report_path.write_text(
            json.dumps(cluster_prompt_records, indent=2, sort_keys=True),
            encoding="utf-8",
        )

    return decisions


def maybe_init(output_root: Path, source: Path, init_flag: bool) -> None:
    if not init_flag:
        return
    write_copilot_instructions(output_root)
    write_vscode_settings(source)
