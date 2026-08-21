---
name: redis-caching
description: Use Redis correctly — data structures, TTL discipline, pub/sub, rate limiting, anti-patterns, persistence.
category: Database
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Redis

## What it's for (and not)
Redis = in-memory structures, not a durable datastore. Use: cache (backing `caching-strategies`), sessions, queues (BRPOPLPUSH/streams), pub/sub, rate-limiter, distributed locks, leaderboards, ephemeral state. Never: long-term truth (eviction/restart loses), relational modeling, multi-GB query data unless strictly cache-tier.

## Data structures (pick the right one)
- `SET` / `GET SET` — flags, tokens; `SET key val NX EX 30` — lock/token.
- `HASH` — objects (user profile, config), field-level ops `HINCRBY`.
- `LIST` (LPUSH/BRPOP) — job queues w/ blocking pop.
- `SET`/`ZSET` — dedupe, membership; **ZSET** for leaderboards, pagination by score, time-window events (`ZADD ts`, `ZRANGEBYSCORE`).
- `STREAMS` (5+) — append logs, consumer groups w/ acks (superior to LIST queues for ack/retry).
- `INCR`/`INCRBY` + `EXPIRE` — counters, rate limits; `INCRBYFLOAT` for currencies.

## Discipline
- **Every key needs TTL** except deliberate permanent (config). Naming: `app:entity:id:attr`.
- Key cardinality: never one key per user for small data — HASH per entity bounded size; per-user fingerprint keys (session) OK, swept by TTL.
- Pipeline/MULTI for batch ops (round-trip cost), Lua scripts for atomic compound ops.
- Pub/sub: fire-and-forget, no persistence — use for fan-out presence; STREAMS if delivery matters.
- Memory: monitor `maxmemory` eviction policy (`allkeys-lru` ok for cache; `noeviction` for locks/counters or data disappears mid-flight), `MEMORY USAGE key` metrics; big keys block — split.

## Failure patterns
- Incorrect `EX`/`PX` usage (locks expire early/late); `GETSET` vs incr race; cache keys lacking invalidation path (stale forever); rate limit counters evicted mid-window; hot keys (one celebrity id) — local replica read or key-sharding.

## Persistence & HA
- AOF on (appendfsync everysec) or accept cache-loss; RDB snapshots for warm restart; Sentinel/Cluster ready; client timeouts + reconnect backoff.

## Checklist
- [ ] TTL everywhere it should be
- [ ] Right structure per access (zset vs list vs hash)
- [ ] No source-of-truth misuse
- [ ] Eviction policy deliberate
- [ ] Pipeline multi-op; Lua for atomic