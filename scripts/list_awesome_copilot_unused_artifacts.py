#!/usr/bin/env python3
"""List awesome-copilot artifacts not referenced by plugins.

References are resolved from plugin wrappers in:
- plugins/*/agents/*.md
- plugins/*/commands/*.md
- plugins/*/skills/*

Wrapper resolution supports both:
- filesystem symlinks
- markdown single-link wrappers (after optional frontmatter)
"""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Iterable

FRONTMATTER_RE = re.compile(r"(?s)^---\r?\n.*?\r?\n---\r?\n")
LINK_RE = re.compile(r"\[[^\]]+\]\(([^)]+)\)")
SKILL_HINT_RE = re.compile(r"(?i)\b(relevant skills?|use (?:the )?skills?|use (?:the )?skill|skills?:)\b")


def is_relative_to(path: Path, base: Path) -> bool:
    try:
        path.relative_to(base)
        return True
    except ValueError:
        return False


def parse_markdown_link_target(md_path: Path) -> Path | None:
    try:
        text = md_path.read_text(encoding="utf-8")
    except Exception:
        return None

    body = FRONTMATTER_RE.sub("", text, count=1).strip()
    match = LINK_RE.search(body)
    if not match:
        return None

    target = match.group(1).strip()
    if (
        not target
        or target.startswith("http://")
        or target.startswith("https://")
        or target.startswith("mailto:")
        or target.startswith("#")
    ):
        return None

    target = target.split("#", 1)[0].strip()
    if not target:
        return None

    return (md_path.parent / target).resolve()


def resolve_wrapper_file(path: Path) -> Path | None:
    if path.is_symlink():
        try:
            return path.resolve()
        except Exception:
            return None

    target = parse_markdown_link_target(path)
    if target is not None:
        return target
    return path


def collect_wrapper_references(
    wrappers: Iterable[Path],
    *,
    kind: str,
    expected_root: Path,
    unresolved: list[dict],
) -> set[Path]:
    refs: set[Path] = set()
    for wrapper in sorted(wrappers):
        target = resolve_wrapper_file(wrapper)
        if target is None or not target.exists():
            unresolved.append({"wrapper": str(wrapper), "kind": kind})
            continue
        resolved_target = target.resolve()
        if resolved_target.is_file() and is_relative_to(resolved_target, expected_root):
            refs.add(resolved_target)
    return refs


def resolve_skill_target_dir(entry: Path, unresolved: list[dict]) -> Path | None:
    if entry.is_symlink():
        resolved_symlink = entry.resolve()
        if not resolved_symlink.exists():
            return None
        if resolved_symlink.is_dir():
            return resolved_symlink
        if resolved_symlink.is_file() and resolved_symlink.name.lower() == "skill.md":
            return resolved_symlink.parent
        return None

    if not entry.is_dir():
        return None

    skill_md = entry / "SKILL.md"
    if not skill_md.exists():
        return None

    resolved_skill = resolve_wrapper_file(skill_md)
    if resolved_skill is None or not resolved_skill.exists():
        unresolved.append({"wrapper": str(skill_md), "kind": "skill"})
        return None
    if resolved_skill.is_file() and resolved_skill.name.lower() == "skill.md":
        return resolved_skill.resolve().parent
    if resolved_skill.is_dir():
        return resolved_skill.resolve()
    return None


def collect_references(repo_root: Path) -> tuple[set[Path], set[Path], set[Path], list[dict]]:
    plugins_root = repo_root / "plugins"
    agents_root = repo_root / "agents"
    prompts_root = repo_root / "prompts"
    skills_root = repo_root / "skills"

    ref_agents: set[Path] = set()
    ref_prompts: set[Path] = set()
    ref_skills: set[Path] = set()
    unresolved: list[dict] = []

    for plugin_dir in sorted([p for p in plugins_root.iterdir() if p.is_dir()]):
        agents_dir = plugin_dir / "agents"
        if agents_dir.exists():
            ref_agents.update(
                collect_wrapper_references(
                    agents_dir.glob("*.md"),
                    kind="agent",
                    expected_root=agents_root,
                    unresolved=unresolved,
                )
            )

        commands_dir = plugin_dir / "commands"
        if commands_dir.exists():
            ref_prompts.update(
                collect_wrapper_references(
                    commands_dir.glob("*.md"),
                    kind="command",
                    expected_root=prompts_root,
                    unresolved=unresolved,
                )
            )

        skills_dir = plugin_dir / "skills"
        if skills_dir.exists():
            for entry in sorted(skills_dir.iterdir()):
                target_dir = resolve_skill_target_dir(entry, unresolved)
                if target_dir is None or not target_dir.exists() or not target_dir.is_dir():
                    continue
                if is_relative_to(target_dir, skills_root):
                    ref_skills.add(target_dir)

    return ref_agents, ref_prompts, ref_skills, unresolved


def collect_all_artifacts(repo_root: Path) -> tuple[set[Path], set[Path], set[Path]]:
    all_agents = {p.resolve() for p in (repo_root / "agents").glob("*.md") if p.is_file()}
    all_prompts = {p.resolve() for p in (repo_root / "prompts").glob("*.md") if p.is_file()}
    all_skills = {p.resolve() for p in (repo_root / "skills").iterdir() if p.is_dir() and (p / "SKILL.md").exists()}
    return all_agents, all_prompts, all_skills


def find_skill_mentions_with_context(skill_names: Iterable[str], text: str) -> list[str]:
    text_l = text.lower()
    matches: list[str] = []
    for name in skill_names:
        esc = re.escape(name)
        patterns = [
            rf"\b(?:use|using|relevant|related|required|recommended)\s+skills?\b[^\n]{{0,120}}(?<![a-z0-9]){esc}(?![a-z0-9])",
            rf"(?<![a-z0-9]){esc}(?![a-z0-9])[^\n]{{0,80}}\bskills?\b",
            rf"\bskills?\s*:\s*`?{esc}`?",
        ]
        if any(re.search(p, text_l) for p in patterns):
            matches.append(name)
    return sorted(set(matches))


def scan_unused_for_skill_references(
    repo_root: Path,
    unused_agents: list[Path],
    unused_prompts: list[Path],
    unused_skills: list[Path],
) -> list[dict]:
    skill_names = sorted([p.name.lower() for p in (repo_root / "skills").iterdir() if p.is_dir()])
    results: list[dict] = []

    def scan_file(file_path: Path, artifact_type: str) -> None:
        try:
            text = file_path.read_text(encoding="utf-8")
        except Exception:
            return

        hint_matches = [m.group(0) for m in SKILL_HINT_RE.finditer(text)]
        name_matches = find_skill_mentions_with_context(skill_names, text)
        if artifact_type == "skill":
            # Ignore self-mentions inside the same skill directory.
            for parent in file_path.parents:
                if parent.parent == repo_root / "skills":
                    self_skill_name = parent.name.lower()
                    name_matches = [n for n in name_matches if n != self_skill_name]
                    break
        if not hint_matches and not name_matches:
            return

        results.append(
            {
                "artifact": str(file_path.relative_to(repo_root)).replace("\\", "/"),
                "type": artifact_type,
                "skill_hint_phrases": sorted(set(hint_matches)),
                "mentioned_skill_names": name_matches,
            }
        )

    for file_path in unused_agents:
        scan_file(file_path, "agent")
    for file_path in unused_prompts:
        scan_file(file_path, "prompt")
    for skill_dir in unused_skills:
        for md_file in skill_dir.rglob("*.md"):
            scan_file(md_file, "skill")

    return results


def main() -> int:
    parser = argparse.ArgumentParser(description="List awesome-copilot artifacts not referenced by plugin wrappers.")
    parser.add_argument(
        "--repo-root",
        default="/home/toor/code/awesome-copilot",
        help="Path to awesome-copilot repository root",
    )
    parser.add_argument(
        "--output",
        default="",
        help="Optional path to write JSON output",
    )
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve()
    if not (repo_root / "plugins").exists():
        raise SystemExit(f"Missing plugins directory under: {repo_root}")

    ref_agents, ref_prompts, ref_skills, unresolved = collect_references(repo_root)
    all_agents, all_prompts, all_skills = collect_all_artifacts(repo_root)

    unused_agents = sorted(all_agents - ref_agents)
    unused_prompts = sorted(all_prompts - ref_prompts)
    unused_skills = sorted(all_skills - ref_skills)

    cross_refs = scan_unused_for_skill_references(repo_root, unused_agents, unused_prompts, unused_skills)

    report = {
        "repo_root": str(repo_root),
        "counts": {
            "all_agents": len(all_agents),
            "referenced_agents": len(ref_agents),
            "unused_agents": len(unused_agents),
            "all_prompts": len(all_prompts),
            "referenced_prompts": len(ref_prompts),
            "unused_prompts": len(unused_prompts),
            "all_skills": len(all_skills),
            "referenced_skills": len(ref_skills),
            "unused_skills": len(unused_skills),
            "unresolved_wrappers": len(unresolved),
            "unused_artifacts_with_skill_hints": len(cross_refs),
        },
        "unused_agents": [str(p.relative_to(repo_root)).replace("\\", "/") for p in unused_agents],
        "unused_prompts": [str(p.relative_to(repo_root)).replace("\\", "/") for p in unused_prompts],
        "unused_skills": [str(p.relative_to(repo_root)).replace("\\", "/") for p in unused_skills],
        "unused_artifacts_with_skill_hints": cross_refs,
        "unresolved_wrappers": unresolved,
    }

    serialized = json.dumps(report, indent=2)
    if args.output:
        output_path = Path(args.output).resolve()
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(serialized, encoding="utf-8")

    print(serialized)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
