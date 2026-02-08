import argparse
from pathlib import Path

from .processing import (
    iter_plugin_dirs,
    maybe_init,
    process_plugins,
    resolve_output_root,
    resolve_plugin_filter,
    resolve_source,
    write_decision_log,
)
from .skill_merge import merge_external_skills


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Convert Claude Code agents to GitHub Copilot artifacts.")
    parser.add_argument("--source", required=True, help="Path to the wshobson/agents repository")
    parser.add_argument("--output", default=None, help="Output directory (default: <source>/.github)")
    parser.add_argument(
        "--include-plugins",
        default=None,
        help="Comma-separated plugin names to include",
    )
    parser.add_argument("--overwrite", action="store_true", help="Overwrite existing output folders")
    parser.add_argument(
        "--init",
        action="store_true",
        help="Also write .vscode/settings.json and .github/copilot-instructions.md",
    )
    parser.add_argument(
        "--decision-log",
        default=None,
        help=("Path to write a JSON decision log with classification context. If omitted, no log is written."),
    )
    parser.add_argument(
        "--cluster-prompts",
        action="store_true",
        help="Also emit cluster-level prompts (experimental). Default off to avoid prompt bloat.",
    )
    parser.add_argument(
        "--cluster-include-singletons",
        action="store_true",
        help="Include singleton clusters when emitting cluster prompts (default: skip).",
    )
    parser.add_argument(
        "--merge-skills-from",
        action="append",
        default=[],
        help=(
            "Path to an external skills source (repo root containing /skills or a /skills dir). "
            "Repeat to merge multiple sources."
        ),
    )
    parser.add_argument(
        "--merge-skills-report",
        default=None,
        help="Path to write merge report JSON (default: <output>/skills-merge-report.json).",
    )
    parser.add_argument(
        "--merge-skills-auto-dedupe-threshold",
        type=float,
        default=0.88,
        help="High-confidence duplicate threshold for auto skip (default: 0.88).",
    )
    parser.add_argument(
        "--merge-skills-manual-review-threshold",
        type=float,
        default=0.55,
        help="Ambiguous overlap threshold for manual review (default: 0.55).",
    )
    parser.add_argument(
        "--merge-skills-import-manual-review",
        action="store_true",
        help="Also import manual-review candidates (off by default to avoid redundancy).",
    )
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)

    source = resolve_source(args.source)
    output_root = resolve_output_root(source, args.output)
    plugin_filter = resolve_plugin_filter(source, args.include_plugins)
    plugin_dirs = list(iter_plugin_dirs(source, plugin_filter))

    decisions = process_plugins(plugin_dirs, output_root, args)

    maybe_init(output_root, source, args.init)

    if args.merge_skills_from:
        report_path = (
            Path(args.merge_skills_report).expanduser().resolve()
            if args.merge_skills_report
            else output_root / "skills-merge-report.json"
        )
        merge_external_skills(
            source_paths=[Path(item).expanduser().resolve() for item in args.merge_skills_from],
            destination_skills_dir=output_root / "skills",
            report_path=report_path,
            auto_dedupe_threshold=args.merge_skills_auto_dedupe_threshold,
            manual_review_threshold=args.merge_skills_manual_review_threshold,
            import_manual_review=args.merge_skills_import_manual_review,
        )

    if args.decision_log:
        write_decision_log(Path(args.decision_log), decisions)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
