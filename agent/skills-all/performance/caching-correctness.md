# Skill: Caching Correctness

## Purpose

Analyze caching correctness: staleness, invalidation, cache-key accuracy, and
conditional caching — where stale or wrong data breaks behavior.

## Scope

- Included: invalidation coverage, key correctness, TTLs, read/write
  consistency.
- Excluded: web cache poisoning (`../web/cache-poisoning.md`).
- Layers: application caching.

## Trigger Conditions

- Cached data behind writes.
- Claims of "cache consistent" to verify.

## Inputs

- source code

## Investigation Method

1. Identify entry points: cache/write paths.
2. Identify trust boundaries: N/A.
3. Track relevant data: cache consistency.
4. Identify validation: invalidation coverage.
5. Identify security-sensitive operations: cached state.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: consistency tests.
9. Determine exploitability or correctness impact: staleness.
10. Validate the finding: write-then-read tests.

## Evidence Requirements

- E1: cache code.
- E2: invalidation gap.
- E3: test demonstrating stale reads.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM.

## Safe Reproduction

- Local write/read cache tests.

## Root Cause

- Missing invalidation; wrong keys; long TTLs.

## Impact

- Stale data, broken invariants, security-relevant staleness.

## Remediation

- Invalidate on writes; versioned keys; appropriate TTLs.

## Regression Test

- Write-then-read consistency tests.

## Common False Positives

- Immutable cached data (verify).

## Related Skills

- `cache-analysis.md`
- `../web/cache-poisoning.md`
- `../concurrency/race-condition.md`

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

- Caching patterns docs
- CWE-697
