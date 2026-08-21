# Skill: Concurrent State

## Purpose

Analyze cross-request/cross-user shared state: global mutable state,
caches, singletons, and static data leaking between requests or users.

## Scope

- Included: global/static mutable state, shared caches, singletons,
  cross-tenant contamination.
- Excluded: DB-level isolation (`../database/database-access-control.md`).
- Layers: application state.

## Trigger Conditions

- Global/static variables in services.
- Shared caches keyed ambiguously.
- Claims of "isolated" to verify.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: state read/write.
2. Identify trust boundaries: cross-request isolation.
3. Track relevant data: shared state values.
4. Identify validation: per-request scoping.
5. Identify security-sensitive operations: data serving.
6. Inspect authorization: cross-user leakage.
7. Inspect error handling: N/A.
8. Inspect tests: cross-request tests.
9. Determine exploitability or correctness impact: leakage.
10. Validate the finding: cross-request tests.

## Evidence Requirements

- E1: shared-state code.
- E2: cross-request contamination path.
- E3: test demonstrating leakage between requests.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- HIGH for cross-user data leakage; MEDIUM otherwise.

## Safe Reproduction

- Local tests with sequential requests sharing state.

## Root Cause

- Global mutable state; cache-key collisions; singletons holding request data.

## Impact

- Cross-user data disclosure, authorization bypass, correctness bugs.

## Remediation

- Per-request scoping; namespaced cache keys; immutable singletons.

## Regression Test

- Cross-request tests asserting isolation.

## Common False Positives

- Read-only shared state (verify immutability).

## Related Skills

- `async-state-analysis.md`
- `race-condition.md`
- `../performance/cache-analysis.md`
- `../authorization/horizontal-privilege-escalation.md`

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

- OWASP ASVS V4 (Access Control) / V8 (Data Protection)
- CWE-362
