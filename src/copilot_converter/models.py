from dataclasses import dataclass
from typing import Dict, List, Optional


@dataclass(frozen=True)
class FrontmatterSplit:
    frontmatter: Optional[str]
    body: str


@dataclass(frozen=True)
class MappingEntry:
    name: str
    apply_to: str
    agent_hint: Optional[str]
    description: Optional[str]
    source: str  # explicit | heuristic


@dataclass(frozen=True)
class DecisionRecord:
    plugin: str
    classification: str  # instruction | skill
    mapping_entries: List[MappingEntry]
    outputs: List[str]
    prompts: List[str]
    agents: List[str]
    commands: List[str]
    skills: List[str]
    plugin_path: str
    selected_agent: Optional[str]
    agent_persona_preview: Optional[str]
    command_previews: List[Dict[str, str]]
    skill_previews: List[Dict[str, str]]
    notes: Optional[str]
    reasons: List[str]
    command_neighbors: List[Dict[str, object]]


@dataclass(frozen=True)
class CommandDoc:
    plugin: str
    name: str
    path: str
    text: str
