---
name: caching
description: Add caching with correct invalidation, TTL, and stampede protection.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: performance
  tags: [cache, performance]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Caching Strategy

## Objective
Speed up reads with a cache that stays correct and never serves stale-critical data.

## Preconditions
- `cap repo` run; hot read paths and data volatility identified (`cap explore`, `cap diff` sense).

## Workflow
1. Run `cap explore` for expensive reads (DB/heavy compute/external calls).
2. Choose cache layer (in-memory, Redis, CDN) by volatility and sharedness.
3. Define TTL and invalidation: write-through, key eviction, or event-driven purge.
4. Guard against stampede with singleflight/lock-per-key on miss.
5. Add cache metrics (hit rate) and a manual purge path.
6. Record the cache keys and TTLs with `cap memory add`.

## Verification
- [ ] TTL/invalidation matches data volatility.
- [ ] No thundering-herd on cold key.
- [ ] Hit-rate metric exists.
- [ ] Purge path tested.

## Failure Handling
- If stale data is dangerous, shorten TTL or use write-through.
- If cache miss is catastrophic, add warmup.

## Output Format
Cache design: layer, key scheme, TTL, invalidation, stampede guard, and hit-rate results.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
