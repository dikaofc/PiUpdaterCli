# Skill: Duplicate Request Analysis

## Purpose

Analyze duplicate request handling: concurrent identical requests (double
submit, retries, replay) producing duplicate effects or bypassing checks.

## Scope

- Included: concurrent duplicates, idempotency under parallelism, request
  dedup.
- Excluded: sequential duplicates (`../business-logic/duplicate-operation.md`).
- Layers: API + logic.

## Trigger Conditions

- Parallel identical requests possible.
- Claims of "idempotent" to verify.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: state-creating operations.
2. Identify trust boundaries: N/A.
3. Track relevant data: request identity.
4. Identify validation: dedup under concurrency.
5. Identify security-sensitive operations: state creation.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: parallel duplicate tests.
9. Determine exploitability or correctness impact: double effects.
10. Validate the finding: parallel tests.

## Evidence Requirements

- E1: operation code.
- E2: missing concurrent dedup.
- E3: test demonstrating double effect under parallelism.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM–HIGH.

## Safe Reproduction

- Local parallel request tests with barriers.

## Root Cause

- Check-then-act; no unique constraints.

## Impact

- Double orders/charges, quota bypass.

## Remediation

- Idempotency keys + unique constraints + atomic creation.

## Regression Test

- Parallel duplicate tests asserting single effect.

## Common False Positives

- Operations with inherent single-use constraints (verify).

## Related Skills

- `race-condition.md`
- `../business-logic/duplicate-operation.md`
- `../api/api-idempotency.md`

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
- CWE-799
