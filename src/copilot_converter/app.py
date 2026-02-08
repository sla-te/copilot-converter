import argparse
from pathlib import Path

from .processing import (
    iter_plugin_dirs,
    process_plugins,
    resolve_output_root,
    resolve_source,
    sync_plugin_selection,
    write_decision_log,
    write_marketplace_manifest,
)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Convert wshobson/agents Claude plugins into Copilot plugin bundles (1:1)."
    )
    parser.add_argument(
        "agents_source",
        nargs="?",
        default="/home/toor/code/agents",
        help="Path to wshobson/agents (default: /home/toor/code/agents)",
    )
    parser.add_argument(
        "--output",
        default=str(Path.cwd() / "plugins"),
        help="Output directory for generated Copilot plugins (default: ./plugins)",
    )
    parser.add_argument(
        "--decision-log",
        default=None,
        help=("Path to write a JSON decision log. If omitted, no log is written."),
    )
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    args.overwrite = True

    agents_source = resolve_source(args.agents_source)
    output_root = resolve_output_root(args.output)
    plugin_config_path = Path.cwd() / "plugin-selection.json"

    enabled_plugins = sync_plugin_selection(agents_source, plugin_config_path)
    plugin_dirs = list(iter_plugin_dirs(agents_source, enabled_plugins))

    decisions = process_plugins(plugin_dirs, output_root, args)
    write_marketplace_manifest(Path.cwd(), output_root)

    if args.decision_log:
        write_decision_log(Path(args.decision_log), decisions)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
