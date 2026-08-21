# Skill: Cache Analysis

## Purpose

Analyze cache design: bounded size, eviction, cache keys, and stale data —
for correctness and resource safety.

## Scope

- Included: cache bounds, eviction, key correctness, invalidation.
- Excluded: web cache poisoning (`../web/cache-poisoning.md`).
- Layers: application caching.

## Trigger Conditions

- Unbounded caches.
- Cache key collisions.
- Claims of "cache safe" to verify.

## Inputs

- source code (cache usage)

## Investigation Method

1. Identify entry points: cache reads/writes.
2. Identify trust boundaries: cache sharing.
3. Track relevant data: keys/values.
4. Identify validation: bounds/eviction.
5. Identify security-sensitive operations: cached data serving.
6. Inspect authorization: cross-user cache access.
7. Inspect error handling: N/A.
8. Inspect tests: cache tests.
9. Determine exploitability or correctness impact: leak/stale.
10. Validate the finding: cache tests.

## Evidence Requirements

- E1: cache code.
- E2: bounds/key gap.
- E3: test demonstrating leak/staleness.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM (data leak/staleness).

## Safe Reproduction

- Local cache tests with fixture keys.

## Root Cause

- Unbounded growth; ambiguous keys; missing invalidation.

## Impact

- Cross-user data, stale state, memory growth.

## Remediation

- Bounded caches with eviction; namespaced keys; invalidation.

## Regression Test

- Cache tests asserting bounds and isolation.

## Common False Positives

- Cache-only non-sensitive data (verify).

## Related Skills

- `caching-correctness.md`
- `memory-leak-analysis.md`
- `../concurrency/concurrent-state.md`

## Review Checklist

- [ ] Entry point identified
- [ ] Trust boundary identified
- [ ] Data flow understood
- [ ] Validation checked
- [ ] Authorization checked
- [ ] Runtime behavior verified
- [ ] Evidence collected
- [ ] Severity assigned
- [ ] Root cause identified
- [ ] Remediation proposed
- [ ] Regression test proposed

## References

- Caching best practices (per stack)
- CWE-404
