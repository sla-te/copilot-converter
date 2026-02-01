from __future__ import annotations

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


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Convert Claude Code agents to GitHub Copilot artifacts."
    )
    parser.add_argument(
        "--source", required=True, help="Path to the wshobson/agents repository"
    )
    parser.add_argument(
        "--output", default=None, help="Output directory (default: <source>/.github)"
    )
    parser.add_argument(
        "--include-plugins",
        default=None,
        help="Comma-separated plugin names to include",
    )
    parser.add_argument(
        "--overwrite", action="store_true", help="Overwrite existing output folders"
    )
    parser.add_argument(
        "--init",
        action="store_true",
        help="Also write .vscode/settings.json and .github/copilot-instructions.md",
    )
    parser.add_argument(
        "--decision-log",
        default=None,
        help=(
            "Path to write a JSON decision log with classification context. "
            "If omitted, no log is written."
        ),
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

    if args.decision_log:
        write_decision_log(Path(args.decision_log), decisions)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
