import json
import math
from pathlib import Path
from typing import Iterable

from .constants import FRONTMATTER_DELIM
from .file_ops import read_text, write_text
from .frontmatter import yaml_quote
from .models import CommandDoc


def tokenize(text: str) -> list[str]:
    import re

    return [t for t in re.split(r"[^a-zA-Z0-9]+", text.lower()) if t]


def build_command_docs(plugin_dirs: Iterable[Path]) -> list[CommandDoc]:
    docs: list[CommandDoc] = []
    for plugin_path in plugin_dirs:
        plugin_name = plugin_path.name
        for command_file in (plugin_path / "commands").glob("*.md"):
            try:
                text = read_text(command_file)
            except FileNotFoundError:
                continue
            docs.append(
                CommandDoc(
                    plugin=plugin_name,
                    name=command_file.stem,
                    path=str(command_file),
                    text=text,
                )
            )
    return docs


def compute_tfidf_vectors(docs: list[CommandDoc]) -> list[dict[str, float]]:
    term_freqs: list[dict[str, int]] = []
    df: dict[str, int] = {}
    for doc in docs:
        tokens = tokenize(doc.text)
        tf: dict[str, int] = {}
        for tok in tokens:
            tf[tok] = tf.get(tok, 0) + 1
        term_freqs.append(tf)
        for tok in tf:
            df[tok] = df.get(tok, 0) + 1

    n = len(docs)
    vectors: list[dict[str, float]] = []
    for tf in term_freqs:
        vec: dict[str, float] = {}
        for tok, freq in tf.items():
            idf = 1.0 + (n / (1 + df.get(tok, 0)))
            vec[tok] = freq * idf
        vectors.append(vec)
    return vectors


def cosine_similarity(vec_a: dict[str, float], vec_b: dict[str, float]) -> float:
    if not vec_a or not vec_b:
        return 0.0
    common = set(vec_a).intersection(vec_b)
    num = sum(vec_a[t] * vec_b[t] for t in common)
    denom_a = math.sqrt(sum(v * v for v in vec_a.values()))
    denom_b = math.sqrt(sum(v * v for v in vec_b.values()))
    if denom_a == 0 or denom_b == 0:
        return 0.0
    return num / (denom_a * denom_b)


def build_command_neighbors(
    docs: list[CommandDoc], vectors: list[dict[str, float]], top_k: int = 3
) -> dict[str, list[dict[str, object]]]:
    neighbors: dict[str, list[dict[str, object]]] = {}
    for idx, doc in enumerate(docs):
        sims: list[tuple[float, CommandDoc]] = []
        for jdx, other in enumerate(docs):
            if idx == jdx:
                continue
            score = cosine_similarity(vectors[idx], vectors[jdx])
            sims.append((score, other))
        sims.sort(key=lambda x: x[0], reverse=True)
        top = [
            {
                "plugin": o.plugin,
                "command": o.name,
                "path": o.path,
                "score": round(s, 4),
            }
            for s, o in sims[:top_k]
            if s > 0
        ]
        neighbors[f"{doc.plugin}::{doc.name}"] = top
    return neighbors


def group_cluster_indices(cluster_map: dict[str, int], key_to_index: dict[str, int]) -> dict[int, list[int]]:
    grouped: dict[int, list[int]] = {}
    for key, cid in cluster_map.items():
        idx = key_to_index.get(key)
        if idx is None:
            continue
        grouped.setdefault(cid, []).append(idx)
    return grouped


def cluster_top_tokens(indices: list[int], vectors: list[dict[str, float]], top_n: int = 6) -> list[str]:
    centroid: dict[str, float] = {}
    for idx in indices:
        for tok, val in vectors[idx].items():
            centroid[tok] = centroid.get(tok, 0.0) + val
    for tok in centroid:
        centroid[tok] /= len(indices)
    return [tok for tok, _ in sorted(centroid.items(), key=lambda x: x[1], reverse=True)[:top_n]]


def render_cluster_prompt(
    output_dir: Path,
    cid: int,
    indices: list[int],
    docs: list[CommandDoc],
    vectors: list[dict[str, float]],
) -> dict[str, object]:
    top_tokens = cluster_top_tokens(indices, vectors)
    prompt_name = f"cluster-{cid}"
    description_tokens = ", ".join(top_tokens[:4]) if top_tokens else "Cluster prompt"

    frontmatter = "\n".join(
        [
            FRONTMATTER_DELIM,
            f"name: {yaml_quote(prompt_name)}",
            f"description: {yaml_quote(description_tokens or prompt_name)}",
            FRONTMATTER_DELIM,
            "",
        ]
    )

    body_parts = [f"# Cluster {cid} Prompt\n", "## Commands\n"]
    members: list[dict[str, str]] = []
    for idx in indices:
        doc = docs[idx]
        body_parts.append(f"- {doc.plugin} :: {doc.name}\n")
        members.append(
            {
                "plugin": doc.plugin,
                "command": doc.name,
                "path": doc.path,
            }
        )

    output_path = output_dir / f"{prompt_name}.prompt.md"
    write_text(output_path, frontmatter + "\n".join(body_parts))

    return {
        "cluster_id": cid,
        "prompt_path": str(output_path),
        "members": members,
        "top_tokens": top_tokens,
    }


def cluster_commands(
    docs: list[CommandDoc], vectors: list[dict[str, float]], threshold: float = 0.35
) -> dict[str, int]:
    n = len(docs)
    labels = [-1] * n
    cluster_id = 0
    for i in range(n):
        if labels[i] != -1:
            continue
        labels[i] = cluster_id
        for j in range(i + 1, n):
            if labels[j] != -1:
                continue
            if cosine_similarity(vectors[i], vectors[j]) >= threshold:
                labels[j] = cluster_id
        cluster_id += 1

    return {f"{doc.plugin}::{doc.name}": labels[idx] for idx, doc in enumerate(docs)}


def build_cluster_prompts(
    output_dir: Path,
    cluster_map: dict[str, int],
    docs: list[CommandDoc],
    vectors: list[dict[str, float]],
    include_singletons: bool,
) -> list[dict[str, object]]:
    if not cluster_map or not docs:
        return []

    output_dir.mkdir(parents=True, exist_ok=True)

    key_to_index = {f"{d.plugin}::{d.name}": idx for idx, d in enumerate(docs)}
    grouped = group_cluster_indices(cluster_map, key_to_index)

    prompt_records: list[dict[str, object]] = []
    for cid, indices in sorted(grouped.items()):
        if not indices:
            continue
        if not include_singletons and len(indices) == 1:
            continue
        prompt_records.append(render_cluster_prompt(output_dir, cid, indices, docs, vectors))

    return prompt_records


def write_cluster_report(
    path: Path,
    docs: list[CommandDoc],
    vectors: list[dict[str, float]],
    cluster_map: dict[str, int],
) -> None:
    if not docs or not vectors or not cluster_map:
        return

    by_cluster: dict[int, list[int]] = {}
    key_to_index = {f"{d.plugin}::{d.name}": idx for idx, d in enumerate(docs)}
    for key, cid in cluster_map.items():
        idx = key_to_index.get(key)
        if idx is None:
            continue
        by_cluster.setdefault(cid, []).append(idx)

    clusters: list[dict[str, object]] = []
    for cid, indices in sorted(by_cluster.items()):
        centroid: dict[str, float] = {}
        for idx in indices:
            for tok, val in vectors[idx].items():
                centroid[tok] = centroid.get(tok, 0.0) + val
        for tok in centroid:
            centroid[tok] /= len(indices)

        top_tokens = sorted(centroid.items(), key=lambda x: x[1], reverse=True)[:8]
        members = [
            {
                "plugin": docs[idx].plugin,
                "command": docs[idx].name,
                "path": docs[idx].path,
            }
            for idx in indices
        ]
        clusters.append(
            {
                "cluster_id": cid,
                "size": len(indices),
                "top_tokens": top_tokens,
                "members": members,
            }
        )

    report = {"cluster_count": len(clusters), "clusters": clusters}
    write_text(path, json.dumps(report, indent=2, sort_keys=True))
