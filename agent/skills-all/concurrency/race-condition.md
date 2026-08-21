# Skill: Race Condition

## Purpose

Detect and validate race conditions: concurrent execution changing shared
state with inconsistent results — lost updates, double effects, security
check bypasses.

## Scope

- Included: shared mutable state, check-then-act, counters, double-spend,
  request concurrency.
- Excluded: DB-specific races (`../database/race-condition-database.md`),
  TOCTOU (`toctou-analysis.md`).
- Layers: application logic.

## Trigger Conditions

- Shared mutable state in services.
- Check-then-act sequences.
- Concurrent-request-prone operations.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: concurrent operations.
2. Identify trust boundaries: N/A.
3. Track relevant data: shared state.
4. Identify validation: atomicity/synchronization.
5. Identify security-sensitive operations: state changes.
6. Inspect authorization: race-bypassed checks.
7. Inspect error handling: N/A.
8. Inspect tests: concurrency tests.
9. Determine exploitability or correctness impact: race effects.
10. Validate the finding: concurrent tests.

## Evidence Requirements

- E1: shared-state code.
- E2: missing synchronization.
- E3: test demonstrating the race (parallel invocations).

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM–HIGH depending on state affected.

## Safe Reproduction

- Local parallel-request tests with barriers/synchronization.

## Root Cause

- Non-atomic read-modify-write; unsynchronized shared state.

## Impact

- Double effects, lost updates, security-check bypass.

## Remediation

- Atomic operations, locks, or transactional guarantees; single-writer
  patterns.

## Regression Test

- Concurrency tests asserting single effect under parallelism.

## Common False Positives

- Single-threaded execution models (verify actual concurrency).

## Related Skills

- `atomicity-analysis.md`
- `concurrent-state.md`
- `../database/race-condition-database.md`
- `duplicate-request-analysis.md`

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

- OWASP API Security — Business Logic (races)
- CWE-362
