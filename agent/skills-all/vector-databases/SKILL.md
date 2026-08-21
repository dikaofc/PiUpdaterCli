---
name: vector-databases
description: Use vector databases for embeddings/search — RAG design, indexing, retrieval quality, hybrid search, tradeoffs.
category: Data & AI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Vector Databases / RAG

## When vectors
- Semantic search (docs, code, products), RAG retrieval, dedupe/clustering, recommendations. Not for: exact-match, aggregations (use normal DB), or when keyword search suffices (start there!).

## Design (RAG flow)
- Chunk: split by semantic unit (headers/paragraphs), 300-800 tokens, overlap 10-15%; chunking strategy matters more than embedding model for small corpora.
- Embed: single model consistently (never mix); store vector + metadata (source, section, timestamp, permissions!) in same row.
- Index: HNSW (recall/speed tradeoff — M=16, efConstruction=200 typical); IVF for cost; keep index fresh (incremental updates or rebuild job).

## Retrieval quality (the RAG bottleneck)
- **Hybrid search** wins: BM25 keyword + vector, fused (RRF) — pure vector misses exact ids/acronyms.
- Filter first (metadata: tenant, date, type) — reduces noise + enforces permissions (vector DB authz is thin — always filter).
- Rerank: cross-encoder on top-20 (quality jump) when cost allows; query rewriting (expand acronyms, synonyms) optional.
- Score tuning: similarity threshold calibrated on your corpus (golden set), not the docs' default.

## Evaluation
- Golden set: 30-100 (query → relevant doc ids) — metrics: recall@5/10, MRR; run on every retrieval-config change (CI).
- End-to-end: answer-groundedness (hallucination check) on generated answers; context-position bias noted.

## Storage options
- Managed: pgvector (Postgres, zero new infra — enough for most), Qdrant/Weaviate/Milvus standalone, cloud (Pinecone), or in-DB (SQLite-vec, Redis module). Pick by scale + ops budget; avoid dedicated cluster until > 10M vectors.

## Operational
- Embedding cost per reindex — delta updates with backfill job; vector size memory planning (float32 → int8 quantized ×4 memory cut); monitor recall drift monthly.

## Checklist
- [ ] Chunking tuned; metadata + permissions stored
- [ ] Hybrid (BM25+vector) retrieval
- [ ] Threshold calibrated; reranker where cost fits
- [ ] Golden-set eval wired into CI
- [ ] Storage scaled by vectors count, not hype