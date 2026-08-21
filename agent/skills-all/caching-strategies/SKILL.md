---
name: caching-strategies
description: Design caching — HTTP cache headers, CDN, Redis, invalidation strategies, cache-aside, write-through, stampede prevention.
category: Backend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Caching Strategies

## Layers (from edge to app)
1. **HTTP/CDN**: `Cache-Control: public, max-age=3600, s-maxage` on cacheable GETs; `Vary` on content varies; CDN in front. Only public/static or per-user sessions with cookie-key partitioning done carefully.
2. **In-process**: hot read-through for read-heavy single-instance data (config, dicts) — memory only, restart-clears, keep small.
3. **Redis**: shared app-level cache (feeds, counters, sessions, rate-limit). Use it deliberately: every cache entry = invalidation debt.

## Patterns
- **Cache-aside** (default): read cache → miss → DB → write cache TTL. Fragile to stale; pair with explicit invalidation on writes.
- **Write-through/write-behind**: write DB + cache together (or queue) — consistent but slower writes; write-behind loses on crash (acceptable for counters, not orders).
- **Read-update TTL** (refresh on read when old): for high-churn items (leaderboards) — `TTL 60s + max-age refresh` reduces stampede.
- Invalidation: on every mutation of the underlying row — `keys: user:{id}` granular + `tags` (cache tags) to invalidate a class (`posts`, `user:5:posts`) in one pass (Redis: SET of tag→keys).

## Stampede prevention
- Single-flight: one process fetches, others await (in-process promise dedupe or Redlock+SETNX with TTL).
- Jitter TTLs (±10%) so expiry doesn't sync; staggered expiries for lists.

## Rules of thumb
- Cache only what read ≫ written and slightly-stale-ok (profile, catalog, counters). Never cache: auth decisions, per-request user state without key, multi-tenant rows keyed by partner (partition keys).
- Every entry: key scheme documented + TTL + invalidation trigger. Orphan keys = drift bugs; TTL alone masks it.
- Metrics: hit-rate, miss latency, invalidation volume — a sinking hit-rate means config drift.

## Checklist
- [ ] Cache headers on cacheable routes; Vary correct
- [ ] TTL + invalidation for every entry
- [ ] Stampede protection on hot keys
- [ ] Never caching auth/volatile state
- [ ] Hit-rate monitored