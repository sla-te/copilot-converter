from __future__ import annotations

import json
from pathlib import Path

from .file_ops import read_text
from .models import MappingEntry


def load_mappings(mapping_path: Path | None = None) -> dict:
    path = mapping_path or Path(__file__).with_name("plugin_mappings.json")
    if not path.exists():
        return {}
    try:
        return json.loads(read_text(path))
    except json.JSONDecodeError:
        return {}


def get_mapping_entries(
    plugin_name: str, mapping_path: Path | None = None
) -> list[MappingEntry]:
    mappings = load_mappings(mapping_path)
    prefix = f"{plugin_name}-"
    entries: list[MappingEntry] = []

    for key, value in mappings.items():
        if key == plugin_name or key.startswith(prefix):
            apply_to = value.get("applyTo")
            if apply_to:
                entries.append(
                    MappingEntry(
                        name=str(key),
                        apply_to=str(apply_to),
                        agent_hint=value.get("agentHint"),
                        description=value.get("description"),
                        source="explicit",
                    )
                )

    return entries
