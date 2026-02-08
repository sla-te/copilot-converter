import json
import math
import re
import shutil
from dataclasses import dataclass
from pathlib import Path

from .file_ops import read_text, write_text
from .frontmatter import parse_simple_frontmatter, split_frontmatter

_TOKEN_RE = re.compile(r"[^a-z0-9]+")
_GENERIC_TOKENS = {
    "agent",
    "agents",
    "code",
    "coding",
    "copilot",
    "custom",
    "development",
    "developer",
    "guide",
    "guides",
    "pattern",
    "patterns",
    "skill",
    "skills",
    "tool",
    "tools",
    "workflow",
    "workflows",
}
_STOPWORDS = {
    "a",
    "all",
    "and",
    "are",
    "can",
    "for",
    "from",
    "how",
    "into",
    "that",
    "the",
    "this",
    "to",
    "use",
    "using",
    "via",
    "what",
    "when",
    "where",
    "why",
    "with",
    "you",
    "your",
}
_TOKEN_SYNONYMS = {
    "appinsights": "applicationinsights",
    "azurerm": "azure",
    "gh": "github",
    "imagemagick": "image-magick",
    "webapp": "web-app",
}


@dataclass(frozen=True)
class SkillDoc:
    folder: str
    path: Path
    name: str
    description: str
    raw_text: str
    normalized_name: str
    name_tokens: frozenset[str]
    core_tokens: frozenset[str]
    vector: dict[str, float]


def _normalize_token(token: str) -> str:
    clean = token.lower().strip()
    if not clean:
        return ""
    return _TOKEN_SYNONYMS.get(clean, clean)


def _normalize_name(value: str) -> str:
    return "-".join(_tokenize(value, keep_generic=True))


def _tokenize(text: str, keep_generic: bool = False) -> list[str]:
    tokens: list[str] = []
    for raw in _TOKEN_RE.split(text.lower()):
        token = _normalize_token(raw)
        if len(token) < 3:
            continue
        if token in _STOPWORDS:
            continue
        if not keep_generic and token in _GENERIC_TOKENS:
            continue
        tokens.append(token)
    return tokens


def _extract_skill_doc(path: Path) -> tuple[str, str, str]:
    content = read_text(path)
    split = split_frontmatter(content)
    meta = parse_simple_frontmatter(split.frontmatter)
    name = meta.get("name", path.parent.name)
    description = meta.get("description", "")
    # Truncate body section for similarity checks to keep the signal focused.
    text_for_similarity = f"{name}\n{description}\n{split.body[:5000]}"
    return name, description, text_for_similarity


def _collect_skill_candidates(skills_root: Path) -> list[tuple[str, Path, str, str, str]]:
    candidates: list[tuple[str, Path, str, str, str]] = []
    for skill_file in sorted(skills_root.glob("*/SKILL.md")):
        folder = skill_file.parent.name
        name, description, text_for_similarity = _extract_skill_doc(skill_file)
        candidates.append((folder, skill_file, name, description, text_for_similarity))
    return candidates


def _build_vectors(candidates: list[tuple[str, Path, str, str, str]]) -> list[SkillDoc]:
    tokenized: list[list[str]] = []
    for _, _, _, _, raw_text in candidates:
        tokenized.append(_tokenize(raw_text, keep_generic=False))

    df: dict[str, int] = {}
    for tokens in tokenized:
        for token in set(tokens):
            df[token] = df.get(token, 0) + 1

    total_docs = len(candidates)
    docs: list[SkillDoc] = []
    for idx, (folder, path, name, description, raw_text) in enumerate(candidates):
        tokens = tokenized[idx]
        tf: dict[str, int] = {}
        for token in tokens:
            tf[token] = tf.get(token, 0) + 1

        vector: dict[str, float] = {}
        for token, freq in tf.items():
            vector[token] = freq * (1.0 + total_docs / (1 + df[token]))

        name_tokens = frozenset(_tokenize(f"{folder} {name}", keep_generic=False))
        core_tokens = frozenset(_tokenize(f"{name} {description}", keep_generic=False))

        docs.append(
            SkillDoc(
                folder=folder,
                path=path,
                name=name,
                description=description,
                raw_text=raw_text,
                normalized_name=_normalize_name(name or folder),
                name_tokens=name_tokens,
                core_tokens=core_tokens,
                vector=vector,
            )
        )

    return docs


def _cosine_similarity(vec_a: dict[str, float], vec_b: dict[str, float]) -> float:
    if not vec_a or not vec_b:
        return 0.0
    common = set(vec_a).intersection(vec_b)
    numerator = sum(vec_a[token] * vec_b[token] for token in common)
    den_a = math.sqrt(sum(value * value for value in vec_a.values()))
    den_b = math.sqrt(sum(value * value for value in vec_b.values()))
    if den_a == 0.0 or den_b == 0.0:
        return 0.0
    return numerator / (den_a * den_b)


def _jaccard_similarity(left: frozenset[str], right: frozenset[str]) -> float:
    if not left or not right:
        return 0.0
    union = left.union(right)
    if not union:
        return 0.0
    return len(left.intersection(right)) / len(union)


def _is_comparable(source: SkillDoc, target: SkillDoc) -> bool:
    if source.normalized_name and source.normalized_name == target.normalized_name:
        return True
    if source.folder == target.folder:
        return True
    if len(source.name_tokens.intersection(target.name_tokens)) >= 2:
        return True
    if source.core_tokens.intersection(target.core_tokens):
        return True
    return False


def _score_similarity(source: SkillDoc, target: SkillDoc) -> tuple[float, float, float, float]:
    name_score = _jaccard_similarity(source.name_tokens, target.name_tokens)
    core_score = _jaccard_similarity(source.core_tokens, target.core_tokens)
    text_score = _cosine_similarity(source.vector, target.vector)
    combined = (0.45 * name_score) + (0.35 * core_score) + (0.20 * text_score)
    return combined, name_score, core_score, text_score


def _resolve_skills_root(source_path: Path) -> Path:
    if (source_path / "skills").is_dir():
        return source_path / "skills"
    return source_path


def _rebuild_destination_docs(destination_skills_dir: Path, source_docs: list[SkillDoc]) -> list[SkillDoc]:
    existing_candidates = _collect_skill_candidates(destination_skills_dir)
    combined_candidates = existing_candidates + [
        (doc.folder, doc.path, doc.name, doc.description, doc.raw_text) for doc in source_docs
    ]
    rebuilt = _build_vectors(combined_candidates)
    destination_folders = {folder for folder, _, _, _, _ in existing_candidates}
    return [doc for doc in rebuilt if doc.folder in destination_folders]


def merge_external_skills(
    source_paths: list[Path],
    destination_skills_dir: Path,
    report_path: Path,
    auto_dedupe_threshold: float,
    manual_review_threshold: float,
    import_manual_review: bool,
) -> dict:
    destination_skills_dir.mkdir(parents=True, exist_ok=True)
    report_path.parent.mkdir(parents=True, exist_ok=True)

    source_roots = [_resolve_skills_root(path.expanduser().resolve()) for path in source_paths]

    source_candidates: list[tuple[str, Path, str, str, str]] = []
    for source_root in source_roots:
        source_candidates.extend(_collect_skill_candidates(source_root))

    existing_candidates = _collect_skill_candidates(destination_skills_dir)
    all_candidates = existing_candidates + source_candidates
    all_docs = _build_vectors(all_candidates)

    destination_folder_names = {folder for folder, _, _, _, _ in existing_candidates}
    source_folder_names = {folder for folder, _, _, _, _ in source_candidates}
    source_docs = [
        doc for doc in all_docs if doc.folder in source_folder_names and doc.path.parent.parent in source_roots
    ]
    destination_docs = [
        doc
        for doc in all_docs
        if doc.folder in destination_folder_names and doc.path.parent.parent == destination_skills_dir
    ]
    destination_by_folder = {doc.folder: doc for doc in destination_docs}

    auto_keep: list[dict[str, object]] = []
    auto_dedupe: list[dict[str, object]] = []
    manual_review: list[dict[str, object]] = []
    added_paths: list[str] = []

    for source_doc in source_docs:
        if source_doc.folder in destination_by_folder:
            auto_dedupe.append(
                {
                    "source": source_doc.folder,
                    "matched_existing": source_doc.folder,
                    "reason": "folder_name_exists",
                    "score": 1.0,
                }
            )
            continue

        candidates = [target for target in destination_docs if _is_comparable(source_doc, target)]
        if not candidates:
            auto_keep.append(
                {
                    "source": source_doc.folder,
                    "matched_existing": None,
                    "reason": "no_comparable_candidate",
                    "score": 0.0,
                }
            )
            target_dir = destination_skills_dir / source_doc.folder
            shutil.copytree(source_doc.path.parent, target_dir)
            added_paths.append(str(target_dir))
            destination_docs = _rebuild_destination_docs(destination_skills_dir, source_docs)
            destination_by_folder = {doc.folder: doc for doc in destination_docs}
            continue

        best = None
        best_score = -1.0
        for target in candidates:
            combined, name_score, core_score, text_score = _score_similarity(source_doc, target)
            if combined > best_score:
                best_score = combined
                best = (target, name_score, core_score, text_score)

        if best is None:
            continue

        best_target, name_score, core_score, text_score = best
        row = {
            "source": source_doc.folder,
            "matched_existing": best_target.folder,
            "score": round(best_score, 4),
            "name_similarity": round(name_score, 4),
            "core_similarity": round(core_score, 4),
            "text_similarity": round(text_score, 4),
        }

        if best_score >= auto_dedupe_threshold:
            row["reason"] = "high_similarity_auto_dedupe"
            auto_dedupe.append(row)
            continue

        if best_score >= manual_review_threshold:
            row["reason"] = "ambiguous_manual_review"
            manual_review.append(row)
            if not import_manual_review:
                continue

        if best_score < manual_review_threshold:
            row["reason"] = "low_overlap_auto_keep"
        auto_keep.append(row)
        target_dir = destination_skills_dir / source_doc.folder
        shutil.copytree(source_doc.path.parent, target_dir)
        added_paths.append(str(target_dir))
        destination_docs = _rebuild_destination_docs(destination_skills_dir, source_docs)
        destination_by_folder = {doc.folder: doc for doc in destination_docs}

    report = {
        "strategy": {
            "approach": "hybrid-gated-with-manual-review",
            "auto_dedupe_threshold": auto_dedupe_threshold,
            "manual_review_threshold": manual_review_threshold,
            "import_manual_review": import_manual_review,
        },
        "paths": {
            "sources": [str(path) for path in source_roots],
            "destination": str(destination_skills_dir),
        },
        "counts": {
            "source_total": len(source_docs),
            "auto_keep": len(auto_keep),
            "auto_dedupe": len(auto_dedupe),
            "manual_review": len(manual_review),
            "added": len(added_paths),
        },
        "auto_keep": auto_keep,
        "auto_dedupe": auto_dedupe,
        "manual_review": manual_review,
        "added_paths": added_paths,
    }
    write_text(report_path, json.dumps(report, indent=2, sort_keys=True))
    return report
