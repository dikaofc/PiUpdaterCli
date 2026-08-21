# Skill: Duplicate Operation

## Purpose

Detect duplicate-operation defects: identical requests or retries producing
duplicate effects (double orders, double charges, duplicate accounts).

## Scope

- Included: idempotency gaps, retry double-effects, duplicate submission,
  unique-constraint gaps.
- Excluded: API idempotency design (`../api/api-idempotency.md`).
- Layers: business logic.

## Trigger Conditions

- State-creating operations without idempotency.
- Client retries possible.
- Claims of "no duplicates" to verify.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: creation operations.
2. Identify trust boundaries: N/A.
3. Track relevant data: request identity.
4. Identify validation: dedup mechanisms.
5. Identify security-sensitive operations: state creation.
6. Inspect authorization: N/A.
7. Inspect error handling: retry behavior.
8. Inspect tests: duplicate tests.
9. Determine exploitability or correctness impact: duplicates.
10. Validate the finding: identical-request tests.

## Evidence Requirements

- E1: creation code.
- E2: missing dedup.
- E3: test demonstrating duplicate creation.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- HIGH for payments/orders; MEDIUM otherwise.

## Safe Reproduction

- Local tests sending identical requests.

## Root Cause

- No idempotency keys/unique constraints; retry re-execution.

## Impact

- Double charges, duplicate records, inconsistent state.

## Remediation

- Idempotency keys; unique constraints; atomic create-if-absent.

## Regression Test

- Tests asserting single-effect on duplicate requests.

## Common False Positives

- Operations naturally idempotent (verify).

## Related Skills

- `../api/api-idempotency.md`
- `replay-protection.md`
- `../database/race-condition-database.md`
- `../concurrency/duplicate-request-analysis.md`

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
