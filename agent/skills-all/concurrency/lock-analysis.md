# Skill: Lock Analysis

## Purpose

Analyze locking correctness: lock scope, re-entrancy, release on all paths,
copying locks, and lock-free correctness.

## Scope

- Included: lock scope, re-entrancy, release paths, lock copies, condition
  variables.
- Excluded: deadlock cycles (`deadlock-analysis.md`).
- Layers: concurrency.

## Trigger Conditions

- Custom locking code.
- Locks acquired/released manually.
- Shared structures in concurrent code.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: locked sections.
2. Identify trust boundaries: N/A.
3. Track relevant data: shared state access.
4. Identify validation: lock scope covers all mutations.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: release on error paths.
8. Inspect tests: locking tests.
9. Determine exploitability or correctness impact: races/leaks.
10. Validate the finding: code review + targeted tests.

## Evidence Requirements

- E1: locking code.
- E2: scope/release gap.
- E3: test demonstrating race or leaked lock.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM (correctness/availability).

## Safe Reproduction

- Local tests with concurrency patterns.

## Root Cause

- Wrong scope; missing release; re-entrancy assumptions.

## Impact

- Races, stalls, correctness bugs.

## Remediation

- Minimal lock scope; RAII/guards; avoid manual locking where possible.

## Regression Test

- Tests asserting mutation safety and release.

## Common False Positives

- Language-level safe patterns (immutability) (verify).

## Related Skills

- `deadlock-analysis.md`
- `atomicity-analysis.md`
- `concurrent-state.md`

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

- Concurrency docs (per language)
- CWE-667
