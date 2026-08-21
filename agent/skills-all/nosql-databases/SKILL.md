---
name: nosql-databases
description: Choose and use NoSQL stores — document, key-value, wide-column, search engines; consistency, access patterns, anti-patterns.
category: Database
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# NoSQL Databases

## Which when (decide by access pattern, not hype)
- **Document (MongoDB/Couchbase/Firestore)**: schemaless-ish, embedded subdocuments for read-shaped aggregates, geo/time-series-ish data. Not for: multi-entity relational integrity, heavy joins (design denormalized or quit).
- **Key-value (Redis)**: caches, sessions, counters, leaderboards, ephemeral state — by definition single-key access; no queries (except scan which you avoid).
- **Wide-column (Cassandra/Scylla)**: write-heavy time-series/event logs, partition by natural key (tenant+time); queries must match partition design — no ad-hoc queries, no joins.
- **Search (Elasticsearch/OpenSearch/Meilisearch)**: full-text, faceted filters, typo tolerance. Not a source of truth — index from the primary DB (log-structured, eventually eventual).
- **Edge (DynamoDB)**: serverless scale, but access-pattern-locked (design-time modeling) — serious lock-in tradeoff.

## Consistency reality
- Multi-document transactions: Mongo 4.4+/Dynamo transact — limited; design for single-document atomicity first (embed vs reference decision).
- Eventual consistency: read-your-writes missing → app-level: session affinity, quorum reads (W+R > N), or accept by design (counts, feeds) and label it.
- **Every read that must be strict-consistent = relational → don't use NoSQL for it.**

## Anti-patterns
- Schemaless drift: no validation layer → garbage in; add JSON Schema/mongoose-style validators.
- Unbounded documents (arrays that grow forever) — cap or move to child collection.
- Hot partitions: timestamp-as-PK writes all hit one node — salt or partition by hash.
- Cross-collection joins in app loops (N+1 in NoSQL clothing).
- Using Redis as source of truth (lose data on eviction/restart).
- Embedded everything → document bloat; embed only read-together data.

## Checklist
- [ ] Access patterns dictate store choice
- [ ] Single-entity atomicity where possible
- [ ] Validation layer on writes
- [ ] Bounded document/array growth
- [ ] Consistency requirement mapped: strict → SQL