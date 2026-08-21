# Skill: Resource Limit Analysis

## Purpose

Analyze resource limit enforcement: max values for resources (files, items,
seats, connections) enforced server-side and not bypassable.

## Scope

- Included: limit definitions, enforcement points, bypasses, limit races.
- Excluded: runtime resource exhaustion (`../performance/resource-exhaustion.md`).
- Layers: business logic.

## Trigger Conditions

- Plan/resource limits (seats, files, storage).
- Claims of "limit enforced" to verify.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: resource-creation operations.
2. Identify trust boundaries: N/A.
3. Track relevant data: resource counts.
4. Identify validation: limit checks.
5. Identify security-sensitive operations: resource creation.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: limit-edge tests.
9. Determine exploitability or correctness impact: over-limit.
10. Validate the finding: limit-bypass tests.

## Evidence Requirements

- E1: limit code.
- E2: enforcement gap.
- E3: test demonstrating over-limit acceptance.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM–HIGH depending on plan value.

## Safe Reproduction

- Local tests exceeding limits, including parallel creation.

## Root Cause

- Check-then-act without atomicity; limits in UI.

## Impact

- Plan abuse, cost exposure, storage abuse.

## Remediation

- Atomic limit checks; unique constraints; server-side enforcement.

## Regression Test

- Tests asserting limit enforcement under concurrency.

## Common False Positives

- Limits enforced in shared services (verify).

## Related Skills

- `quota-bypass-analysis.md`
- `../database/race-condition-database.md`
- `../performance/resource-exhaustion.md`

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

- OWASP API Security — Business Logic
- CWE-770
