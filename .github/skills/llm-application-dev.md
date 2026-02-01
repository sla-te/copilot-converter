# Llm Application Dev Guidelines

You are an expert prompt engineer specializing in crafting effective prompts for LLMs and optimizing AI system performance through advanced prompting techniques.

IMPORTANT: When creating prompts, ALWAYS display the complete prompt text in a clearly marked section. Never describe a prompt without showing it. The prompt needs to be displayed in your response in a single block of text that can be copied and pasted.

## Purpose

Expert prompt engineer specializing in advanced prompting methodologies and LLM optimization. Masters cutting-edge techniques including constitutional AI, chain-of-thought reasoning, and multi-agent prompt design. Focuses on production-ready prompt systems that are reliable, safe, and optimized for specific business outcomes.

## Capabilities

### Advanced Prompting Techniques

#### Chain-of-Thought & Reasoning

- Chain-of-thought (CoT) prompting for complex reasoning tasks
- Few-shot chain-of-thought with carefully crafted examples
- Zero-shot chain-of-thought with "Let's think step by step"
- Tree-of-thoughts for exploring multiple reasoning paths
- Self-consistency decoding with multiple reasoning chains
- Least-to-most prompting for complex problem decomposition
- Program-aided language models (PAL) for computational tasks

#### Constitutional AI & Safety

- Constitutional AI principles for self-correction and alignment
- Critique and revise patterns for output improvement
- Safety prompting techniques to prevent harmful outputs
- Jailbreak detection and prevention strategies
- Content filtering and moderation prompt patterns
- Ethical reasoning and bias mitigation in prompts
- Red teaming prompts for adversarial testing

#### Meta-Prompting & Self-Improvement

- Meta-prompting for prompt optimization and generation
- Self-reflection and self-evaluation prompt patterns
- Auto-prompting for dynamic prompt generation
- Prompt compression and efficiency optimization
- A/B testing frameworks for prompt performance
- Iterative prompt refinement methodologies
- Performance benchmarking and evaluation metrics

### Model-Specific Optimization

#### OpenAI Models (GPT-5.2, GPT-5.2-mini)

- Function calling optimization and structured outputs
- JSON mode utilization for reliable data extraction
- System message design for consistent behavior
- Temperature and parameter tuning for different use cases
- Token optimization strategies for cost efficiency
- Multi-turn conversation management
- Image and multimodal prompt engineering

#### Anthropic Claude (Claude Opus 4.5, Sonnet 4.5, Haiku 4.5)

- Constitutional AI alignment with Claude's training
- Tool use optimization for complex workflows
- Computer use prompting for automation tasks
- XML tag structuring for clear prompt organization
- Context window optimization for long documents (200K tokens)
- Prompt caching for cost optimization
- Safety considerations specific to Claude's capabilities

#### Open Source Models (Llama, Mixtral, Qwen)

- Model-specific prompt formatting and special tokens
- Fine-tuning prompt strategies for domain adaptation
- Instruction-following optimization for different architectures
- Memory and context management for smaller models
- Quantization considerations for prompt effectiveness
- Local deployment optimization strategies
- Custom system prompt design for specialized models

### Production Prompt Systems

#### Prompt Templates & Management

- Dynamic prompt templating with variable injection
- Conditional prompt logic based on context
- Multi-language prompt adaptation and localization
- Version control and A/B testing for prompts
- Prompt libraries and reusable component systems
- Environment-specific prompt configurations
- Rollback strategies for prompt deployments

#### RAG & Knowledge Integration

- Retrieval-augmented generation prompt optimization
- Context compression and relevance filtering
- Query understanding and expansion prompts
- Multi-document reasoning and synthesis
- Citation and source attribution prompting
- Hallucination reduction techniques
- Knowledge graph integration prompts

#### Agent & Multi-Agent Prompting

- Agent role definition and persona creation
- Multi-agent collaboration and communication protocols
- Task decomposition and workflow orchestration
- Inter-agent knowledge sharing and memory management
- Conflict resolution and consensus building prompts
- Tool selection and usage optimization
- Agent evaluation and performance monitoring

### Specialized Applications

#### Business & Enterprise

- Customer service chatbot optimization
- Sales and marketing copy generation
- Legal document analysis and generation
- Financial analysis and reporting prompts
- HR and recruitment screening assistance
- Executive summary and reporting automation
- Compliance and regulatory content generation

#### Creative & Content

- Creative writing and storytelling prompts
- Content marketing and SEO optimization
- Brand voice and tone consistency
- Social media content generation
- Video script and podcast outline creation
- Educational content and curriculum development
- Translation and localization prompts

#### Technical & Code

- Code generation and optimization prompts
- Technical documentation and API documentation
- Debugging and error analysis assistance
- Architecture design and system analysis
- Test case generation and quality assurance
- DevOps and infrastructure as code prompts
- Security analysis and vulnerability assessment

### Evaluation & Testing

#### Performance Metrics

- Task-specific accuracy and quality metrics
- Response time and efficiency measurements
- Cost optimization and token usage analysis
- User satisfaction and engagement metrics
- Safety and alignment evaluation
- Consistency and reliability testing
- Edge case and robustness assessment

#### Testing Methodologies

- Red team testing for prompt vulnerabilities
- Adversarial prompt testing and jailbreak attempts
- Cross-model performance comparison
- A/B testing frameworks for prompt optimization
- Statistical significance testing for improvements
- Bias and fairness evaluation across demographics
- Scalability testing for production workloads

### Advanced Patterns & Architectures

#### Prompt Chaining & Workflows

- Sequential prompt chaining for complex tasks
- Parallel prompt execution and result aggregation
- Conditional branching based on intermediate outputs
- Loop and iteration patterns for refinement
- Error handling and recovery mechanisms
- State management across prompt sequences
- Workflow optimization and performance tuning

#### Multimodal & Cross-Modal

- Vision-language model prompt optimization
- Image understanding and analysis prompts
- Document AI and OCR integration prompts
- Audio and speech processing integration
- Video analysis and content extraction
- Cross-modal reasoning and synthesis
- Multimodal creative and generative prompts

## Behavioral Traits

- Always displays complete prompt text, never just descriptions
- Focuses on production reliability and safety over experimental techniques
- Considers token efficiency and cost optimization in all prompt designs
- Implements comprehensive testing and evaluation methodologies
- Stays current with latest prompting research and techniques
- Balances performance optimization with ethical considerations
- Documents prompt behavior and provides clear usage guidelines
- Iterates systematically based on empirical performance data
- Considers model limitations and failure modes in prompt design
- Emphasizes reproducibility and version control for prompt systems

## Knowledge Base

- Latest research in prompt engineering and LLM optimization
- Model-specific capabilities and limitations across providers
- Production deployment patterns and best practices
- Safety and alignment considerations for AI systems
- Evaluation methodologies and performance benchmarking
- Cost optimization strategies for LLM applications
- Multi-agent and workflow orchestration patterns
- Multimodal AI and cross-modal reasoning techniques
- Industry-specific use cases and requirements
- Emerging trends in AI and prompt engineering

## Response Approach

1. **Understand the specific use case** and requirements for the prompt
2. **Analyze target model capabilities** and optimization opportunities
3. **Design prompt architecture** with appropriate techniques and patterns
4. **Display the complete prompt text** in a clearly marked section
5. **Provide usage guidelines** and parameter recommendations
6. **Include evaluation criteria** and testing approaches
7. **Document safety considerations** and potential failure modes
8. **Suggest optimization strategies** for performance and cost

## Required Output Format

When creating any prompt, you MUST include:

### The Prompt

```
[Display the complete prompt text here - this is the most important part]
```

### Implementation Notes

- Key techniques used and why they were chosen
- Model-specific optimizations and considerations
- Expected behavior and output format
- Parameter recommendations (temperature, max tokens, etc.)

### Testing & Evaluation

- Suggested test cases and evaluation metrics
- Edge cases and potential failure modes
- A/B testing recommendations for optimization

### Usage Guidelines

- When and how to use this prompt effectively
- Customization options and variable parameters
- Integration considerations for production systems

## Example Interactions

- "Create a constitutional AI prompt for content moderation that self-corrects problematic outputs"
- "Design a chain-of-thought prompt for financial analysis that shows clear reasoning steps"
- "Build a multi-agent prompt system for customer service with escalation workflows"
- "Optimize a RAG prompt for technical documentation that reduces hallucinations"
- "Create a meta-prompt that generates optimized prompts for specific business use cases"
- "Design a safety-focused prompt for creative writing that maintains engagement while avoiding harm"
- "Build a structured prompt for code review that provides actionable feedback"
- "Create an evaluation framework for comparing prompt performance across different models"

## Before Completing Any Task

Verify you have:
☐ Displayed the full prompt text (not just described it)
☐ Marked it clearly with headers or code blocks
☐ Provided usage instructions and implementation notes
☐ Explained your design choices and techniques used
☐ Included testing and evaluation recommendations
☐ Considered safety and ethical implications

Remember: The best prompt is one that consistently produces the desired output with minimal post-processing. ALWAYS show the prompt, never just describe it.

These guidelines provide practices for llm application dev.

## Embedding Strategies

# Embedding Strategies

Guide to selecting and optimizing embedding models for vector search applications.

## When to Use This Skill

- Choosing embedding models for RAG
- Optimizing chunking strategies
- Fine-tuning embeddings for domains
- Comparing embedding model performance
- Reducing embedding dimensions
- Handling multilingual content

## Core Concepts

### 1. Embedding Model Comparison (2026)

| Model                      | Dimensions | Max Tokens | Best For                            |
| -------------------------- | ---------- | ---------- | ----------------------------------- |
| **voyage-3-large**         | 1024       | 32000      | Claude apps (Anthropic recommended) |
| **voyage-3**               | 1024       | 32000      | Claude apps, cost-effective         |
| **voyage-code-3**          | 1024       | 32000      | Code search                         |
| **voyage-finance-2**       | 1024       | 32000      | Financial documents                 |
| **voyage-law-2**           | 1024       | 32000      | Legal documents                     |
| **text-embedding-3-large** | 3072       | 8191       | OpenAI apps, high accuracy          |
| **text-embedding-3-small** | 1536       | 8191       | OpenAI apps, cost-effective         |
| **bge-large-en-v1.5**      | 1024       | 512        | Open source, local deployment       |
| **all-MiniLM-L6-v2**       | 384        | 256        | Fast, lightweight                   |
| **multilingual-e5-large**  | 1024       | 512        | Multi-language                      |

### 2. Embedding Pipeline

```
Document → Chunking → Preprocessing → Embedding Model → Vector
                ↓
        [Overlap, Size]  [Clean, Normalize]  [API/Local]
```

## Templates

### Template 1: Voyage AI Embeddings (Recommended for Claude)

```python
from langchain_voyageai import VoyageAIEmbeddings
from typing import List
import os

# Initialize Voyage AI embeddings (recommended by Anthropic for Claude)
embeddings = VoyageAIEmbeddings(
    model="voyage-3-large",
    voyage_api_key=os.environ.get("VOYAGE_API_KEY")
)

def get_embeddings(texts: List[str]) -> List[List[float]]:
    """Get embeddings from Voyage AI."""
    return embeddings.embed_documents(texts)

def get_query_embedding(query: str) -> List[float]:
    """Get single query embedding."""
    return embeddings.embed_query(query)

# Specialized models for domains
code_embeddings = VoyageAIEmbeddings(model="voyage-code-3")
finance_embeddings = VoyageAIEmbeddings(model="voyage-finance-2")
legal_embeddings = VoyageAIEmbeddings(model="voyage-law-2")
```

### Template 2: OpenAI Embeddings

```python
from openai import OpenAI
from typing import List
import numpy as np

client = OpenAI()

def get_embeddings(
    texts: List[str],
    model: str = "text-embedding-3-small",
    dimensions: int = None
) -> List[List[float]]:
    """Get embeddings from OpenAI with optional dimension reduction."""
    # Handle batching for large lists
    batch_size = 100
    all_embeddings = []

    for i in range(0, len(texts), batch_size):
        batch = texts[i:i + batch_size]

        kwargs = {"input": batch, "model": model}
        if dimensions:
            # Matryoshka dimensionality reduction
            kwargs["dimensions"] = dimensions

        response = client.embeddings.create(**kwargs)
        embeddings = [item.embedding for item in response.data]
        all_embeddings.extend(embeddings)

    return all_embeddings


def get_embedding(text: str, **kwargs) -> List[float]:
    """Get single embedding."""
    return get_embeddings([text], **kwargs)[0]


# Dimension reduction with Matryoshka embeddings
def get_reduced_embedding(text: str, dimensions: int = 512) -> List[float]:
    """Get embedding with reduced dimensions (Matryoshka)."""
    return get_embedding(
        text,
        model="text-embedding-3-small",
        dimensions=dimensions
    )
```

### Template 3: Local Embeddings with Sentence Transformers

```python
from sentence_transformers import SentenceTransformer
from typing import List, Optional
import numpy as np

class LocalEmbedder:
    """Local embedding with sentence-transformers."""

    def __init__(
        self,
        model_name: str = "BAAI/bge-large-en-v1.5",
        device: str = "cuda"
    ):
        self.model = SentenceTransformer(model_name, device=device)
        self.model_name = model_name

    def embed(
        self,
        texts: List[str],
        normalize: bool = True,
        show_progress: bool = False
    ) -> np.ndarray:
        """Embed texts with optional normalization."""
        embeddings = self.model.encode(
            texts,
            normalize_embeddings=normalize,
            show_progress_bar=show_progress,
            convert_to_numpy=True
        )
        return embeddings

    def embed_query(self, query: str) -> np.ndarray:
        """Embed a query with appropriate prefix for retrieval models."""
        # BGE and similar models benefit from query prefix
        if "bge" in self.model_name.lower():
            query = f"Represent this sentence for searching relevant passages: {query}"
        return self.embed([query])[0]

    def embed_documents(self, documents: List[str]) -> np.ndarray:
        """Embed documents for indexing."""
        return self.embed(documents)


# E5 model with instructions
class E5Embedder:
    def __init__(self, model_name: str = "intfloat/multilingual-e5-large"):
        self.model = SentenceTransformer(model_name)

    def embed_query(self, query: str) -> np.ndarray:
        """E5 requires 'query:' prefix for queries."""
        return self.model.encode(f"query: {query}")

    def embed_document(self, document: str) -> np.ndarray:
        """E5 requires 'passage:' prefix for documents."""
        return self.model.encode(f"passage: {document}")
```

### Template 4: Chunking Strategies

```python
from typing import List, Tuple
import re

def chunk_by_tokens(
    text: str,
    chunk_size: int = 512,
    chunk_overlap: int = 50,
    tokenizer=None
) -> List[str]:
    """Chunk text by token count."""
    import tiktoken
    tokenizer = tokenizer or tiktoken.get_encoding("cl100k_base")

    tokens = tokenizer.encode(text)
    chunks = []

    start = 0
    while start < len(tokens):
        end = start + chunk_size
        chunk_tokens = tokens[start:end]
        chunk_text = tokenizer.decode(chunk_tokens)
        chunks.append(chunk_text)
        start = end - chunk_overlap

    return chunks


def chunk_by_sentences(
    text: str,
    max_chunk_size: int = 1000,
    min_chunk_size: int = 100
) -> List[str]:
    """Chunk text by sentences, respecting size limits."""
    import nltk
    sentences = nltk.sent_tokenize(text)

    chunks = []
    current_chunk = []
    current_size = 0

    for sentence in sentences:
        sentence_size = len(sentence)

        if current_size + sentence_size > max_chunk_size and current_chunk:
            chunks.append(" ".join(current_chunk))
            current_chunk = []
            current_size = 0

        current_chunk.append(sentence)
        current_size += sentence_size

    if current_chunk:
        chunks.append(" ".join(current_chunk))

    return chunks


def chunk_by_semantic_sections(
    text: str,
    headers_pattern: str = r'^#{1,3}\s+.+$'
) -> List[Tuple[str, str]]:
    """Chunk markdown by headers, preserving hierarchy."""
    lines = text.split('\n')
    chunks = []
    current_header = ""
    current_content = []

    for line in lines:
        if re.match(headers_pattern, line, re.MULTILINE):
            if current_content:
                chunks.append((current_header, '\n'.join(current_content)))
            current_header = line
            current_content = []
        else:
            current_content.append(line)

    if current_content:
        chunks.append((current_header, '\n'.join(current_content)))

    return chunks


def recursive_character_splitter(
    text: str,
    chunk_size: int = 1000,
    chunk_overlap: int = 200,
    separators: List[str] = None
) -> List[str]:
    """LangChain-style recursive splitter."""
    separators = separators or ["\n\n", "\n", ". ", " ", ""]

    def split_text(text: str, separators: List[str]) -> List[str]:
        if not text:
            return []

        separator = separators[0]
        remaining_separators = separators[1:]

        if separator == "":
            # Character-level split
            return [text[i:i+chunk_size] for i in range(0, len(text), chunk_size - chunk_overlap)]

        splits = text.split(separator)
        chunks = []
        current_chunk = []
        current_length = 0

        for split in splits:
            split_length = len(split) + len(separator)

            if current_length + split_length > chunk_size and current_chunk:
                chunk_text = separator.join(current_chunk)

                # Recursively split if still too large
                if len(chunk_text) > chunk_size and remaining_separators:
                    chunks.extend(split_text(chunk_text, remaining_separators))
                else:
                    chunks.append(chunk_text)

                # Start new chunk with overlap
                overlap_splits = []
                overlap_length = 0
                for s in reversed(current_chunk):
                    if overlap_length + len(s) <= chunk_overlap:
                        overlap_splits.insert(0, s)
                        overlap_length += len(s)
                    else:
                        break
                current_chunk = overlap_splits
                current_length = overlap_length

            current_chunk.append(split)
            current_length += split_length

        if current_chunk:
            chunks.append(separator.join(current_chunk))

        return chunks

    return split_text(text, separators)
```

### Template 5: Domain-Specific Embedding Pipeline

```python
import re
from typing import List, Optional
from dataclasses import dataclass

@dataclass
class EmbeddedDocument:
    id: str
    document_id: str
    chunk_index: int
    text: str
    embedding: List[float]
    metadata: dict

class DomainEmbeddingPipeline:
    """Pipeline for domain-specific embeddings."""

    def __init__(
        self,
        embedding_model: str = "voyage-3-large",
        chunk_size: int = 512,
        chunk_overlap: int = 50,
        preprocessing_fn=None
    ):
        self.embeddings = VoyageAIEmbeddings(model=embedding_model)
        self.chunk_size = chunk_size
        self.chunk_overlap = chunk_overlap
        self.preprocess = preprocessing_fn or self._default_preprocess

    def _default_preprocess(self, text: str) -> str:
        """Default preprocessing."""
        # Remove excessive whitespace
        text = re.sub(r'\s+', ' ', text)
        # Remove special characters (customize for your domain)
        text = re.sub(r'[^\w\s.,!?-]', '', text)
        return text.strip()

    async def process_documents(
        self,
        documents: List[dict],
        id_field: str = "id",
        content_field: str = "content",
        metadata_fields: Optional[List[str]] = None
    ) -> List[EmbeddedDocument]:
        """Process documents for vector storage."""
        processed = []

        for doc in documents:
            content = doc[content_field]
            doc_id = doc[id_field]

            # Preprocess
            cleaned = self.preprocess(content)

            # Chunk
            chunks = chunk_by_tokens(
                cleaned,
                self.chunk_size,
                self.chunk_overlap
            )

            # Create embeddings
            embeddings = await self.embeddings.aembed_documents(chunks)

            # Create records
            for i, (chunk, embedding) in enumerate(zip(chunks, embeddings)):
                metadata = {"document_id": doc_id, "chunk_index": i}

                # Add specified metadata fields
                if metadata_fields:
                    for field in metadata_fields:
                        if field in doc:
                            metadata[field] = doc[field]

                processed.append(EmbeddedDocument(
                    id=f"{doc_id}_chunk_{i}",
                    document_id=doc_id,
                    chunk_index=i,
                    text=chunk,
                    embedding=embedding,
                    metadata=metadata
                ))

        return processed


# Code-specific pipeline
class CodeEmbeddingPipeline:
    """Specialized pipeline for code embeddings."""

    def __init__(self):
        # Use Voyage's code-specific model
        self.embeddings = VoyageAIEmbeddings(model="voyage-code-3")

    def chunk_code(self, code: str, language: str) -> List[dict]:
        """Chunk code by functions/classes using tree-sitter."""
        try:
            import tree_sitter_languages
            parser = tree_sitter_languages.get_parser(language)
            tree = parser.parse(bytes(code, "utf8"))

            chunks = []
            # Extract function and class definitions
            self._extract_nodes(tree.root_node, code, chunks)
            return chunks
        except ImportError:
            # Fallback to simple chunking
            return [{"text": code, "type": "module"}]

    def _extract_nodes(self, node, source_code: str, chunks: list):
        """Recursively extract function/class definitions."""
        if node.type in ['function_definition', 'class_definition', 'method_definition']:
            text = source_code[node.start_byte:node.end_byte]
            chunks.append({
                "text": text,
                "type": node.type,
                "name": self._get_name(node),
                "start_line": node.start_point[0],
                "end_line": node.end_point[0]
            })
        for child in node.children:
            self._extract_nodes(child, source_code, chunks)

    def _get_name(self, node) -> str:
        """Extract name from function/class node."""
        for child in node.children:
            if child.type == 'identifier' or child.type == 'name':
                return child.text.decode('utf8')
        return "unknown"

    async def embed_with_context(
        self,
        chunk: str,
        context: str = ""
    ) -> List[float]:
        """Embed code with surrounding context."""
        if context:
            combined = f"Context: {context}\n\nCode:\n{chunk}"
        else:
            combined = chunk
        return await self.embeddings.aembed_query(combined)
```

### Template 6: Embedding Quality Evaluation

```python
import numpy as np
from typing import List, Dict

def evaluate_retrieval_quality(
    queries: List[str],
    relevant_docs: List[List[str]],  # List of relevant doc IDs per query
    retrieved_docs: List[List[str]],  # List of retrieved doc IDs per query
    k: int = 10
) -> Dict[str, float]:
    """Evaluate embedding quality for retrieval."""

    def precision_at_k(relevant: set, retrieved: List[str], k: int) -> float:
        retrieved_k = retrieved[:k]
        relevant_retrieved = len(set(retrieved_k) & relevant)
        return relevant_retrieved / k if k > 0 else 0

    def recall_at_k(relevant: set, retrieved: List[str], k: int) -> float:
        retrieved_k = retrieved[:k]
        relevant_retrieved = len(set(retrieved_k) & relevant)
        return relevant_retrieved / len(relevant) if relevant else 0

    def mrr(relevant: set, retrieved: List[str]) -> float:
        for i, doc in enumerate(retrieved):
            if doc in relevant:
                return 1 / (i + 1)
        return 0

    def ndcg_at_k(relevant: set, retrieved: List[str], k: int) -> float:
        dcg = sum(
            1 / np.log2(i + 2) if doc in relevant else 0
            for i, doc in enumerate(retrieved[:k])
        )
        ideal_dcg = sum(1 / np.log2(i + 2) for i in range(min(len(relevant), k)))
        return dcg / ideal_dcg if ideal_dcg > 0 else 0

    metrics = {
        f"precision@{k}": [],
        f"recall@{k}": [],
        "mrr": [],
        f"ndcg@{k}": []
    }

    for relevant, retrieved in zip(relevant_docs, retrieved_docs):
        relevant_set = set(relevant)
        metrics[f"precision@{k}"].append(precision_at_k(relevant_set, retrieved, k))
        metrics[f"recall@{k}"].append(recall_at_k(relevant_set, retrieved, k))
        metrics["mrr"].append(mrr(relevant_set, retrieved))
        metrics[f"ndcg@{k}"].append(ndcg_at_k(relevant_set, retrieved, k))

    return {name: np.mean(values) for name, values in metrics.items()}


def compute_embedding_similarity(
    embeddings1: np.ndarray,
    embeddings2: np.ndarray,
    metric: str = "cosine"
) -> np.ndarray:
    """Compute similarity matrix between embedding sets."""
    if metric == "cosine":
        # Normalize and compute dot product
        norm1 = embeddings1 / np.linalg.norm(embeddings1, axis=1, keepdims=True)
        norm2 = embeddings2 / np.linalg.norm(embeddings2, axis=1, keepdims=True)
        return norm1 @ norm2.T
    elif metric == "euclidean":
        from scipy.spatial.distance import cdist
        return -cdist(embeddings1, embeddings2, metric='euclidean')
    elif metric == "dot":
        return embeddings1 @ embeddings2.T
    else:
        raise ValueError(f"Unknown metric: {metric}")


def compare_embedding_models(
    texts: List[str],
    models: Dict[str, callable],
    queries: List[str],
    relevant_indices: List[List[int]],
    k: int = 5
) -> Dict[str, Dict[str, float]]:
    """Compare multiple embedding models on retrieval quality."""
    results = {}

    for model_name, embed_fn in models.items():
        # Embed all texts
        doc_embeddings = np.array(embed_fn(texts))

        retrieved_per_query = []
        for query in queries:
            query_embedding = np.array(embed_fn([query])[0])
            # Compute similarities
            similarities = compute_embedding_similarity(
                query_embedding.reshape(1, -1),
                doc_embeddings,
                metric="cosine"
            )[0]
            # Get top-k indices
            top_k_indices = np.argsort(similarities)[::-1][:k]
            retrieved_per_query.append([str(i) for i in top_k_indices])

        # Convert relevant indices to string IDs
        relevant_docs = [[str(i) for i in indices] for indices in relevant_indices]

        results[model_name] = evaluate_retrieval_quality(
            queries, relevant_docs, retrieved_per_query, k
        )

    return results
```

## Best Practices

### Do's

- **Match model to use case**: Code vs prose vs multilingual
- **Chunk thoughtfully**: Preserve semantic boundaries
- **Normalize embeddings**: For cosine similarity search
- **Batch requests**: More efficient than one-by-one
- **Cache embeddings**: Avoid recomputing for static content
- **Use Voyage AI for Claude apps**: Recommended by Anthropic

### Don'ts

- **Don't ignore token limits**: Truncation loses information
- **Don't mix embedding models**: Incompatible vector spaces
- **Don't skip preprocessing**: Garbage in, garbage out
- **Don't over-chunk**: Lose important context
- **Don't forget metadata**: Essential for filtering and debugging

## Resources

- [Voyage AI Documentation](https://docs.voyageai.com/)
- [OpenAI Embeddings Guide](https://platform.openai.com/docs/guides/embeddings)
- [Sentence Transformers](https://www.sbert.net/)
- [MTEB Benchmark](https://huggingface.co/spaces/mteb/leaderboard)
- [LangChain Embedding Models](https://python.langchain.com/docs/integrations/text_embedding/)

## Hybrid Search Implementation

# Hybrid Search Implementation

Patterns for combining vector similarity and keyword-based search.

## When to Use This Skill

- Building RAG systems with improved recall
- Combining semantic understanding with exact matching
- Handling queries with specific terms (names, codes)
- Improving search for domain-specific vocabulary
- When pure vector search misses keyword matches

## Core Concepts

### 1. Hybrid Search Architecture

```
Query → ┬─► Vector Search ──► Candidates ─┐
        │                                  │
        └─► Keyword Search ─► Candidates ─┴─► Fusion ─► Results
```

### 2. Fusion Methods

| Method            | Description              | Best For        |
| ----------------- | ------------------------ | --------------- |
| **RRF**           | Reciprocal Rank Fusion   | General purpose |
| **Linear**        | Weighted sum of scores   | Tunable balance |
| **Cross-encoder** | Rerank with neural model | Highest quality |
| **Cascade**       | Filter then rerank       | Efficiency      |

## Templates

### Template 1: Reciprocal Rank Fusion

```python
from typing import List, Dict, Tuple
from collections import defaultdict

def reciprocal_rank_fusion(
    result_lists: List[List[Tuple[str, float]]],
    k: int = 60,
    weights: List[float] = None
) -> List[Tuple[str, float]]:
    """
    Combine multiple ranked lists using RRF.

    Args:
        result_lists: List of (doc_id, score) tuples per search method
        k: RRF constant (higher = more weight to lower ranks)
        weights: Optional weights per result list

    Returns:
        Fused ranking as (doc_id, score) tuples
    """
    if weights is None:
        weights = [1.0] * len(result_lists)

    scores = defaultdict(float)

    for result_list, weight in zip(result_lists, weights):
        for rank, (doc_id, _) in enumerate(result_list):
            # RRF formula: 1 / (k + rank)
            scores[doc_id] += weight * (1.0 / (k + rank + 1))

    # Sort by fused score
    return sorted(scores.items(), key=lambda x: x[1], reverse=True)


def linear_combination(
    vector_results: List[Tuple[str, float]],
    keyword_results: List[Tuple[str, float]],
    alpha: float = 0.5
) -> List[Tuple[str, float]]:
    """
    Combine results with linear interpolation.

    Args:
        vector_results: (doc_id, similarity_score) from vector search
        keyword_results: (doc_id, bm25_score) from keyword search
        alpha: Weight for vector search (1-alpha for keyword)
    """
    # Normalize scores to [0, 1]
    def normalize(results):
        if not results:
            return {}
        scores = [s for _, s in results]
        min_s, max_s = min(scores), max(scores)
        range_s = max_s - min_s if max_s != min_s else 1
        return {doc_id: (score - min_s) / range_s for doc_id, score in results}

    vector_scores = normalize(vector_results)
    keyword_scores = normalize(keyword_results)

    # Combine
    all_docs = set(vector_scores.keys()) | set(keyword_scores.keys())
    combined = {}

    for doc_id in all_docs:
        v_score = vector_scores.get(doc_id, 0)
        k_score = keyword_scores.get(doc_id, 0)
        combined[doc_id] = alpha * v_score + (1 - alpha) * k_score

    return sorted(combined.items(), key=lambda x: x[1], reverse=True)
```

### Template 2: PostgreSQL Hybrid Search

```python
import asyncpg
from typing import List, Dict, Optional
import numpy as np

class PostgresHybridSearch:
    """Hybrid search with pgvector and full-text search."""

    def __init__(self, pool: asyncpg.Pool):
        self.pool = pool

    async def setup_schema(self):
        """Create tables and indexes."""
        async with self.pool.acquire() as conn:
            await conn.execute("""
                CREATE EXTENSION IF NOT EXISTS vector;

                CREATE TABLE IF NOT EXISTS documents (
                    id TEXT PRIMARY KEY,
                    content TEXT NOT NULL,
                    embedding vector(1536),
                    metadata JSONB DEFAULT '{}',
                    ts_content tsvector GENERATED ALWAYS AS (
                        to_tsvector('english', content)
                    ) STORED
                );

                -- Vector index (HNSW)
                CREATE INDEX IF NOT EXISTS documents_embedding_idx
                ON documents USING hnsw (embedding vector_cosine_ops);

                -- Full-text index (GIN)
                CREATE INDEX IF NOT EXISTS documents_fts_idx
                ON documents USING gin (ts_content);
            """)

    async def hybrid_search(
        self,
        query: str,
        query_embedding: List[float],
        limit: int = 10,
        vector_weight: float = 0.5,
        filter_metadata: Optional[Dict] = None
    ) -> List[Dict]:
        """
        Perform hybrid search combining vector and full-text.

        Uses RRF fusion for combining results.
        """
        async with self.pool.acquire() as conn:
            # Build filter clause
            where_clause = "1=1"
            params = [query_embedding, query, limit * 3]

            if filter_metadata:
                for key, value in filter_metadata.items():
                    params.append(value)
                    where_clause += f" AND metadata->>'{key}' = ${len(params)}"

            results = await conn.fetch(f"""
                WITH vector_search AS (
                    SELECT
                        id,
                        content,
                        metadata,
                        ROW_NUMBER() OVER (ORDER BY embedding <=> $1::vector) as vector_rank,
                        1 - (embedding <=> $1::vector) as vector_score
                    FROM documents
                    WHERE {where_clause}
                    ORDER BY embedding <=> $1::vector
                    LIMIT $3
                ),
                keyword_search AS (
                    SELECT
                        id,
                        content,
                        metadata,
                        ROW_NUMBER() OVER (ORDER BY ts_rank(ts_content, websearch_to_tsquery('english', $2)) DESC) as keyword_rank,
                        ts_rank(ts_content, websearch_to_tsquery('english', $2)) as keyword_score
                    FROM documents
                    WHERE ts_content @@ websearch_to_tsquery('english', $2)
                      AND {where_clause}
                    ORDER BY ts_rank(ts_content, websearch_to_tsquery('english', $2)) DESC
                    LIMIT $3
                )
                SELECT
                    COALESCE(v.id, k.id) as id,
                    COALESCE(v.content, k.content) as content,
                    COALESCE(v.metadata, k.metadata) as metadata,
                    v.vector_score,
                    k.keyword_score,
                    -- RRF fusion
                    COALESCE(1.0 / (60 + v.vector_rank), 0) * $4::float +
                    COALESCE(1.0 / (60 + k.keyword_rank), 0) * (1 - $4::float) as rrf_score
                FROM vector_search v
                FULL OUTER JOIN keyword_search k ON v.id = k.id
                ORDER BY rrf_score DESC
                LIMIT $3 / 3
            """, *params, vector_weight)

            return [dict(row) for row in results]

    async def search_with_rerank(
        self,
        query: str,
        query_embedding: List[float],
        limit: int = 10,
        rerank_candidates: int = 50
    ) -> List[Dict]:
        """Hybrid search with cross-encoder reranking."""
        from sentence_transformers import CrossEncoder

        # Get candidates
        candidates = await self.hybrid_search(
            query, query_embedding, limit=rerank_candidates
        )

        if not candidates:
            return []

        # Rerank with cross-encoder
        model = CrossEncoder('cross-encoder/ms-marco-MiniLM-L-6-v2')

        pairs = [(query, c["content"]) for c in candidates]
        scores = model.predict(pairs)

        for candidate, score in zip(candidates, scores):
            candidate["rerank_score"] = float(score)

        # Sort by rerank score and return top results
        reranked = sorted(candidates, key=lambda x: x["rerank_score"], reverse=True)
        return reranked[:limit]
```

### Template 3: Elasticsearch Hybrid Search

```python
from elasticsearch import Elasticsearch
from typing import List, Dict, Optional

class ElasticsearchHybridSearch:
    """Hybrid search with Elasticsearch and dense vectors."""

    def __init__(
        self,
        es_client: Elasticsearch,
        index_name: str = "documents"
    ):
        self.es = es_client
        self.index_name = index_name

    def create_index(self, vector_dims: int = 1536):
        """Create index with dense vector and text fields."""
        mapping = {
            "mappings": {
                "properties": {
                    "content": {
                        "type": "text",
                        "analyzer": "english"
                    },
                    "embedding": {
                        "type": "dense_vector",
                        "dims": vector_dims,
                        "index": True,
                        "similarity": "cosine"
                    },
                    "metadata": {
                        "type": "object",
                        "enabled": True
                    }
                }
            }
        }
        self.es.indices.create(index=self.index_name, body=mapping, ignore=400)

    def hybrid_search(
        self,
        query: str,
        query_embedding: List[float],
        limit: int = 10,
        boost_vector: float = 1.0,
        boost_text: float = 1.0,
        filter: Optional[Dict] = None
    ) -> List[Dict]:
        """
        Hybrid search using Elasticsearch's built-in capabilities.
        """
        # Build the hybrid query
        search_body = {
            "size": limit,
            "query": {
                "bool": {
                    "should": [
                        # Vector search (kNN)
                        {
                            "script_score": {
                                "query": {"match_all": {}},
                                "script": {
                                    "source": f"cosineSimilarity(params.query_vector, 'embedding') * {boost_vector} + 1.0",
                                    "params": {"query_vector": query_embedding}
                                }
                            }
                        },
                        # Text search (BM25)
                        {
                            "match": {
                                "content": {
                                    "query": query,
                                    "boost": boost_text
                                }
                            }
                        }
                    ],
                    "minimum_should_match": 1
                }
            }
        }

        # Add filter if provided
        if filter:
            search_body["query"]["bool"]["filter"] = filter

        response = self.es.search(index=self.index_name, body=search_body)

        return [
            {
                "id": hit["_id"],
                "content": hit["_source"]["content"],
                "metadata": hit["_source"].get("metadata", {}),
                "score": hit["_score"]
            }
            for hit in response["hits"]["hits"]
        ]

    def hybrid_search_rrf(
        self,
        query: str,
        query_embedding: List[float],
        limit: int = 10,
        window_size: int = 100
    ) -> List[Dict]:
        """
        Hybrid search using Elasticsearch 8.x RRF.
        """
        search_body = {
            "size": limit,
            "sub_searches": [
                {
                    "query": {
                        "match": {
                            "content": query
                        }
                    }
                },
                {
                    "query": {
                        "knn": {
                            "field": "embedding",
                            "query_vector": query_embedding,
                            "k": window_size,
                            "num_candidates": window_size * 2
                        }
                    }
                }
            ],
            "rank": {
                "rrf": {
                    "window_size": window_size,
                    "rank_constant": 60
                }
            }
        }

        response = self.es.search(index=self.index_name, body=search_body)

        return [
            {
                "id": hit["_id"],
                "content": hit["_source"]["content"],
                "score": hit["_score"]
            }
            for hit in response["hits"]["hits"]
        ]
```

### Template 4: Custom Hybrid RAG Pipeline

```python
from typing import List, Dict, Optional, Callable
from dataclasses import dataclass

@dataclass
class SearchResult:
    id: str
    content: str
    score: float
    source: str  # "vector", "keyword", "hybrid"
    metadata: Dict = None


class HybridRAGPipeline:
    """Complete hybrid search pipeline for RAG."""

    def __init__(
        self,
        vector_store,
        keyword_store,
        embedder,
        reranker=None,
        fusion_method: str = "rrf",
        vector_weight: float = 0.5
    ):
        self.vector_store = vector_store
        self.keyword_store = keyword_store
        self.embedder = embedder
        self.reranker = reranker
        self.fusion_method = fusion_method
        self.vector_weight = vector_weight

    async def search(
        self,
        query: str,
        top_k: int = 10,
        filter: Optional[Dict] = None,
        use_rerank: bool = True
    ) -> List[SearchResult]:
        """Execute hybrid search pipeline."""

        # Step 1: Get query embedding
        query_embedding = self.embedder.embed(query)

        # Step 2: Execute parallel searches
        vector_results, keyword_results = await asyncio.gather(
            self._vector_search(query_embedding, top_k * 3, filter),
            self._keyword_search(query, top_k * 3, filter)
        )

        # Step 3: Fuse results
        if self.fusion_method == "rrf":
            fused = self._rrf_fusion(vector_results, keyword_results)
        else:
            fused = self._linear_fusion(vector_results, keyword_results)

        # Step 4: Rerank if enabled
        if use_rerank and self.reranker:
            fused = await self._rerank(query, fused[:top_k * 2])

        return fused[:top_k]

    async def _vector_search(
        self,
        embedding: List[float],
        limit: int,
        filter: Dict
    ) -> List[SearchResult]:
        results = await self.vector_store.search(embedding, limit, filter)
        return [
            SearchResult(
                id=r["id"],
                content=r["content"],
                score=r["score"],
                source="vector",
                metadata=r.get("metadata")
            )
            for r in results
        ]

    async def _keyword_search(
        self,
        query: str,
        limit: int,
        filter: Dict
    ) -> List[SearchResult]:
        results = await self.keyword_store.search(query, limit, filter)
        return [
            SearchResult(
                id=r["id"],
                content=r["content"],
                score=r["score"],
                source="keyword",
                metadata=r.get("metadata")
            )
            for r in results
        ]

    def _rrf_fusion(
        self,
        vector_results: List[SearchResult],
        keyword_results: List[SearchResult]
    ) -> List[SearchResult]:
        """Fuse with RRF."""
        k = 60
        scores = {}
        content_map = {}

        for rank, result in enumerate(vector_results):
            scores[result.id] = scores.get(result.id, 0) + 1 / (k + rank + 1)
            content_map[result.id] = result

        for rank, result in enumerate(keyword_results):
            scores[result.id] = scores.get(result.id, 0) + 1 / (k + rank + 1)
            if result.id not in content_map:
                content_map[result.id] = result

        sorted_ids = sorted(scores.keys(), key=lambda x: scores[x], reverse=True)

        return [
            SearchResult(
                id=doc_id,
                content=content_map[doc_id].content,
                score=scores[doc_id],
                source="hybrid",
                metadata=content_map[doc_id].metadata
            )
            for doc_id in sorted_ids
        ]

    async def _rerank(
        self,
        query: str,
        results: List[SearchResult]
    ) -> List[SearchResult]:
        """Rerank with cross-encoder."""
        if not results:
            return results

        pairs = [(query, r.content) for r in results]
        scores = self.reranker.predict(pairs)

        for result, score in zip(results, scores):
            result.score = float(score)

        return sorted(results, key=lambda x: x.score, reverse=True)
```

## Best Practices

### Do's

- **Tune weights empirically** - Test on your data
- **Use RRF for simplicity** - Works well without tuning
- **Add reranking** - Significant quality improvement
- **Log both scores** - Helps with debugging
- **A/B test** - Measure real user impact

### Don'ts

- **Don't assume one size fits all** - Different queries need different weights
- **Don't skip keyword search** - Handles exact matches better
- **Don't over-fetch** - Balance recall vs latency
- **Don't ignore edge cases** - Empty results, single word queries

## Resources

- [RRF Paper](https://plg.uwaterloo.ca/~gvcormac/cormacksigir09-rrf.pdf)
- [Vespa Hybrid Search](https://blog.vespa.ai/improving-text-ranking-with-few-shot-prompting/)
- [Cohere Rerank](https://docs.cohere.com/docs/reranking)

## Langchain Architecture

# LangChain & LangGraph Architecture

Master modern LangChain 1.x and LangGraph for building sophisticated LLM applications with agents, state management, memory, and tool integration.

## When to Use This Skill

- Building autonomous AI agents with tool access
- Implementing complex multi-step LLM workflows
- Managing conversation memory and state
- Integrating LLMs with external data sources and APIs
- Creating modular, reusable LLM application components
- Implementing document processing pipelines
- Building production-grade LLM applications

## Package Structure (LangChain 1.x)

```
langchain (1.2.x)         # High-level orchestration
langchain-core (1.2.x)    # Core abstractions (messages, prompts, tools)
langchain-community       # Third-party integrations
langgraph                 # Agent orchestration and state management
langchain-openai          # OpenAI integrations
langchain-anthropic       # Anthropic/Claude integrations
langchain-voyageai        # Voyage AI embeddings
langchain-pinecone        # Pinecone vector store
```

## Core Concepts

### 1. LangGraph Agents

LangGraph is the standard for building agents in 2026. It provides:

**Key Features:**

- **StateGraph**: Explicit state management with typed state
- **Durable Execution**: Agents persist through failures
- **Human-in-the-Loop**: Inspect and modify state at any point
- **Memory**: Short-term and long-term memory across sessions
- **Checkpointing**: Save and resume agent state

**Agent Patterns:**

- **ReAct**: Reasoning + Acting with `create_react_agent`
- **Plan-and-Execute**: Separate planning and execution nodes
- **Multi-Agent**: Supervisor routing between specialized agents
- **Tool-Calling**: Structured tool invocation with Pydantic schemas

### 2. State Management

LangGraph uses TypedDict for explicit state:

```python
from typing import Annotated, TypedDict
from langgraph.graph import MessagesState

# Simple message-based state
class AgentState(MessagesState):
    """Extends MessagesState with custom fields."""
    context: Annotated[list, "retrieved documents"]

# Custom state for complex agents
class CustomState(TypedDict):
    messages: Annotated[list, "conversation history"]
    context: Annotated[dict, "retrieved context"]
    current_step: str
    results: list
```

### 3. Memory Systems

Modern memory implementations:

- **ConversationBufferMemory**: Stores all messages (short conversations)
- **ConversationSummaryMemory**: Summarizes older messages (long conversations)
- **ConversationTokenBufferMemory**: Token-based windowing
- **VectorStoreRetrieverMemory**: Semantic similarity retrieval
- **LangGraph Checkpointers**: Persistent state across sessions

### 4. Document Processing

Loading, transforming, and storing documents:

**Components:**

- **Document Loaders**: Load from various sources
- **Text Splitters**: Chunk documents intelligently
- **Vector Stores**: Store and retrieve embeddings
- **Retrievers**: Fetch relevant documents

### 5. Callbacks & Tracing

LangSmith is the standard for observability:

- Request/response logging
- Token usage tracking
- Latency monitoring
- Error tracking
- Trace visualization

## Quick Start

### Modern ReAct Agent with LangGraph

```python
from langgraph.prebuilt import create_react_agent
from langgraph.checkpoint.memory import MemorySaver
from langchain_anthropic import ChatAnthropic
from langchain_core.tools import tool
import ast
import operator

# Initialize LLM (Claude Sonnet 4.5 recommended)
llm = ChatAnthropic(model="claude-sonnet-4-5", temperature=0)

# Define tools with Pydantic schemas
@tool
def search_database(query: str) -> str:
    """Search internal database for information."""
    # Your database search logic
    return f"Results for: {query}"

@tool
def calculate(expression: str) -> str:
    """Safely evaluate a mathematical expression.

    Supports: +, -, *, /, **, %, parentheses
    Example: '(2 + 3) * 4' returns '20'
    """
    # Safe math evaluation using ast
    allowed_operators = {
        ast.Add: operator.add,
        ast.Sub: operator.sub,
        ast.Mult: operator.mul,
        ast.Div: operator.truediv,
        ast.Pow: operator.pow,
        ast.Mod: operator.mod,
        ast.USub: operator.neg,
    }

    def _eval(node):
        if isinstance(node, ast.Constant):
            return node.value
        elif isinstance(node, ast.BinOp):
            left = _eval(node.left)
            right = _eval(node.right)
            return allowed_operators[type(node.op)](left, right)
        elif isinstance(node, ast.UnaryOp):
            operand = _eval(node.operand)
            return allowed_operators[type(node.op)](operand)
        else:
            raise ValueError(f"Unsupported operation: {type(node)}")

    try:
        tree = ast.parse(expression, mode='eval')
        return str(_eval(tree.body))
    except Exception as e:
        return f"Error: {e}"

tools = [search_database, calculate]

# Create checkpointer for memory persistence
checkpointer = MemorySaver()

# Create ReAct agent
agent = create_react_agent(
    llm,
    tools,
    checkpointer=checkpointer
)

# Run agent with thread ID for memory
config = {"configurable": {"thread_id": "user-123"}}
result = await agent.ainvoke(
    {"messages": [("user", "Search for Python tutorials and calculate 25 * 4")]},
    config=config
)
```

## Architecture Patterns

### Pattern 1: RAG with LangGraph

```python
from langgraph.graph import StateGraph, START, END
from langchain_anthropic import ChatAnthropic
from langchain_voyageai import VoyageAIEmbeddings
from langchain_pinecone import PineconeVectorStore
from langchain_core.documents import Document
from langchain_core.prompts import ChatPromptTemplate
from typing import TypedDict, Annotated

class RAGState(TypedDict):
    question: str
    context: Annotated[list[Document], "retrieved documents"]
    answer: str

# Initialize components
llm = ChatAnthropic(model="claude-sonnet-4-5")
embeddings = VoyageAIEmbeddings(model="voyage-3-large")
vectorstore = PineconeVectorStore(index_name="docs", embedding=embeddings)
retriever = vectorstore.as_retriever(search_kwargs={"k": 4})

# Define nodes
async def retrieve(state: RAGState) -> RAGState:
    """Retrieve relevant documents."""
    docs = await retriever.ainvoke(state["question"])
    return {"context": docs}

async def generate(state: RAGState) -> RAGState:
    """Generate answer from context."""
    prompt = ChatPromptTemplate.from_template(
        """Answer based on the context below. If you cannot answer, say so.

        Context: {context}

        Question: {question}

        Answer:"""
    )
    context_text = "\n\n".join(doc.page_content for doc in state["context"])
    response = await llm.ainvoke(
        prompt.format(context=context_text, question=state["question"])
    )
    return {"answer": response.content}

# Build graph
builder = StateGraph(RAGState)
builder.add_node("retrieve", retrieve)
builder.add_node("generate", generate)
builder.add_edge(START, "retrieve")
builder.add_edge("retrieve", "generate")
builder.add_edge("generate", END)

rag_chain = builder.compile()

# Use the chain
result = await rag_chain.ainvoke({"question": "What is the main topic?"})
```

### Pattern 2: Custom Agent with Structured Tools

```python
from langchain_core.tools import StructuredTool
from pydantic import BaseModel, Field

class SearchInput(BaseModel):
    """Input for database search."""
    query: str = Field(description="Search query")
    filters: dict = Field(default={}, description="Optional filters")

class EmailInput(BaseModel):
    """Input for sending email."""
    recipient: str = Field(description="Email recipient")
    subject: str = Field(description="Email subject")
    content: str = Field(description="Email body")

async def search_database(query: str, filters: dict = {}) -> str:
    """Search internal database for information."""
    # Your database search logic
    return f"Results for '{query}' with filters {filters}"

async def send_email(recipient: str, subject: str, content: str) -> str:
    """Send an email to specified recipient."""
    # Email sending logic
    return f"Email sent to {recipient}"

tools = [
    StructuredTool.from_function(
        coroutine=search_database,
        name="search_database",
        description="Search internal database",
        args_schema=SearchInput
    ),
    StructuredTool.from_function(
        coroutine=send_email,
        name="send_email",
        description="Send an email",
        args_schema=EmailInput
    )
]

agent = create_react_agent(llm, tools)
```

### Pattern 3: Multi-Step Workflow with StateGraph

```python
from langgraph.graph import StateGraph, START, END
from typing import TypedDict, Literal

class WorkflowState(TypedDict):
    text: str
    entities: list
    analysis: str
    summary: str
    current_step: str

async def extract_entities(state: WorkflowState) -> WorkflowState:
    """Extract key entities from text."""
    prompt = f"Extract key entities from: {state['text']}\n\nReturn as JSON list."
    response = await llm.ainvoke(prompt)
    return {"entities": response.content, "current_step": "analyze"}

async def analyze_entities(state: WorkflowState) -> WorkflowState:
    """Analyze extracted entities."""
    prompt = f"Analyze these entities: {state['entities']}\n\nProvide insights."
    response = await llm.ainvoke(prompt)
    return {"analysis": response.content, "current_step": "summarize"}

async def generate_summary(state: WorkflowState) -> WorkflowState:
    """Generate final summary."""
    prompt = f"""Summarize:
    Entities: {state['entities']}
    Analysis: {state['analysis']}

    Provide a concise summary."""
    response = await llm.ainvoke(prompt)
    return {"summary": response.content, "current_step": "complete"}

def route_step(state: WorkflowState) -> Literal["analyze", "summarize", "end"]:
    """Route to next step based on current state."""
    step = state.get("current_step", "extract")
    if step == "analyze":
        return "analyze"
    elif step == "summarize":
        return "summarize"
    return "end"

# Build workflow
builder = StateGraph(WorkflowState)
builder.add_node("extract", extract_entities)
builder.add_node("analyze", analyze_entities)
builder.add_node("summarize", generate_summary)

builder.add_edge(START, "extract")
builder.add_conditional_edges("extract", route_step, {
    "analyze": "analyze",
    "summarize": "summarize",
    "end": END
})
builder.add_conditional_edges("analyze", route_step, {
    "summarize": "summarize",
    "end": END
})
builder.add_edge("summarize", END)

workflow = builder.compile()
```

### Pattern 4: Multi-Agent Orchestration

```python
from langgraph.graph import StateGraph, START, END
from langgraph.prebuilt import create_react_agent
from langchain_core.messages import HumanMessage
from typing import Literal

class MultiAgentState(TypedDict):
    messages: list
    next_agent: str

# Create specialized agents
researcher = create_react_agent(llm, research_tools)
writer = create_react_agent(llm, writing_tools)
reviewer = create_react_agent(llm, review_tools)

async def supervisor(state: MultiAgentState) -> MultiAgentState:
    """Route to appropriate agent based on task."""
    prompt = f"""Based on the conversation, which agent should handle this?

    Options:
    - researcher: For finding information
    - writer: For creating content
    - reviewer: For reviewing and editing
    - FINISH: Task is complete

    Messages: {state['messages']}

    Respond with just the agent name."""

    response = await llm.ainvoke(prompt)
    return {"next_agent": response.content.strip().lower()}

def route_to_agent(state: MultiAgentState) -> Literal["researcher", "writer", "reviewer", "end"]:
    """Route based on supervisor decision."""
    next_agent = state.get("next_agent", "").lower()
    if next_agent == "finish":
        return "end"
    return next_agent if next_agent in ["researcher", "writer", "reviewer"] else "end"

# Build multi-agent graph
builder = StateGraph(MultiAgentState)
builder.add_node("supervisor", supervisor)
builder.add_node("researcher", researcher)
builder.add_node("writer", writer)
builder.add_node("reviewer", reviewer)

builder.add_edge(START, "supervisor")
builder.add_conditional_edges("supervisor", route_to_agent, {
    "researcher": "researcher",
    "writer": "writer",
    "reviewer": "reviewer",
    "end": END
})

# Each agent returns to supervisor
for agent in ["researcher", "writer", "reviewer"]:
    builder.add_edge(agent, "supervisor")

multi_agent = builder.compile()
```

## Memory Management

### Token-Based Memory with LangGraph

```python
from langgraph.checkpoint.memory import MemorySaver
from langgraph.prebuilt import create_react_agent

# In-memory checkpointer (development)
checkpointer = MemorySaver()

# Create agent with persistent memory
agent = create_react_agent(llm, tools, checkpointer=checkpointer)

# Each thread_id maintains separate conversation
config = {"configurable": {"thread_id": "session-abc123"}}

# Messages persist across invocations with same thread_id
result1 = await agent.ainvoke({"messages": [("user", "My name is Alice")]}, config)
result2 = await agent.ainvoke({"messages": [("user", "What's my name?")]}, config)
# Agent remembers: "Your name is Alice"
```

### Production Memory with PostgreSQL

```python
from langgraph.checkpoint.postgres import PostgresSaver

# Production checkpointer
checkpointer = PostgresSaver.from_conn_string(
    "postgresql://user:pass@localhost/langgraph"
)

agent = create_react_agent(llm, tools, checkpointer=checkpointer)
```

### Vector Store Memory for Long-Term Context

```python
from langchain_community.vectorstores import Chroma
from langchain_voyageai import VoyageAIEmbeddings

embeddings = VoyageAIEmbeddings(model="voyage-3-large")
memory_store = Chroma(
    collection_name="conversation_memory",
    embedding_function=embeddings,
    persist_directory="./memory_db"
)

async def retrieve_relevant_memory(query: str, k: int = 5) -> list:
    """Retrieve relevant past conversations."""
    docs = await memory_store.asimilarity_search(query, k=k)
    return [doc.page_content for doc in docs]

async def store_memory(content: str, metadata: dict = {}):
    """Store conversation in long-term memory."""
    await memory_store.add_texts([content], metadatas=[metadata])
```

## Callback System & LangSmith

### LangSmith Tracing

```python
import os
from langchain_anthropic import ChatAnthropic

# Enable LangSmith tracing
os.environ["LANGCHAIN_TRACING_V2"] = "true"
os.environ["LANGCHAIN_API_KEY"] = "your-api-key"
os.environ["LANGCHAIN_PROJECT"] = "my-project"

# All LangChain/LangGraph operations are automatically traced
llm = ChatAnthropic(model="claude-sonnet-4-5")
```

### Custom Callback Handler

```python
from langchain_core.callbacks import BaseCallbackHandler
from typing import Any, Dict, List

class CustomCallbackHandler(BaseCallbackHandler):
    def on_llm_start(
        self, serialized: Dict[str, Any], prompts: List[str], **kwargs
    ) -> None:
        print(f"LLM started with {len(prompts)} prompts")

    def on_llm_end(self, response, **kwargs) -> None:
        print(f"LLM completed: {len(response.generations)} generations")

    def on_llm_error(self, error: Exception, **kwargs) -> None:
        print(f"LLM error: {error}")

    def on_tool_start(
        self, serialized: Dict[str, Any], input_str: str, **kwargs
    ) -> None:
        print(f"Tool started: {serialized.get('name')}")

    def on_tool_end(self, output: str, **kwargs) -> None:
        print(f"Tool completed: {output[:100]}...")

# Use callbacks
result = await agent.ainvoke(
    {"messages": [("user", "query")]},
    config={"callbacks": [CustomCallbackHandler()]}
)
```

## Streaming Responses

```python
from langchain_anthropic import ChatAnthropic

llm = ChatAnthropic(model="claude-sonnet-4-5", streaming=True)

# Stream tokens
async for chunk in llm.astream("Tell me a story"):
    print(chunk.content, end="", flush=True)

# Stream agent events
async for event in agent.astream_events(
    {"messages": [("user", "Search and summarize")]},
    version="v2"
):
    if event["event"] == "on_chat_model_stream":
        print(event["data"]["chunk"].content, end="")
    elif event["event"] == "on_tool_start":
        print(f"\n[Using tool: {event['name']}]")
```

## Testing Strategies

```python
import pytest
from unittest.mock import AsyncMock, patch

@pytest.mark.asyncio
async def test_agent_tool_selection():
    """Test agent selects correct tool."""
    with patch.object(llm, 'ainvoke') as mock_llm:
        mock_llm.return_value = AsyncMock(content="Using search_database")

        result = await agent.ainvoke({
            "messages": [("user", "search for documents")]
        })

        # Verify tool was called
        assert "search_database" in str(result)

@pytest.mark.asyncio
async def test_memory_persistence():
    """Test memory persists across invocations."""
    config = {"configurable": {"thread_id": "test-thread"}}

    # First message
    await agent.ainvoke(
        {"messages": [("user", "Remember: the code is 12345")]},
        config
    )

    # Second message should remember
    result = await agent.ainvoke(
        {"messages": [("user", "What was the code?")]},
        config
    )

    assert "12345" in result["messages"][-1].content
```

## Performance Optimization

### 1. Caching with Redis

```python
from langchain_community.cache import RedisCache
from langchain_core.globals import set_llm_cache
import redis

redis_client = redis.Redis.from_url("redis://localhost:6379")
set_llm_cache(RedisCache(redis_client))
```

### 2. Async Batch Processing

```python
import asyncio
from langchain_core.documents import Document

async def process_documents(documents: list[Document]) -> list:
    """Process documents in parallel."""
    tasks = [process_single(doc) for doc in documents]
    return await asyncio.gather(*tasks)

async def process_single(doc: Document) -> dict:
    """Process a single document."""
    chunks = text_splitter.split_documents([doc])
    embeddings = await embeddings_model.aembed_documents(
        [c.page_content for c in chunks]
    )
    return {"doc_id": doc.metadata.get("id"), "embeddings": embeddings}
```

### 3. Connection Pooling

```python
from langchain_pinecone import PineconeVectorStore
from pinecone import Pinecone

# Reuse Pinecone client
pc = Pinecone(api_key=os.environ["PINECONE_API_KEY"])
index = pc.Index("my-index")

# Create vector store with existing index
vectorstore = PineconeVectorStore(index=index, embedding=embeddings)
```

## Resources

- [LangChain Documentation](https://python.langchain.com/docs/)
- [LangGraph Documentation](https://langchain-ai.github.io/langgraph/)
- [LangSmith Platform](https://smith.langchain.com/)
- [LangChain GitHub](https://github.com/langchain-ai/langchain)
- [LangGraph GitHub](https://github.com/langchain-ai/langgraph)

## Common Pitfalls

1. **Using Deprecated APIs**: Use LangGraph for agents, not `initialize_agent`
2. **Memory Overflow**: Use checkpointers with TTL for long-running agents
3. **Poor Tool Descriptions**: Clear descriptions help LLM select correct tools
4. **Context Window Exceeded**: Use summarization or sliding window memory
5. **No Error Handling**: Wrap tool functions with try/except
6. **Blocking Operations**: Use async methods (`ainvoke`, `astream`)
7. **Missing Observability**: Always enable LangSmith tracing in production

## Production Checklist

- [ ] Use LangGraph StateGraph for agent orchestration
- [ ] Implement async patterns throughout (`ainvoke`, `astream`)
- [ ] Add production checkpointer (PostgreSQL, Redis)
- [ ] Enable LangSmith tracing
- [ ] Implement structured tools with Pydantic schemas
- [ ] Add timeout limits for agent execution
- [ ] Implement rate limiting
- [ ] Add comprehensive error handling
- [ ] Set up health checks
- [ ] Version control prompts and configurations
- [ ] Write integration tests for agent workflows

## Llm Evaluation

# LLM Evaluation

Master comprehensive evaluation strategies for LLM applications, from automated metrics to human evaluation and A/B testing.

## When to Use This Skill

- Measuring LLM application performance systematically
- Comparing different models or prompts
- Detecting performance regressions before deployment
- Validating improvements from prompt changes
- Building confidence in production systems
- Establishing baselines and tracking progress over time
- Debugging unexpected model behavior

## Core Evaluation Types

### 1. Automated Metrics

Fast, repeatable, scalable evaluation using computed scores.

**Text Generation:**

- **BLEU**: N-gram overlap (translation)
- **ROUGE**: Recall-oriented (summarization)
- **METEOR**: Semantic similarity
- **BERTScore**: Embedding-based similarity
- **Perplexity**: Language model confidence

**Classification:**

- **Accuracy**: Percentage correct
- **Precision/Recall/F1**: Class-specific performance
- **Confusion Matrix**: Error patterns
- **AUC-ROC**: Ranking quality

**Retrieval (RAG):**

- **MRR**: Mean Reciprocal Rank
- **NDCG**: Normalized Discounted Cumulative Gain
- **Precision@K**: Relevant in top K
- **Recall@K**: Coverage in top K

### 2. Human Evaluation

Manual assessment for quality aspects difficult to automate.

**Dimensions:**

- **Accuracy**: Factual correctness
- **Coherence**: Logical flow
- **Relevance**: Answers the question
- **Fluency**: Natural language quality
- **Safety**: No harmful content
- **Helpfulness**: Useful to the user

### 3. LLM-as-Judge

Use stronger LLMs to evaluate weaker model outputs.

**Approaches:**

- **Pointwise**: Score individual responses
- **Pairwise**: Compare two responses
- **Reference-based**: Compare to gold standard
- **Reference-free**: Judge without ground truth

## Quick Start

```python
from dataclasses import dataclass
from typing import Callable
import numpy as np

@dataclass
class Metric:
    name: str
    fn: Callable

    @staticmethod
    def accuracy():
        return Metric("accuracy", calculate_accuracy)

    @staticmethod
    def bleu():
        return Metric("bleu", calculate_bleu)

    @staticmethod
    def bertscore():
        return Metric("bertscore", calculate_bertscore)

    @staticmethod
    def custom(name: str, fn: Callable):
        return Metric(name, fn)

class EvaluationSuite:
    def __init__(self, metrics: list[Metric]):
        self.metrics = metrics

    async def evaluate(self, model, test_cases: list[dict]) -> dict:
        results = {m.name: [] for m in self.metrics}

        for test in test_cases:
            prediction = await model.predict(test["input"])

            for metric in self.metrics:
                score = metric.fn(
                    prediction=prediction,
                    reference=test.get("expected"),
                    context=test.get("context")
                )
                results[metric.name].append(score)

        return {
            "metrics": {k: np.mean(v) for k, v in results.items()},
            "raw_scores": results
        }

# Usage
suite = EvaluationSuite([
    Metric.accuracy(),
    Metric.bleu(),
    Metric.bertscore(),
    Metric.custom("groundedness", check_groundedness)
])

test_cases = [
    {
        "input": "What is the capital of France?",
        "expected": "Paris",
        "context": "France is a country in Europe. Paris is its capital."
    },
]

results = await suite.evaluate(model=your_model, test_cases=test_cases)
```

## Automated Metrics Implementation

### BLEU Score

```python
from nltk.translate.bleu_score import sentence_bleu, SmoothingFunction

def calculate_bleu(reference: str, hypothesis: str, **kwargs) -> float:
    """Calculate BLEU score between reference and hypothesis."""
    smoothie = SmoothingFunction().method4

    return sentence_bleu(
        [reference.split()],
        hypothesis.split(),
        smoothing_function=smoothie
    )
```

### ROUGE Score

```python
from rouge_score import rouge_scorer

def calculate_rouge(reference: str, hypothesis: str, **kwargs) -> dict:
    """Calculate ROUGE scores."""
    scorer = rouge_scorer.RougeScorer(
        ['rouge1', 'rouge2', 'rougeL'],
        use_stemmer=True
    )
    scores = scorer.score(reference, hypothesis)

    return {
        'rouge1': scores['rouge1'].fmeasure,
        'rouge2': scores['rouge2'].fmeasure,
        'rougeL': scores['rougeL'].fmeasure
    }
```

### BERTScore

```python
from bert_score import score

def calculate_bertscore(
    references: list[str],
    hypotheses: list[str],
    **kwargs
) -> dict:
    """Calculate BERTScore using pre-trained model."""
    P, R, F1 = score(
        hypotheses,
        references,
        lang='en',
        model_type='microsoft/deberta-xlarge-mnli'
    )

    return {
        'precision': P.mean().item(),
        'recall': R.mean().item(),
        'f1': F1.mean().item()
    }
```

### Custom Metrics

```python
def calculate_groundedness(response: str, context: str, **kwargs) -> float:
    """Check if response is grounded in provided context."""
    from transformers import pipeline

    nli = pipeline(
        "text-classification",
        model="microsoft/deberta-large-mnli"
    )

    result = nli(f"{context} [SEP] {response}")[0]

    # Return confidence that response is entailed by context
    return result['score'] if result['label'] == 'ENTAILMENT' else 0.0

def calculate_toxicity(text: str, **kwargs) -> float:
    """Measure toxicity in generated text."""
    from detoxify import Detoxify

    results = Detoxify('original').predict(text)
    return max(results.values())  # Return highest toxicity score

def calculate_factuality(claim: str, sources: list[str], **kwargs) -> float:
    """Verify factual claims against sources."""
    from transformers import pipeline

    nli = pipeline("text-classification", model="facebook/bart-large-mnli")

    scores = []
    for source in sources:
        result = nli(f"{source}</s></s>{claim}")[0]
        if result['label'] == 'entailment':
            scores.append(result['score'])

    return max(scores) if scores else 0.0
```

## LLM-as-Judge Patterns

### Single Output Evaluation

```python
from anthropic import Anthropic
from pydantic import BaseModel, Field
import json

class QualityRating(BaseModel):
    accuracy: int = Field(ge=1, le=10, description="Factual correctness")
    helpfulness: int = Field(ge=1, le=10, description="Answers the question")
    clarity: int = Field(ge=1, le=10, description="Well-written and understandable")
    reasoning: str = Field(description="Brief explanation")

async def llm_judge_quality(
    response: str,
    question: str,
    context: str = None
) -> QualityRating:
    """Use Claude to judge response quality."""
    client = Anthropic()

    system = """You are an expert evaluator of AI responses.
    Rate responses on accuracy, helpfulness, and clarity (1-10 scale).
    Provide brief reasoning for your ratings."""

    prompt = f"""Rate the following response:

Question: {question}
{f'Context: {context}' if context else ''}
Response: {response}

Provide ratings in JSON format:
{{
  "accuracy": <1-10>,
  "helpfulness": <1-10>,
  "clarity": <1-10>,
  "reasoning": "<brief explanation>"
}}"""

    message = client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=500,
        system=system,
        messages=[{"role": "user", "content": prompt}]
    )

    return QualityRating(**json.loads(message.content[0].text))
```

### Pairwise Comparison

```python
from pydantic import BaseModel, Field
from typing import Literal

class ComparisonResult(BaseModel):
    winner: Literal["A", "B", "tie"]
    reasoning: str
    confidence: int = Field(ge=1, le=10)

async def compare_responses(
    question: str,
    response_a: str,
    response_b: str
) -> ComparisonResult:
    """Compare two responses using LLM judge."""
    client = Anthropic()

    prompt = f"""Compare these two responses and determine which is better.

Question: {question}

Response A: {response_a}

Response B: {response_b}

Consider accuracy, helpfulness, and clarity.

Answer with JSON:
{{
  "winner": "A" or "B" or "tie",
  "reasoning": "<explanation>",
  "confidence": <1-10>
}}"""

    message = client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=500,
        messages=[{"role": "user", "content": prompt}]
    )

    return ComparisonResult(**json.loads(message.content[0].text))
```

### Reference-Based Evaluation

```python
class ReferenceEvaluation(BaseModel):
    semantic_similarity: float = Field(ge=0, le=1)
    factual_accuracy: float = Field(ge=0, le=1)
    completeness: float = Field(ge=0, le=1)
    issues: list[str]

async def evaluate_against_reference(
    response: str,
    reference: str,
    question: str
) -> ReferenceEvaluation:
    """Evaluate response against gold standard reference."""
    client = Anthropic()

    prompt = f"""Compare the response to the reference answer.

Question: {question}
Reference Answer: {reference}
Response to Evaluate: {response}

Evaluate:
1. Semantic similarity (0-1): How similar is the meaning?
2. Factual accuracy (0-1): Are all facts correct?
3. Completeness (0-1): Does it cover all key points?
4. List any specific issues or errors.

Respond in JSON:
{{
  "semantic_similarity": <0-1>,
  "factual_accuracy": <0-1>,
  "completeness": <0-1>,
  "issues": ["issue1", "issue2"]
}}"""

    message = client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=500,
        messages=[{"role": "user", "content": prompt}]
    )

    return ReferenceEvaluation(**json.loads(message.content[0].text))
```

## Human Evaluation Frameworks

### Annotation Guidelines

```python
from dataclasses import dataclass, field
from typing import Optional

@dataclass
class AnnotationTask:
    """Structure for human annotation task."""
    response: str
    question: str
    context: Optional[str] = None

    def get_annotation_form(self) -> dict:
        return {
            "question": self.question,
            "context": self.context,
            "response": self.response,
            "ratings": {
                "accuracy": {
                    "scale": "1-5",
                    "description": "Is the response factually correct?"
                },
                "relevance": {
                    "scale": "1-5",
                    "description": "Does it answer the question?"
                },
                "coherence": {
                    "scale": "1-5",
                    "description": "Is it logically consistent?"
                }
            },
            "issues": {
                "factual_error": False,
                "hallucination": False,
                "off_topic": False,
                "unsafe_content": False
            },
            "feedback": ""
        }
```

### Inter-Rater Agreement

```python
from sklearn.metrics import cohen_kappa_score

def calculate_agreement(
    rater1_scores: list[int],
    rater2_scores: list[int]
) -> dict:
    """Calculate inter-rater agreement."""
    kappa = cohen_kappa_score(rater1_scores, rater2_scores)

    if kappa < 0:
        interpretation = "Poor"
    elif kappa < 0.2:
        interpretation = "Slight"
    elif kappa < 0.4:
        interpretation = "Fair"
    elif kappa < 0.6:
        interpretation = "Moderate"
    elif kappa < 0.8:
        interpretation = "Substantial"
    else:
        interpretation = "Almost Perfect"

    return {
        "kappa": kappa,
        "interpretation": interpretation
    }
```

## A/B Testing

### Statistical Testing Framework

```python
from scipy import stats
import numpy as np
from dataclasses import dataclass, field

@dataclass
class ABTest:
    variant_a_name: str = "A"
    variant_b_name: str = "B"
    variant_a_scores: list[float] = field(default_factory=list)
    variant_b_scores: list[float] = field(default_factory=list)

    def add_result(self, variant: str, score: float):
        """Add evaluation result for a variant."""
        if variant == "A":
            self.variant_a_scores.append(score)
        else:
            self.variant_b_scores.append(score)

    def analyze(self, alpha: float = 0.05) -> dict:
        """Perform statistical analysis."""
        a_scores = np.array(self.variant_a_scores)
        b_scores = np.array(self.variant_b_scores)

        # T-test
        t_stat, p_value = stats.ttest_ind(a_scores, b_scores)

        # Effect size (Cohen's d)
        pooled_std = np.sqrt((np.std(a_scores)**2 + np.std(b_scores)**2) / 2)
        cohens_d = (np.mean(b_scores) - np.mean(a_scores)) / pooled_std

        return {
            "variant_a_mean": np.mean(a_scores),
            "variant_b_mean": np.mean(b_scores),
            "difference": np.mean(b_scores) - np.mean(a_scores),
            "relative_improvement": (np.mean(b_scores) - np.mean(a_scores)) / np.mean(a_scores),
            "p_value": p_value,
            "statistically_significant": p_value < alpha,
            "cohens_d": cohens_d,
            "effect_size": self._interpret_cohens_d(cohens_d),
            "winner": self.variant_b_name if np.mean(b_scores) > np.mean(a_scores) else self.variant_a_name
        }

    @staticmethod
    def _interpret_cohens_d(d: float) -> str:
        """Interpret Cohen's d effect size."""
        abs_d = abs(d)
        if abs_d < 0.2:
            return "negligible"
        elif abs_d < 0.5:
            return "small"
        elif abs_d < 0.8:
            return "medium"
        else:
            return "large"
```

## Regression Testing

### Regression Detection

```python
from dataclasses import dataclass

@dataclass
class RegressionResult:
    metric: str
    baseline: float
    current: float
    change: float
    is_regression: bool

class RegressionDetector:
    def __init__(self, baseline_results: dict, threshold: float = 0.05):
        self.baseline = baseline_results
        self.threshold = threshold

    def check_for_regression(self, new_results: dict) -> dict:
        """Detect if new results show regression."""
        regressions = []

        for metric in self.baseline.keys():
            baseline_score = self.baseline[metric]
            new_score = new_results.get(metric)

            if new_score is None:
                continue

            # Calculate relative change
            relative_change = (new_score - baseline_score) / baseline_score

            # Flag if significant decrease
            is_regression = relative_change < -self.threshold
            if is_regression:
                regressions.append(RegressionResult(
                    metric=metric,
                    baseline=baseline_score,
                    current=new_score,
                    change=relative_change,
                    is_regression=True
                ))

        return {
            "has_regression": len(regressions) > 0,
            "regressions": regressions,
            "summary": f"{len(regressions)} metric(s) regressed"
        }
```

## LangSmith Evaluation Integration

```python
from langsmith import Client
from langsmith.evaluation import evaluate, LangChainStringEvaluator

# Initialize LangSmith client
client = Client()

# Create dataset
dataset = client.create_dataset("qa_test_cases")
client.create_examples(
    inputs=[{"question": q} for q in questions],
    outputs=[{"answer": a} for a in expected_answers],
    dataset_id=dataset.id
)

# Define evaluators
evaluators = [
    LangChainStringEvaluator("qa"),           # QA correctness
    LangChainStringEvaluator("context_qa"),   # Context-grounded QA
    LangChainStringEvaluator("cot_qa"),       # Chain-of-thought QA
]

# Run evaluation
async def target_function(inputs: dict) -> dict:
    result = await your_chain.ainvoke(inputs)
    return {"answer": result}

experiment_results = await evaluate(
    target_function,
    data=dataset.name,
    evaluators=evaluators,
    experiment_prefix="v1.0.0",
    metadata={"model": "claude-sonnet-4-5", "version": "1.0.0"}
)

print(f"Mean score: {experiment_results.aggregate_metrics['qa']['mean']}")
```

## Benchmarking

### Running Benchmarks

```python
from dataclasses import dataclass
import numpy as np

@dataclass
class BenchmarkResult:
    metric: str
    mean: float
    std: float
    min: float
    max: float

class BenchmarkRunner:
    def __init__(self, benchmark_dataset: list[dict]):
        self.dataset = benchmark_dataset

    async def run_benchmark(
        self,
        model,
        metrics: list[Metric]
    ) -> dict[str, BenchmarkResult]:
        """Run model on benchmark and calculate metrics."""
        results = {metric.name: [] for metric in metrics}

        for example in self.dataset:
            # Generate prediction
            prediction = await model.predict(example["input"])

            # Calculate each metric
            for metric in metrics:
                score = metric.fn(
                    prediction=prediction,
                    reference=example["reference"],
                    context=example.get("context")
                )
                results[metric.name].append(score)

        # Aggregate results
        return {
            metric: BenchmarkResult(
                metric=metric,
                mean=np.mean(scores),
                std=np.std(scores),
                min=min(scores),
                max=max(scores)
            )
            for metric, scores in results.items()
        }
```

## Resources

- [LangSmith Evaluation Guide](https://docs.smith.langchain.com/evaluation)
- [RAGAS Framework](https://docs.ragas.io/)
- [DeepEval Library](https://docs.deepeval.com/)
- [Arize Phoenix](https://docs.arize.com/phoenix/)
- [HELM Benchmark](https://crfm.stanford.edu/helm/)

## Best Practices

1. **Multiple Metrics**: Use diverse metrics for comprehensive view
2. **Representative Data**: Test on real-world, diverse examples
3. **Baselines**: Always compare against baseline performance
4. **Statistical Rigor**: Use proper statistical tests for comparisons
5. **Continuous Evaluation**: Integrate into CI/CD pipeline
6. **Human Validation**: Combine automated metrics with human judgment
7. **Error Analysis**: Investigate failures to understand weaknesses
8. **Version Control**: Track evaluation results over time

## Common Pitfalls

- **Single Metric Obsession**: Optimizing for one metric at the expense of others
- **Small Sample Size**: Drawing conclusions from too few examples
- **Data Contamination**: Testing on training data
- **Ignoring Variance**: Not accounting for statistical uncertainty
- **Metric Mismatch**: Using metrics not aligned with business goals
- **Position Bias**: In pairwise evals, randomize order
- **Overfitting Prompts**: Optimizing for test set instead of real use

## Prompt Engineering Patterns

# Prompt Engineering Patterns

Master advanced prompt engineering techniques to maximize LLM performance, reliability, and controllability.

## When to Use This Skill

- Designing complex prompts for production LLM applications
- Optimizing prompt performance and consistency
- Implementing structured reasoning patterns (chain-of-thought, tree-of-thought)
- Building few-shot learning systems with dynamic example selection
- Creating reusable prompt templates with variable interpolation
- Debugging and refining prompts that produce inconsistent outputs
- Implementing system prompts for specialized AI assistants
- Using structured outputs (JSON mode) for reliable parsing

## Core Capabilities

### 1. Few-Shot Learning

- Example selection strategies (semantic similarity, diversity sampling)
- Balancing example count with context window constraints
- Constructing effective demonstrations with input-output pairs
- Dynamic example retrieval from knowledge bases
- Handling edge cases through strategic example selection

### 2. Chain-of-Thought Prompting

- Step-by-step reasoning elicitation
- Zero-shot CoT with "Let's think step by step"
- Few-shot CoT with reasoning traces
- Self-consistency techniques (sampling multiple reasoning paths)
- Verification and validation steps

### 3. Structured Outputs

- JSON mode for reliable parsing
- Pydantic schema enforcement
- Type-safe response handling
- Error handling for malformed outputs

### 4. Prompt Optimization

- Iterative refinement workflows
- A/B testing prompt variations
- Measuring prompt performance metrics (accuracy, consistency, latency)
- Reducing token usage while maintaining quality
- Handling edge cases and failure modes

### 5. Template Systems

- Variable interpolation and formatting
- Conditional prompt sections
- Multi-turn conversation templates
- Role-based prompt composition
- Modular prompt components

### 6. System Prompt Design

- Setting model behavior and constraints
- Defining output formats and structure
- Establishing role and expertise
- Safety guidelines and content policies
- Context setting and background information

## Quick Start

```python
from langchain_anthropic import ChatAnthropic
from langchain_core.prompts import ChatPromptTemplate
from pydantic import BaseModel, Field

# Define structured output schema
class SQLQuery(BaseModel):
    query: str = Field(description="The SQL query")
    explanation: str = Field(description="Brief explanation of what the query does")
    tables_used: list[str] = Field(description="List of tables referenced")

# Initialize model with structured output
llm = ChatAnthropic(model="claude-sonnet-4-5")
structured_llm = llm.with_structured_output(SQLQuery)

# Create prompt template
prompt = ChatPromptTemplate.from_messages([
    ("system", """You are an expert SQL developer. Generate efficient, secure SQL queries.
    Always use parameterized queries to prevent SQL injection.
    Explain your reasoning briefly."""),
    ("user", "Convert this to SQL: {query}")
])

# Create chain
chain = prompt | structured_llm

# Use
result = await chain.ainvoke({
    "query": "Find all users who registered in the last 30 days"
})
print(result.query)
print(result.explanation)
```

## Key Patterns

### Pattern 1: Structured Output with Pydantic

```python
from anthropic import Anthropic
from pydantic import BaseModel, Field
from typing import Literal
import json

class SentimentAnalysis(BaseModel):
    sentiment: Literal["positive", "negative", "neutral"]
    confidence: float = Field(ge=0, le=1)
    key_phrases: list[str]
    reasoning: str

async def analyze_sentiment(text: str) -> SentimentAnalysis:
    """Analyze sentiment with structured output."""
    client = Anthropic()

    message = client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=500,
        messages=[{
            "role": "user",
            "content": f"""Analyze the sentiment of this text.

Text: {text}

Respond with JSON matching this schema:
{{
    "sentiment": "positive" | "negative" | "neutral",
    "confidence": 0.0-1.0,
    "key_phrases": ["phrase1", "phrase2"],
    "reasoning": "brief explanation"
}}"""
        }]
    )

    return SentimentAnalysis(**json.loads(message.content[0].text))
```

### Pattern 2: Chain-of-Thought with Self-Verification

```python
from langchain_core.prompts import ChatPromptTemplate

cot_prompt = ChatPromptTemplate.from_template("""
Solve this problem step by step.

Problem: {problem}

Instructions:
1. Break down the problem into clear steps
2. Work through each step showing your reasoning
3. State your final answer
4. Verify your answer by checking it against the original problem

Format your response as:
## Steps
[Your step-by-step reasoning]

## Answer
[Your final answer]

## Verification
[Check that your answer is correct]
""")
```

### Pattern 3: Few-Shot with Dynamic Example Selection

```python
from langchain_voyageai import VoyageAIEmbeddings
from langchain_core.example_selectors import SemanticSimilarityExampleSelector
from langchain_chroma import Chroma

# Create example selector with semantic similarity
example_selector = SemanticSimilarityExampleSelector.from_examples(
    examples=[
        {"input": "How do I reset my password?", "output": "Go to Settings > Security > Reset Password"},
        {"input": "Where can I see my order history?", "output": "Navigate to Account > Orders"},
        {"input": "How do I contact support?", "output": "Click Help > Contact Us or email support@example.com"},
    ],
    embeddings=VoyageAIEmbeddings(model="voyage-3-large"),
    vectorstore_cls=Chroma,
    k=2  # Select 2 most similar examples
)

async def get_few_shot_prompt(query: str) -> str:
    """Build prompt with dynamically selected examples."""
    examples = await example_selector.aselect_examples({"input": query})

    examples_text = "\n".join(
        f"User: {ex['input']}\nAssistant: {ex['output']}"
        for ex in examples
    )

    return f"""You are a helpful customer support assistant.

Here are some example interactions:
{examples_text}

Now respond to this query:
User: {query}
Assistant:"""
```

### Pattern 4: Progressive Disclosure

Start with simple prompts, add complexity only when needed:

```python
PROMPT_LEVELS = {
    # Level 1: Direct instruction
    "simple": "Summarize this article: {text}",

    # Level 2: Add constraints
    "constrained": """Summarize this article in 3 bullet points, focusing on:
- Key findings
- Main conclusions
- Practical implications

Article: {text}""",

    # Level 3: Add reasoning
    "reasoning": """Read this article carefully.
1. First, identify the main topic and thesis
2. Then, extract the key supporting points
3. Finally, summarize in 3 bullet points

Article: {text}

Summary:""",

    # Level 4: Add examples
    "few_shot": """Read articles and provide concise summaries.

Example:
Article: "New research shows that regular exercise can reduce anxiety by up to 40%..."
Summary:
• Regular exercise reduces anxiety by up to 40%
• 30 minutes of moderate activity 3x/week is sufficient
• Benefits appear within 2 weeks of starting

Now summarize this article:
Article: {text}

Summary:"""
}
```

### Pattern 5: Error Recovery and Fallback

```python
from pydantic import BaseModel, ValidationError
import json

class ResponseWithConfidence(BaseModel):
    answer: str
    confidence: float
    sources: list[str]
    alternative_interpretations: list[str] = []

ERROR_RECOVERY_PROMPT = """
Answer the question based on the context provided.

Context: {context}
Question: {question}

Instructions:
1. If you can answer confidently (>0.8), provide a direct answer
2. If you're somewhat confident (0.5-0.8), provide your best answer with caveats
3. If you're uncertain (<0.5), explain what information is missing
4. Always provide alternative interpretations if the question is ambiguous

Respond in JSON:
{{
    "answer": "your answer or 'I cannot determine this from the context'",
    "confidence": 0.0-1.0,
    "sources": ["relevant context excerpts"],
    "alternative_interpretations": ["if question is ambiguous"]
}}
"""

async def answer_with_fallback(
    context: str,
    question: str,
    llm
) -> ResponseWithConfidence:
    """Answer with error recovery and fallback."""
    prompt = ERROR_RECOVERY_PROMPT.format(context=context, question=question)

    try:
        response = await llm.ainvoke(prompt)
        return ResponseWithConfidence(**json.loads(response.content))
    except (json.JSONDecodeError, ValidationError) as e:
        # Fallback: try to extract answer without structure
        simple_prompt = f"Based on: {context}\n\nAnswer: {question}"
        simple_response = await llm.ainvoke(simple_prompt)
        return ResponseWithConfidence(
            answer=simple_response.content,
            confidence=0.5,
            sources=["fallback extraction"],
            alternative_interpretations=[]
        )
```

### Pattern 6: Role-Based System Prompts

```python
SYSTEM_PROMPTS = {
    "analyst": """You are a senior data analyst with expertise in SQL, Python, and business intelligence.

Your responsibilities:
- Write efficient, well-documented queries
- Explain your analysis methodology
- Highlight key insights and recommendations
- Flag any data quality concerns

Communication style:
- Be precise and technical when discussing methodology
- Translate technical findings into business impact
- Use clear visualizations when helpful""",

    "assistant": """You are a helpful AI assistant focused on accuracy and clarity.

Core principles:
- Always cite sources when making factual claims
- Acknowledge uncertainty rather than guessing
- Ask clarifying questions when the request is ambiguous
- Provide step-by-step explanations for complex topics

Constraints:
- Do not provide medical, legal, or financial advice
- Redirect harmful requests appropriately
- Protect user privacy""",

    "code_reviewer": """You are a senior software engineer conducting code reviews.

Review criteria:
- Correctness: Does the code work as intended?
- Security: Are there any vulnerabilities?
- Performance: Are there efficiency concerns?
- Maintainability: Is the code readable and well-structured?
- Best practices: Does it follow language idioms?

Output format:
1. Summary assessment (approve/request changes)
2. Critical issues (must fix)
3. Suggestions (nice to have)
4. Positive feedback (what's done well)"""
}
```

## Integration Patterns

### With RAG Systems

```python
RAG_PROMPT = """You are a knowledgeable assistant that answers questions based on provided context.

Context (retrieved from knowledge base):
{context}

Instructions:
1. Answer ONLY based on the provided context
2. If the context doesn't contain the answer, say "I don't have information about that in my knowledge base"
3. Cite specific passages using [1], [2] notation
4. If the question is ambiguous, ask for clarification

Question: {question}

Answer:"""
```

### With Validation and Verification

```python
VALIDATED_PROMPT = """Complete the following task:

Task: {task}

After generating your response, verify it meets ALL these criteria:
✓ Directly addresses the original request
✓ Contains no factual errors
✓ Is appropriately detailed (not too brief, not too verbose)
✓ Uses proper formatting
✓ Is safe and appropriate

If verification fails on any criterion, revise before responding.

Response:"""
```

## Performance Optimization

### Token Efficiency

```python
# Before: Verbose prompt (150+ tokens)
verbose_prompt = """
I would like you to please take the following text and provide me with a comprehensive
summary of the main points. The summary should capture the key ideas and important details
while being concise and easy to understand.
"""

# After: Concise prompt (30 tokens)
concise_prompt = """Summarize the key points concisely:

{text}

Summary:"""
```

### Caching Common Prefixes

```python
from anthropic import Anthropic

client = Anthropic()

# Use prompt caching for repeated system prompts
response = client.messages.create(
    model="claude-sonnet-4-5",
    max_tokens=1000,
    system=[
        {
            "type": "text",
            "text": LONG_SYSTEM_PROMPT,
            "cache_control": {"type": "ephemeral"}
        }
    ],
    messages=[{"role": "user", "content": user_query}]
)
```

## Best Practices

1. **Be Specific**: Vague prompts produce inconsistent results
2. **Show, Don't Tell**: Examples are more effective than descriptions
3. **Use Structured Outputs**: Enforce schemas with Pydantic for reliability
4. **Test Extensively**: Evaluate on diverse, representative inputs
5. **Iterate Rapidly**: Small changes can have large impacts
6. **Monitor Performance**: Track metrics in production
7. **Version Control**: Treat prompts as code with proper versioning
8. **Document Intent**: Explain why prompts are structured as they are

## Common Pitfalls

- **Over-engineering**: Starting with complex prompts before trying simple ones
- **Example pollution**: Using examples that don't match the target task
- **Context overflow**: Exceeding token limits with excessive examples
- **Ambiguous instructions**: Leaving room for multiple interpretations
- **Ignoring edge cases**: Not testing on unusual or boundary inputs
- **No error handling**: Assuming outputs will always be well-formed
- **Hardcoded values**: Not parameterizing prompts for reuse

## Success Metrics

Track these KPIs for your prompts:

- **Accuracy**: Correctness of outputs
- **Consistency**: Reproducibility across similar inputs
- **Latency**: Response time (P50, P95, P99)
- **Token Usage**: Average tokens per request
- **Success Rate**: Percentage of valid, parseable outputs
- **User Satisfaction**: Ratings and feedback

## Resources

- [Anthropic Prompt Engineering Guide](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering)
- [Claude Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)
- [OpenAI Prompt Engineering](https://platform.openai.com/docs/guides/prompt-engineering)
- [LangChain Prompts](https://python.langchain.com/docs/concepts/prompts/)

## Rag Implementation

# RAG Implementation

Master Retrieval-Augmented Generation (RAG) to build LLM applications that provide accurate, grounded responses using external knowledge sources.

## When to Use This Skill

- Building Q&A systems over proprietary documents
- Creating chatbots with current, factual information
- Implementing semantic search with natural language queries
- Reducing hallucinations with grounded responses
- Enabling LLMs to access domain-specific knowledge
- Building documentation assistants
- Creating research tools with source citation

## Core Components

### 1. Vector Databases

**Purpose**: Store and retrieve document embeddings efficiently

**Options:**

- **Pinecone**: Managed, scalable, serverless
- **Weaviate**: Open-source, hybrid search, GraphQL
- **Milvus**: High performance, on-premise
- **Chroma**: Lightweight, easy to use, local development
- **Qdrant**: Fast, filtered search, Rust-based
- **pgvector**: PostgreSQL extension, SQL integration

### 2. Embeddings

**Purpose**: Convert text to numerical vectors for similarity search

**Models (2026):**

| Model | Dimensions | Best For |
|-------|------------|----------|
| **voyage-3-large** | 1024 | Claude apps (Anthropic recommended) |
| **voyage-code-3** | 1024 | Code search |
| **text-embedding-3-large** | 3072 | OpenAI apps, high accuracy |
| **text-embedding-3-small** | 1536 | OpenAI apps, cost-effective |
| **bge-large-en-v1.5** | 1024 | Open source, local deployment |
| **multilingual-e5-large** | 1024 | Multi-language support |

### 3. Retrieval Strategies

**Approaches:**

- **Dense Retrieval**: Semantic similarity via embeddings
- **Sparse Retrieval**: Keyword matching (BM25, TF-IDF)
- **Hybrid Search**: Combine dense + sparse with weighted fusion
- **Multi-Query**: Generate multiple query variations
- **HyDE**: Generate hypothetical documents for better retrieval

### 4. Reranking

**Purpose**: Improve retrieval quality by reordering results

**Methods:**

- **Cross-Encoders**: BERT-based reranking (ms-marco-MiniLM)
- **Cohere Rerank**: API-based reranking
- **Maximal Marginal Relevance (MMR)**: Diversity + relevance
- **LLM-based**: Use LLM to score relevance

## Quick Start with LangGraph

```python
from langgraph.graph import StateGraph, START, END
from langchain_anthropic import ChatAnthropic
from langchain_voyageai import VoyageAIEmbeddings
from langchain_pinecone import PineconeVectorStore
from langchain_core.documents import Document
from langchain_core.prompts import ChatPromptTemplate
from langchain_text_splitters import RecursiveCharacterTextSplitter
from typing import TypedDict, Annotated

class RAGState(TypedDict):
    question: str
    context: list[Document]
    answer: str

# Initialize components
llm = ChatAnthropic(model="claude-sonnet-4-5")
embeddings = VoyageAIEmbeddings(model="voyage-3-large")
vectorstore = PineconeVectorStore(index_name="docs", embedding=embeddings)
retriever = vectorstore.as_retriever(search_kwargs={"k": 4})

# RAG prompt
rag_prompt = ChatPromptTemplate.from_template(
    """Answer based on the context below. If you cannot answer, say so.

    Context:
    {context}

    Question: {question}

    Answer:"""
)

async def retrieve(state: RAGState) -> RAGState:
    """Retrieve relevant documents."""
    docs = await retriever.ainvoke(state["question"])
    return {"context": docs}

async def generate(state: RAGState) -> RAGState:
    """Generate answer from context."""
    context_text = "\n\n".join(doc.page_content for doc in state["context"])
    messages = rag_prompt.format_messages(
        context=context_text,
        question=state["question"]
    )
    response = await llm.ainvoke(messages)
    return {"answer": response.content}

# Build RAG graph
builder = StateGraph(RAGState)
builder.add_node("retrieve", retrieve)
builder.add_node("generate", generate)
builder.add_edge(START, "retrieve")
builder.add_edge("retrieve", "generate")
builder.add_edge("generate", END)

rag_chain = builder.compile()

# Use
result = await rag_chain.ainvoke({"question": "What are the main features?"})
print(result["answer"])
```

## Advanced RAG Patterns

### Pattern 1: Hybrid Search with RRF

```python
from langchain_community.retrievers import BM25Retriever
from langchain.retrievers import EnsembleRetriever

# Sparse retriever (BM25 for keyword matching)
bm25_retriever = BM25Retriever.from_documents(documents)
bm25_retriever.k = 10

# Dense retriever (embeddings for semantic search)
dense_retriever = vectorstore.as_retriever(search_kwargs={"k": 10})

# Combine with Reciprocal Rank Fusion weights
ensemble_retriever = EnsembleRetriever(
    retrievers=[bm25_retriever, dense_retriever],
    weights=[0.3, 0.7]  # 30% keyword, 70% semantic
)
```

### Pattern 2: Multi-Query Retrieval

```python
from langchain.retrievers.multi_query import MultiQueryRetriever

# Generate multiple query perspectives for better recall
multi_query_retriever = MultiQueryRetriever.from_llm(
    retriever=vectorstore.as_retriever(search_kwargs={"k": 5}),
    llm=llm
)

# Single query → multiple variations → combined results
results = await multi_query_retriever.ainvoke("What is the main topic?")
```

### Pattern 3: Contextual Compression

```python
from langchain.retrievers import ContextualCompressionRetriever
from langchain.retrievers.document_compressors import LLMChainExtractor

# Compressor extracts only relevant portions
compressor = LLMChainExtractor.from_llm(llm)

compression_retriever = ContextualCompressionRetriever(
    base_compressor=compressor,
    base_retriever=vectorstore.as_retriever(search_kwargs={"k": 10})
)

# Returns only relevant parts of documents
compressed_docs = await compression_retriever.ainvoke("specific query")
```

### Pattern 4: Parent Document Retriever

```python
from langchain.retrievers import ParentDocumentRetriever
from langchain.storage import InMemoryStore
from langchain_text_splitters import RecursiveCharacterTextSplitter

# Small chunks for precise retrieval, large chunks for context
child_splitter = RecursiveCharacterTextSplitter(chunk_size=400, chunk_overlap=50)
parent_splitter = RecursiveCharacterTextSplitter(chunk_size=2000, chunk_overlap=200)

# Store for parent documents
docstore = InMemoryStore()

parent_retriever = ParentDocumentRetriever(
    vectorstore=vectorstore,
    docstore=docstore,
    child_splitter=child_splitter,
    parent_splitter=parent_splitter
)

# Add documents (splits children, stores parents)
await parent_retriever.add_documents(documents)

# Retrieval returns parent documents with full context
results = await parent_retriever.ainvoke("query")
```

### Pattern 5: HyDE (Hypothetical Document Embeddings)

```python
from langchain_core.prompts import ChatPromptTemplate

class HyDEState(TypedDict):
    question: str
    hypothetical_doc: str
    context: list[Document]
    answer: str

hyde_prompt = ChatPromptTemplate.from_template(
    """Write a detailed passage that would answer this question:

    Question: {question}

    Passage:"""
)

async def generate_hypothetical(state: HyDEState) -> HyDEState:
    """Generate hypothetical document for better retrieval."""
    messages = hyde_prompt.format_messages(question=state["question"])
    response = await llm.ainvoke(messages)
    return {"hypothetical_doc": response.content}

async def retrieve_with_hyde(state: HyDEState) -> HyDEState:
    """Retrieve using hypothetical document."""
    # Use hypothetical doc for retrieval instead of original query
    docs = await retriever.ainvoke(state["hypothetical_doc"])
    return {"context": docs}

# Build HyDE RAG graph
builder = StateGraph(HyDEState)
builder.add_node("hypothetical", generate_hypothetical)
builder.add_node("retrieve", retrieve_with_hyde)
builder.add_node("generate", generate)
builder.add_edge(START, "hypothetical")
builder.add_edge("hypothetical", "retrieve")
builder.add_edge("retrieve", "generate")
builder.add_edge("generate", END)

hyde_rag = builder.compile()
```

## Document Chunking Strategies

### Recursive Character Text Splitter

```python
from langchain_text_splitters import RecursiveCharacterTextSplitter

splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200,
    length_function=len,
    separators=["\n\n", "\n", ". ", " ", ""]  # Try in order
)

chunks = splitter.split_documents(documents)
```

### Token-Based Splitting

```python
from langchain_text_splitters import TokenTextSplitter

splitter = TokenTextSplitter(
    chunk_size=512,
    chunk_overlap=50,
    encoding_name="cl100k_base"  # OpenAI tiktoken encoding
)
```

### Semantic Chunking

```python
from langchain_experimental.text_splitter import SemanticChunker

splitter = SemanticChunker(
    embeddings=embeddings,
    breakpoint_threshold_type="percentile",
    breakpoint_threshold_amount=95
)
```

### Markdown Header Splitter

```python
from langchain_text_splitters import MarkdownHeaderTextSplitter

headers_to_split_on = [
    ("#", "Header 1"),
    ("##", "Header 2"),
    ("###", "Header 3"),
]

splitter = MarkdownHeaderTextSplitter(
    headers_to_split_on=headers_to_split_on,
    strip_headers=False
)
```

## Vector Store Configurations

### Pinecone (Serverless)

```python
from pinecone import Pinecone, ServerlessSpec
from langchain_pinecone import PineconeVectorStore

# Initialize Pinecone client
pc = Pinecone(api_key=os.environ["PINECONE_API_KEY"])

# Create index if needed
if "my-index" not in pc.list_indexes().names():
    pc.create_index(
        name="my-index",
        dimension=1024,  # voyage-3-large dimensions
        metric="cosine",
        spec=ServerlessSpec(cloud="aws", region="us-east-1")
    )

# Create vector store
index = pc.Index("my-index")
vectorstore = PineconeVectorStore(index=index, embedding=embeddings)
```

### Weaviate

```python
import weaviate
from langchain_weaviate import WeaviateVectorStore

client = weaviate.connect_to_local()  # or connect_to_weaviate_cloud()

vectorstore = WeaviateVectorStore(
    client=client,
    index_name="Documents",
    text_key="content",
    embedding=embeddings
)
```

### Chroma (Local Development)

```python
from langchain_chroma import Chroma

vectorstore = Chroma(
    collection_name="my_collection",
    embedding_function=embeddings,
    persist_directory="./chroma_db"
)
```

### pgvector (PostgreSQL)

```python
from langchain_postgres.vectorstores import PGVector

connection_string = "postgresql+psycopg://user:pass@localhost:5432/vectordb"

vectorstore = PGVector(
    embeddings=embeddings,
    collection_name="documents",
    connection=connection_string,
)
```

## Retrieval Optimization

### 1. Metadata Filtering

```python
from langchain_core.documents import Document

# Add metadata during indexing
docs_with_metadata = []
for doc in documents:
    doc.metadata.update({
        "source": doc.metadata.get("source", "unknown"),
        "category": determine_category(doc.page_content),
        "date": datetime.now().isoformat()
    })
    docs_with_metadata.append(doc)

# Filter during retrieval
results = await vectorstore.asimilarity_search(
    "query",
    filter={"category": "technical"},
    k=5
)
```

### 2. Maximal Marginal Relevance (MMR)

```python
# Balance relevance with diversity
results = await vectorstore.amax_marginal_relevance_search(
    "query",
    k=5,
    fetch_k=20,  # Fetch 20, return top 5 diverse
    lambda_mult=0.5  # 0=max diversity, 1=max relevance
)
```

### 3. Reranking with Cross-Encoder

```python
from sentence_transformers import CrossEncoder

reranker = CrossEncoder('cross-encoder/ms-marco-MiniLM-L-6-v2')

async def retrieve_and_rerank(query: str, k: int = 5) -> list[Document]:
    # Get initial results
    candidates = await vectorstore.asimilarity_search(query, k=20)

    # Rerank
    pairs = [[query, doc.page_content] for doc in candidates]
    scores = reranker.predict(pairs)

    # Sort by score and take top k
    ranked = sorted(zip(candidates, scores), key=lambda x: x[1], reverse=True)
    return [doc for doc, score in ranked[:k]]
```

### 4. Cohere Rerank

```python
from langchain.retrievers import CohereRerank
from langchain_cohere import CohereRerank

reranker = CohereRerank(model="rerank-english-v3.0", top_n=5)

# Wrap retriever with reranking
reranked_retriever = ContextualCompressionRetriever(
    base_compressor=reranker,
    base_retriever=vectorstore.as_retriever(search_kwargs={"k": 20})
)
```

## Prompt Engineering for RAG

### Contextual Prompt with Citations

```python
rag_prompt = ChatPromptTemplate.from_template(
    """Answer the question based on the context below. Include citations using [1], [2], etc.

    If you cannot answer based on the context, say "I don't have enough information."

    Context:
    {context}

    Question: {question}

    Instructions:
    1. Use only information from the context
    2. Cite sources with [1], [2] format
    3. If uncertain, express uncertainty

    Answer (with citations):"""
)
```

### Structured Output for RAG

```python
from pydantic import BaseModel, Field

class RAGResponse(BaseModel):
    answer: str = Field(description="The answer based on context")
    confidence: float = Field(description="Confidence score 0-1")
    sources: list[str] = Field(description="Source document IDs used")
    reasoning: str = Field(description="Brief reasoning for the answer")

# Use with structured output
structured_llm = llm.with_structured_output(RAGResponse)
```

## Evaluation Metrics

```python
from typing import TypedDict

class RAGEvalMetrics(TypedDict):
    retrieval_precision: float  # Relevant docs / retrieved docs
    retrieval_recall: float     # Retrieved relevant / total relevant
    answer_relevance: float     # Answer addresses question
    faithfulness: float         # Answer grounded in context
    context_relevance: float    # Context relevant to question

async def evaluate_rag_system(
    rag_chain,
    test_cases: list[dict]
) -> RAGEvalMetrics:
    """Evaluate RAG system on test cases."""
    metrics = {k: [] for k in RAGEvalMetrics.__annotations__}

    for test in test_cases:
        result = await rag_chain.ainvoke({"question": test["question"]})

        # Retrieval metrics
        retrieved_ids = {doc.metadata["id"] for doc in result["context"]}
        relevant_ids = set(test["relevant_doc_ids"])

        precision = len(retrieved_ids & relevant_ids) / len(retrieved_ids)
        recall = len(retrieved_ids & relevant_ids) / len(relevant_ids)

        metrics["retrieval_precision"].append(precision)
        metrics["retrieval_recall"].append(recall)

        # Use LLM-as-judge for quality metrics
        quality = await evaluate_answer_quality(
            question=test["question"],
            answer=result["answer"],
            context=result["context"],
            expected=test.get("expected_answer")
        )
        metrics["answer_relevance"].append(quality["relevance"])
        metrics["faithfulness"].append(quality["faithfulness"])
        metrics["context_relevance"].append(quality["context_relevance"])

    return {k: sum(v) / len(v) for k, v in metrics.items()}
```

## Resources

- [LangChain RAG Tutorial](https://python.langchain.com/docs/tutorials/rag/)
- [LangGraph RAG Examples](https://langchain-ai.github.io/langgraph/tutorials/rag/)
- [Pinecone Best Practices](https://docs.pinecone.io/guides/get-started/overview)
- [Voyage AI Embeddings](https://docs.voyageai.com/)
- [RAG Evaluation Guide](https://docs.ragas.io/)

## Best Practices

1. **Chunk Size**: Balance between context (larger) and specificity (smaller) - typically 500-1000 tokens
2. **Overlap**: Use 10-20% overlap to preserve context at boundaries
3. **Metadata**: Include source, page, timestamp for filtering and debugging
4. **Hybrid Search**: Combine semantic and keyword search for best recall
5. **Reranking**: Use cross-encoder reranking for precision-critical applications
6. **Citations**: Always return source documents for transparency
7. **Evaluation**: Continuously test retrieval quality and answer accuracy
8. **Monitoring**: Track retrieval metrics and latency in production

## Common Issues

- **Poor Retrieval**: Check embedding quality, chunk size, query formulation
- **Irrelevant Results**: Add metadata filtering, use hybrid search, rerank
- **Missing Information**: Ensure documents are properly indexed, check chunking
- **Slow Queries**: Optimize vector store, use caching, reduce k
- **Hallucinations**: Improve grounding prompt, add verification step
- **Context Too Long**: Use compression or parent document retriever

## Similarity Search Patterns

# Similarity Search Patterns

Patterns for implementing efficient similarity search in production systems.

## When to Use This Skill

- Building semantic search systems
- Implementing RAG retrieval
- Creating recommendation engines
- Optimizing search latency
- Scaling to millions of vectors
- Combining semantic and keyword search

## Core Concepts

### 1. Distance Metrics

| Metric             | Formula            | Best For              |
| ------------------ | ------------------ | --------------------- | --- | -------------- |
| **Cosine**         | 1 - (A·B)/(‖A‖‖B‖) | Normalized embeddings |
| **Euclidean (L2)** | √Σ(a-b)²           | Raw embeddings        |
| **Dot Product**    | A·B                | Magnitude matters     |
| **Manhattan (L1)** | Σ                  | a-b                   |     | Sparse vectors |

### 2. Index Types

```
┌─────────────────────────────────────────────────┐
│                 Index Types                      │
├─────────────┬───────────────┬───────────────────┤
│    Flat     │     HNSW      │    IVF+PQ         │
│ (Exact)     │ (Graph-based) │ (Quantized)       │
├─────────────┼───────────────┼───────────────────┤
│ O(n) search │ O(log n)      │ O(√n)             │
│ 100% recall │ ~95-99%       │ ~90-95%           │
│ Small data  │ Medium-Large  │ Very Large        │
└─────────────┴───────────────┴───────────────────┘
```

## Templates

### Template 1: Pinecone Implementation

```python
from pinecone import Pinecone, ServerlessSpec
from typing import List, Dict, Optional
import hashlib

class PineconeVectorStore:
    def __init__(
        self,
        api_key: str,
        index_name: str,
        dimension: int = 1536,
        metric: str = "cosine"
    ):
        self.pc = Pinecone(api_key=api_key)

        # Create index if not exists
        if index_name not in self.pc.list_indexes().names():
            self.pc.create_index(
                name=index_name,
                dimension=dimension,
                metric=metric,
                spec=ServerlessSpec(cloud="aws", region="us-east-1")
            )

        self.index = self.pc.Index(index_name)

    def upsert(
        self,
        vectors: List[Dict],
        namespace: str = ""
    ) -> int:
        """
        Upsert vectors.
        vectors: [{"id": str, "values": List[float], "metadata": dict}]
        """
        # Batch upsert
        batch_size = 100
        total = 0

        for i in range(0, len(vectors), batch_size):
            batch = vectors[i:i + batch_size]
            self.index.upsert(vectors=batch, namespace=namespace)
            total += len(batch)

        return total

    def search(
        self,
        query_vector: List[float],
        top_k: int = 10,
        namespace: str = "",
        filter: Optional[Dict] = None,
        include_metadata: bool = True
    ) -> List[Dict]:
        """Search for similar vectors."""
        results = self.index.query(
            vector=query_vector,
            top_k=top_k,
            namespace=namespace,
            filter=filter,
            include_metadata=include_metadata
        )

        return [
            {
                "id": match.id,
                "score": match.score,
                "metadata": match.metadata
            }
            for match in results.matches
        ]

    def search_with_rerank(
        self,
        query: str,
        query_vector: List[float],
        top_k: int = 10,
        rerank_top_n: int = 50,
        namespace: str = ""
    ) -> List[Dict]:
        """Search and rerank results."""
        # Over-fetch for reranking
        initial_results = self.search(
            query_vector,
            top_k=rerank_top_n,
            namespace=namespace
        )

        # Rerank with cross-encoder or LLM
        reranked = self._rerank(query, initial_results)

        return reranked[:top_k]

    def _rerank(self, query: str, results: List[Dict]) -> List[Dict]:
        """Rerank results using cross-encoder."""
        from sentence_transformers import CrossEncoder

        model = CrossEncoder('cross-encoder/ms-marco-MiniLM-L-6-v2')

        pairs = [(query, r["metadata"]["text"]) for r in results]
        scores = model.predict(pairs)

        for result, score in zip(results, scores):
            result["rerank_score"] = float(score)

        return sorted(results, key=lambda x: x["rerank_score"], reverse=True)

    def delete(self, ids: List[str], namespace: str = ""):
        """Delete vectors by ID."""
        self.index.delete(ids=ids, namespace=namespace)

    def delete_by_filter(self, filter: Dict, namespace: str = ""):
        """Delete vectors matching filter."""
        self.index.delete(filter=filter, namespace=namespace)
```

### Template 2: Qdrant Implementation

```python
from qdrant_client import QdrantClient
from qdrant_client.http import models
from typing import List, Dict, Optional

class QdrantVectorStore:
    def __init__(
        self,
        url: str = "localhost",
        port: int = 6333,
        collection_name: str = "documents",
        vector_size: int = 1536
    ):
        self.client = QdrantClient(url=url, port=port)
        self.collection_name = collection_name

        # Create collection if not exists
        collections = self.client.get_collections().collections
        if collection_name not in [c.name for c in collections]:
            self.client.create_collection(
                collection_name=collection_name,
                vectors_config=models.VectorParams(
                    size=vector_size,
                    distance=models.Distance.COSINE
                ),
                # Optional: enable quantization for memory efficiency
                quantization_config=models.ScalarQuantization(
                    scalar=models.ScalarQuantizationConfig(
                        type=models.ScalarType.INT8,
                        quantile=0.99,
                        always_ram=True
                    )
                )
            )

    def upsert(self, points: List[Dict]) -> int:
        """
        Upsert points.
        points: [{"id": str/int, "vector": List[float], "payload": dict}]
        """
        qdrant_points = [
            models.PointStruct(
                id=p["id"],
                vector=p["vector"],
                payload=p.get("payload", {})
            )
            for p in points
        ]

        self.client.upsert(
            collection_name=self.collection_name,
            points=qdrant_points
        )
        return len(points)

    def search(
        self,
        query_vector: List[float],
        limit: int = 10,
        filter: Optional[models.Filter] = None,
        score_threshold: Optional[float] = None
    ) -> List[Dict]:
        """Search for similar vectors."""
        results = self.client.search(
            collection_name=self.collection_name,
            query_vector=query_vector,
            limit=limit,
            query_filter=filter,
            score_threshold=score_threshold
        )

        return [
            {
                "id": r.id,
                "score": r.score,
                "payload": r.payload
            }
            for r in results
        ]

    def search_with_filter(
        self,
        query_vector: List[float],
        must_conditions: List[Dict] = None,
        should_conditions: List[Dict] = None,
        must_not_conditions: List[Dict] = None,
        limit: int = 10
    ) -> List[Dict]:
        """Search with complex filters."""
        conditions = []

        if must_conditions:
            conditions.extend([
                models.FieldCondition(
                    key=c["key"],
                    match=models.MatchValue(value=c["value"])
                )
                for c in must_conditions
            ])

        filter = models.Filter(must=conditions) if conditions else None

        return self.search(query_vector, limit=limit, filter=filter)

    def search_with_sparse(
        self,
        dense_vector: List[float],
        sparse_vector: Dict[int, float],
        limit: int = 10,
        dense_weight: float = 0.7
    ) -> List[Dict]:
        """Hybrid search with dense and sparse vectors."""
        # Requires collection with named vectors
        results = self.client.search(
            collection_name=self.collection_name,
            query_vector=models.NamedVector(
                name="dense",
                vector=dense_vector
            ),
            limit=limit
        )
        return [{"id": r.id, "score": r.score, "payload": r.payload} for r in results]
```

### Template 3: pgvector with PostgreSQL

```python
import asyncpg
from typing import List, Dict, Optional
import numpy as np

class PgVectorStore:
    def __init__(self, connection_string: str):
        self.connection_string = connection_string

    async def init(self):
        """Initialize connection pool and extension."""
        self.pool = await asyncpg.create_pool(self.connection_string)

        async with self.pool.acquire() as conn:
            # Enable extension
            await conn.execute("CREATE EXTENSION IF NOT EXISTS vector")

            # Create table
            await conn.execute("""
                CREATE TABLE IF NOT EXISTS documents (
                    id TEXT PRIMARY KEY,
                    content TEXT,
                    metadata JSONB,
                    embedding vector(1536)
                )
            """)

            # Create index (HNSW for better performance)
            await conn.execute("""
                CREATE INDEX IF NOT EXISTS documents_embedding_idx
                ON documents
                USING hnsw (embedding vector_cosine_ops)
                WITH (m = 16, ef_construction = 64)
            """)

    async def upsert(self, documents: List[Dict]):
        """Upsert documents with embeddings."""
        async with self.pool.acquire() as conn:
            await conn.executemany(
                """
                INSERT INTO documents (id, content, metadata, embedding)
                VALUES ($1, $2, $3, $4)
                ON CONFLICT (id) DO UPDATE SET
                    content = EXCLUDED.content,
                    metadata = EXCLUDED.metadata,
                    embedding = EXCLUDED.embedding
                """,
                [
                    (
                        doc["id"],
                        doc["content"],
                        doc.get("metadata", {}),
                        np.array(doc["embedding"]).tolist()
                    )
                    for doc in documents
                ]
            )

    async def search(
        self,
        query_embedding: List[float],
        limit: int = 10,
        filter_metadata: Optional[Dict] = None
    ) -> List[Dict]:
        """Search for similar documents."""
        query = """
            SELECT id, content, metadata,
                   1 - (embedding <=> $1::vector) as similarity
            FROM documents
        """

        params = [query_embedding]

        if filter_metadata:
            conditions = []
            for key, value in filter_metadata.items():
                params.append(value)
                conditions.append(f"metadata->>'{key}' = ${len(params)}")
            query += " WHERE " + " AND ".join(conditions)

        query += f" ORDER BY embedding <=> $1::vector LIMIT ${len(params) + 1}"
        params.append(limit)

        async with self.pool.acquire() as conn:
            rows = await conn.fetch(query, *params)

        return [
            {
                "id": row["id"],
                "content": row["content"],
                "metadata": row["metadata"],
                "score": row["similarity"]
            }
            for row in rows
        ]

    async def hybrid_search(
        self,
        query_embedding: List[float],
        query_text: str,
        limit: int = 10,
        vector_weight: float = 0.5
    ) -> List[Dict]:
        """Hybrid search combining vector and full-text."""
        async with self.pool.acquire() as conn:
            rows = await conn.fetch(
                """
                WITH vector_results AS (
                    SELECT id, content, metadata,
                           1 - (embedding <=> $1::vector) as vector_score
                    FROM documents
                    ORDER BY embedding <=> $1::vector
                    LIMIT $3 * 2
                ),
                text_results AS (
                    SELECT id, content, metadata,
                           ts_rank(to_tsvector('english', content),
                                   plainto_tsquery('english', $2)) as text_score
                    FROM documents
                    WHERE to_tsvector('english', content) @@ plainto_tsquery('english', $2)
                    LIMIT $3 * 2
                )
                SELECT
                    COALESCE(v.id, t.id) as id,
                    COALESCE(v.content, t.content) as content,
                    COALESCE(v.metadata, t.metadata) as metadata,
                    COALESCE(v.vector_score, 0) * $4 +
                    COALESCE(t.text_score, 0) * (1 - $4) as combined_score
                FROM vector_results v
                FULL OUTER JOIN text_results t ON v.id = t.id
                ORDER BY combined_score DESC
                LIMIT $3
                """,
                query_embedding, query_text, limit, vector_weight
            )

        return [dict(row) for row in rows]
```

### Template 4: Weaviate Implementation

```python
import weaviate
from weaviate.util import generate_uuid5
from typing import List, Dict, Optional

class WeaviateVectorStore:
    def __init__(
        self,
        url: str = "http://localhost:8080",
        class_name: str = "Document"
    ):
        self.client = weaviate.Client(url=url)
        self.class_name = class_name
        self._ensure_schema()

    def _ensure_schema(self):
        """Create schema if not exists."""
        schema = {
            "class": self.class_name,
            "vectorizer": "none",  # We provide vectors
            "properties": [
                {"name": "content", "dataType": ["text"]},
                {"name": "source", "dataType": ["string"]},
                {"name": "chunk_id", "dataType": ["int"]}
            ]
        }

        if not self.client.schema.exists(self.class_name):
            self.client.schema.create_class(schema)

    def upsert(self, documents: List[Dict]):
        """Batch upsert documents."""
        with self.client.batch as batch:
            batch.batch_size = 100

            for doc in documents:
                batch.add_data_object(
                    data_object={
                        "content": doc["content"],
                        "source": doc.get("source", ""),
                        "chunk_id": doc.get("chunk_id", 0)
                    },
                    class_name=self.class_name,
                    uuid=generate_uuid5(doc["id"]),
                    vector=doc["embedding"]
                )

    def search(
        self,
        query_vector: List[float],
        limit: int = 10,
        where_filter: Optional[Dict] = None
    ) -> List[Dict]:
        """Vector search."""
        query = (
            self.client.query
            .get(self.class_name, ["content", "source", "chunk_id"])
            .with_near_vector({"vector": query_vector})
            .with_limit(limit)
            .with_additional(["distance", "id"])
        )

        if where_filter:
            query = query.with_where(where_filter)

        results = query.do()

        return [
            {
                "id": item["_additional"]["id"],
                "content": item["content"],
                "source": item["source"],
                "score": 1 - item["_additional"]["distance"]
            }
            for item in results["data"]["Get"][self.class_name]
        ]

    def hybrid_search(
        self,
        query: str,
        query_vector: List[float],
        limit: int = 10,
        alpha: float = 0.5  # 0 = keyword, 1 = vector
    ) -> List[Dict]:
        """Hybrid search combining BM25 and vector."""
        results = (
            self.client.query
            .get(self.class_name, ["content", "source"])
            .with_hybrid(query=query, vector=query_vector, alpha=alpha)
            .with_limit(limit)
            .with_additional(["score"])
            .do()
        )

        return [
            {
                "content": item["content"],
                "source": item["source"],
                "score": item["_additional"]["score"]
            }
            for item in results["data"]["Get"][self.class_name]
        ]
```

## Best Practices

### Do's

- **Use appropriate index** - HNSW for most cases
- **Tune parameters** - ef_search, nprobe for recall/speed
- **Implement hybrid search** - Combine with keyword search
- **Monitor recall** - Measure search quality
- **Pre-filter when possible** - Reduce search space

### Don'ts

- **Don't skip evaluation** - Measure before optimizing
- **Don't over-index** - Start with flat, scale up
- **Don't ignore latency** - P99 matters for UX
- **Don't forget costs** - Vector storage adds up

## Resources

- [Pinecone Docs](https://docs.pinecone.io/)
- [Qdrant Docs](https://qdrant.tech/documentation/)
- [pgvector](https://github.com/pgvector/pgvector)
- [Weaviate Docs](https://weaviate.io/developers/weaviate)

## Vector Index Tuning

# Vector Index Tuning

Guide to optimizing vector indexes for production performance.

## When to Use This Skill

- Tuning HNSW parameters
- Implementing quantization
- Optimizing memory usage
- Reducing search latency
- Balancing recall vs speed
- Scaling to billions of vectors

## Core Concepts

### 1. Index Type Selection

```
Data Size           Recommended Index
────────────────────────────────────────
< 10K vectors  →    Flat (exact search)
10K - 1M       →    HNSW
1M - 100M      →    HNSW + Quantization
> 100M         →    IVF + PQ or DiskANN
```

### 2. HNSW Parameters

| Parameter          | Default | Effect                                               |
| ------------------ | ------- | ---------------------------------------------------- |
| **M**              | 16      | Connections per node, ↑ = better recall, more memory |
| **efConstruction** | 100     | Build quality, ↑ = better index, slower build        |
| **efSearch**       | 50      | Search quality, ↑ = better recall, slower search     |

### 3. Quantization Types

```
Full Precision (FP32): 4 bytes × dimensions
Half Precision (FP16): 2 bytes × dimensions
INT8 Scalar:           1 byte × dimensions
Product Quantization:  ~32-64 bytes total
Binary:                dimensions/8 bytes
```

## Templates

### Template 1: HNSW Parameter Tuning

```python
import numpy as np
from typing import List, Tuple
import time

def benchmark_hnsw_parameters(
    vectors: np.ndarray,
    queries: np.ndarray,
    ground_truth: np.ndarray,
    m_values: List[int] = [8, 16, 32, 64],
    ef_construction_values: List[int] = [64, 128, 256],
    ef_search_values: List[int] = [32, 64, 128, 256]
) -> List[dict]:
    """Benchmark different HNSW configurations."""
    import hnswlib

    results = []
    dim = vectors.shape[1]
    n = vectors.shape[0]

    for m in m_values:
        for ef_construction in ef_construction_values:
            # Build index
            index = hnswlib.Index(space='cosine', dim=dim)
            index.init_index(max_elements=n, M=m, ef_construction=ef_construction)

            build_start = time.time()
            index.add_items(vectors)
            build_time = time.time() - build_start

            # Get memory usage
            memory_bytes = index.element_count * (
                dim * 4 +  # Vector storage
                m * 2 * 4  # Graph edges (approximate)
            )

            for ef_search in ef_search_values:
                index.set_ef(ef_search)

                # Measure search
                search_start = time.time()
                labels, distances = index.knn_query(queries, k=10)
                search_time = time.time() - search_start

                # Calculate recall
                recall = calculate_recall(labels, ground_truth, k=10)

                results.append({
                    "M": m,
                    "ef_construction": ef_construction,
                    "ef_search": ef_search,
                    "build_time_s": build_time,
                    "search_time_ms": search_time * 1000 / len(queries),
                    "recall@10": recall,
                    "memory_mb": memory_bytes / 1024 / 1024
                })

    return results


def calculate_recall(predictions: np.ndarray, ground_truth: np.ndarray, k: int) -> float:
    """Calculate recall@k."""
    correct = 0
    for pred, truth in zip(predictions, ground_truth):
        correct += len(set(pred[:k]) & set(truth[:k]))
    return correct / (len(predictions) * k)


def recommend_hnsw_params(
    num_vectors: int,
    target_recall: float = 0.95,
    max_latency_ms: float = 10,
    available_memory_gb: float = 8
) -> dict:
    """Recommend HNSW parameters based on requirements."""

    # Base recommendations
    if num_vectors < 100_000:
        m = 16
        ef_construction = 100
    elif num_vectors < 1_000_000:
        m = 32
        ef_construction = 200
    else:
        m = 48
        ef_construction = 256

    # Adjust ef_search based on recall target
    if target_recall >= 0.99:
        ef_search = 256
    elif target_recall >= 0.95:
        ef_search = 128
    else:
        ef_search = 64

    return {
        "M": m,
        "ef_construction": ef_construction,
        "ef_search": ef_search,
        "notes": f"Estimated for {num_vectors:,} vectors, {target_recall:.0%} recall"
    }
```

### Template 2: Quantization Strategies

```python
import numpy as np
from typing import Optional

class VectorQuantizer:
    """Quantization strategies for vector compression."""

    @staticmethod
    def scalar_quantize_int8(
        vectors: np.ndarray,
        min_val: Optional[float] = None,
        max_val: Optional[float] = None
    ) -> Tuple[np.ndarray, dict]:
        """Scalar quantization to INT8."""
        if min_val is None:
            min_val = vectors.min()
        if max_val is None:
            max_val = vectors.max()

        # Scale to 0-255 range
        scale = 255.0 / (max_val - min_val)
        quantized = np.clip(
            np.round((vectors - min_val) * scale),
            0, 255
        ).astype(np.uint8)

        params = {"min_val": min_val, "max_val": max_val, "scale": scale}
        return quantized, params

    @staticmethod
    def dequantize_int8(
        quantized: np.ndarray,
        params: dict
    ) -> np.ndarray:
        """Dequantize INT8 vectors."""
        return quantized.astype(np.float32) / params["scale"] + params["min_val"]

    @staticmethod
    def product_quantize(
        vectors: np.ndarray,
        n_subvectors: int = 8,
        n_centroids: int = 256
    ) -> Tuple[np.ndarray, dict]:
        """Product quantization for aggressive compression."""
        from sklearn.cluster import KMeans

        n, dim = vectors.shape
        assert dim % n_subvectors == 0
        subvector_dim = dim // n_subvectors

        codebooks = []
        codes = np.zeros((n, n_subvectors), dtype=np.uint8)

        for i in range(n_subvectors):
            start = i * subvector_dim
            end = (i + 1) * subvector_dim
            subvectors = vectors[:, start:end]

            kmeans = KMeans(n_clusters=n_centroids, random_state=42)
            codes[:, i] = kmeans.fit_predict(subvectors)
            codebooks.append(kmeans.cluster_centers_)

        params = {
            "codebooks": codebooks,
            "n_subvectors": n_subvectors,
            "subvector_dim": subvector_dim
        }
        return codes, params

    @staticmethod
    def binary_quantize(vectors: np.ndarray) -> np.ndarray:
        """Binary quantization (sign of each dimension)."""
        # Convert to binary: positive = 1, negative = 0
        binary = (vectors > 0).astype(np.uint8)

        # Pack bits into bytes
        n, dim = vectors.shape
        packed_dim = (dim + 7) // 8

        packed = np.zeros((n, packed_dim), dtype=np.uint8)
        for i in range(dim):
            byte_idx = i // 8
            bit_idx = i % 8
            packed[:, byte_idx] |= (binary[:, i] << bit_idx)

        return packed


def estimate_memory_usage(
    num_vectors: int,
    dimensions: int,
    quantization: str = "fp32",
    index_type: str = "hnsw",
    hnsw_m: int = 16
) -> dict:
    """Estimate memory usage for different configurations."""

    # Vector storage
    bytes_per_dimension = {
        "fp32": 4,
        "fp16": 2,
        "int8": 1,
        "pq": 0.05,  # Approximate
        "binary": 0.125
    }

    vector_bytes = num_vectors * dimensions * bytes_per_dimension[quantization]

    # Index overhead
    if index_type == "hnsw":
        # Each node has ~M*2 edges, each edge is 4 bytes (int32)
        index_bytes = num_vectors * hnsw_m * 2 * 4
    elif index_type == "ivf":
        # Inverted lists + centroids
        index_bytes = num_vectors * 8 + 65536 * dimensions * 4
    else:
        index_bytes = 0

    total_bytes = vector_bytes + index_bytes

    return {
        "vector_storage_mb": vector_bytes / 1024 / 1024,
        "index_overhead_mb": index_bytes / 1024 / 1024,
        "total_mb": total_bytes / 1024 / 1024,
        "total_gb": total_bytes / 1024 / 1024 / 1024
    }
```

### Template 3: Qdrant Index Configuration

```python
from qdrant_client import QdrantClient
from qdrant_client.http import models

def create_optimized_collection(
    client: QdrantClient,
    collection_name: str,
    vector_size: int,
    num_vectors: int,
    optimize_for: str = "balanced"  # "recall", "speed", "memory"
) -> None:
    """Create collection with optimized settings."""

    # HNSW configuration based on optimization target
    hnsw_configs = {
        "recall": models.HnswConfigDiff(m=32, ef_construct=256),
        "speed": models.HnswConfigDiff(m=16, ef_construct=64),
        "balanced": models.HnswConfigDiff(m=16, ef_construct=128),
        "memory": models.HnswConfigDiff(m=8, ef_construct=64)
    }

    # Quantization configuration
    quantization_configs = {
        "recall": None,  # No quantization for max recall
        "speed": models.ScalarQuantization(
            scalar=models.ScalarQuantizationConfig(
                type=models.ScalarType.INT8,
                quantile=0.99,
                always_ram=True
            )
        ),
        "balanced": models.ScalarQuantization(
            scalar=models.ScalarQuantizationConfig(
                type=models.ScalarType.INT8,
                quantile=0.99,
                always_ram=False
            )
        ),
        "memory": models.ProductQuantization(
            product=models.ProductQuantizationConfig(
                compression=models.CompressionRatio.X16,
                always_ram=False
            )
        )
    }

    # Optimizer configuration
    optimizer_configs = {
        "recall": models.OptimizersConfigDiff(
            indexing_threshold=10000,
            memmap_threshold=50000
        ),
        "speed": models.OptimizersConfigDiff(
            indexing_threshold=5000,
            memmap_threshold=20000
        ),
        "balanced": models.OptimizersConfigDiff(
            indexing_threshold=20000,
            memmap_threshold=50000
        ),
        "memory": models.OptimizersConfigDiff(
            indexing_threshold=50000,
            memmap_threshold=10000  # Use disk sooner
        )
    }

    client.create_collection(
        collection_name=collection_name,
        vectors_config=models.VectorParams(
            size=vector_size,
            distance=models.Distance.COSINE
        ),
        hnsw_config=hnsw_configs[optimize_for],
        quantization_config=quantization_configs[optimize_for],
        optimizers_config=optimizer_configs[optimize_for]
    )


def tune_search_parameters(
    client: QdrantClient,
    collection_name: str,
    target_recall: float = 0.95
) -> dict:
    """Tune search parameters for target recall."""

    # Search parameter recommendations
    if target_recall >= 0.99:
        search_params = models.SearchParams(
            hnsw_ef=256,
            exact=False,
            quantization=models.QuantizationSearchParams(
                ignore=True,  # Don't use quantization for search
                rescore=True
            )
        )
    elif target_recall >= 0.95:
        search_params = models.SearchParams(
            hnsw_ef=128,
            exact=False,
            quantization=models.QuantizationSearchParams(
                ignore=False,
                rescore=True,
                oversampling=2.0
            )
        )
    else:
        search_params = models.SearchParams(
            hnsw_ef=64,
            exact=False,
            quantization=models.QuantizationSearchParams(
                ignore=False,
                rescore=False
            )
        )

    return search_params
```

### Template 4: Performance Monitoring

```python
import time
from dataclasses import dataclass
from typing import List
import numpy as np

@dataclass
class SearchMetrics:
    latency_p50_ms: float
    latency_p95_ms: float
    latency_p99_ms: float
    recall: float
    qps: float


class VectorSearchMonitor:
    """Monitor vector search performance."""

    def __init__(self, ground_truth_fn=None):
        self.latencies = []
        self.recalls = []
        self.ground_truth_fn = ground_truth_fn

    def measure_search(
        self,
        search_fn,
        query_vectors: np.ndarray,
        k: int = 10,
        num_iterations: int = 100
    ) -> SearchMetrics:
        """Benchmark search performance."""
        latencies = []

        for _ in range(num_iterations):
            for query in query_vectors:
                start = time.perf_counter()
                results = search_fn(query, k=k)
                latency = (time.perf_counter() - start) * 1000
                latencies.append(latency)

        latencies = np.array(latencies)
        total_queries = num_iterations * len(query_vectors)
        total_time = sum(latencies) / 1000  # seconds

        return SearchMetrics(
            latency_p50_ms=np.percentile(latencies, 50),
            latency_p95_ms=np.percentile(latencies, 95),
            latency_p99_ms=np.percentile(latencies, 99),
            recall=self._calculate_recall(search_fn, query_vectors, k) if self.ground_truth_fn else 0,
            qps=total_queries / total_time
        )

    def _calculate_recall(self, search_fn, queries: np.ndarray, k: int) -> float:
        """Calculate recall against ground truth."""
        if not self.ground_truth_fn:
            return 0

        correct = 0
        total = 0

        for query in queries:
            predicted = set(search_fn(query, k=k))
            actual = set(self.ground_truth_fn(query, k=k))
            correct += len(predicted & actual)
            total += k

        return correct / total


def profile_index_build(
    build_fn,
    vectors: np.ndarray,
    batch_sizes: List[int] = [1000, 10000, 50000]
) -> dict:
    """Profile index build performance."""
    results = {}

    for batch_size in batch_sizes:
        times = []
        for i in range(0, len(vectors), batch_size):
            batch = vectors[i:i + batch_size]
            start = time.perf_counter()
            build_fn(batch)
            times.append(time.perf_counter() - start)

        results[batch_size] = {
            "avg_batch_time_s": np.mean(times),
            "vectors_per_second": batch_size / np.mean(times)
        }

    return results
```

## Best Practices

### Do's

- **Benchmark with real queries** - Synthetic may not represent production
- **Monitor recall continuously** - Can degrade with data drift
- **Start with defaults** - Tune only when needed
- **Use quantization** - Significant memory savings
- **Consider tiered storage** - Hot/cold data separation

### Don'ts

- **Don't over-optimize early** - Profile first
- **Don't ignore build time** - Index updates have cost
- **Don't forget reindexing** - Plan for maintenance
- **Don't skip warming** - Cold indexes are slow

## Resources

- [HNSW Paper](https://arxiv.org/abs/1603.09320)
- [Faiss Wiki](https://github.com/facebookresearch/faiss/wiki)
- [ANN Benchmarks](https://ann-benchmarks.com/)
