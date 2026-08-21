# Skill: Deadlock Analysis

## Purpose

Detect and validate deadlocks: lock ordering cycles, lock-across-await,
nested locking, and resource-holding waits causing availability loss.

## Scope

- Included: lock ordering, nested locks, async lock holding, timeout absence,
  pool exhaustion deadlocks.
- Excluded: lock correctness generally (`lock-analysis.md`).
- Layers: concurrency.

## Trigger Conditions

- Multiple locks acquired per operation.
- Locks held across async/IO boundaries.
- Claims of "no deadlocks" to verify.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: locked operations.
2. Identify trust boundaries: N/A.
3. Track relevant data: lock acquisition order.
4. Identify validation: ordering consistency; timeouts.
5. Identify security-sensitive operations: N/A (availability).
6. Inspect authorization: N/A.
7. Inspect error handling: lock release on all paths.
8. Inspect tests: deadlock-inducing tests.
9. Determine exploitability or correctness impact: hang.
10. Validate the finding: lock-order analysis + targeted tests.

## Evidence Requirements

- E1: locking code.
- E2: cycle/ordering risk.
- E3: test demonstrating deadlock/hang (with timeout guard in the test).

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM–HIGH (availability).

## Safe Reproduction

- Local tests with controlled concurrency and timeouts; never hang CI.

## Root Cause

- Inconsistent lock ordering; locks across awaits; missing timeouts.

## Impact

- Service hangs, availability loss.

## Remediation

- Consistent lock ordering; no locks across async boundaries; lock timeouts;
  resource limits.

## Regression Test

- Concurrency tests with timeouts asserting no deadlock.

## Common False Positives

- Single-lock systems (no cycles possible).

## Related Skills

- `lock-analysis.md`
- `../performance/resource-exhaustion.md`
- `../errors/timeout-analysis.md`

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

- Concurrency documentation (per language)
- CWE-833
