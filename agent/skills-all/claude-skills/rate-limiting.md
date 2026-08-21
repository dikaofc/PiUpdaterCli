---
name: rate-limiting
description: Protect services and clients with token-bucket/leaky-bucket limits and quotas.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [ratelimit, throttling, resilience]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Rate Limiting & Throttling

## Objective
Bound request rates to prevent abuse and overload while staying fair.

## Preconditions
- `cap repo` run; entry points and upstream limits known (`cap explore <handler|gateway>`).

## Workflow
1. Run `cap explore` for public entry points and costly operations.
2. Choose algorithm (token bucket for burst, leaky bucket for smooth) per endpoint.
3. Define limits per identity (user/IP/key) and a clear 429 + Retry-After response.
4. Place the limiter at the edge (gateway) where possible; fallback to app middleware.
5. Add metrics on limited vs allowed and a config knob for tuning.
6. Record limits and keys with `cap memory add`.

## Verification
- [ ] Limits applied at edge or earliest app layer.
- [ ] 429 returns Retry-After.
- [ ] Per-identity keying correct.
- [ ] Metrics show limit hits.

## Failure Handling
- If limit blocks legit traffic, raise or scope by tier.
- If distributed, use a shared counter (Redis) not local.

## Output Format
Rate-limit design: algorithm, keys, limits, 429 shape, and metrics.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
