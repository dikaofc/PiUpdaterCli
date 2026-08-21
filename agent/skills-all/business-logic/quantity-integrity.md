# Skill: Quantity Integrity

## Purpose

Analyze quantity and stock integrity: negative/zero quantities, overselling,
over-limit quantities, and client-trusted counts.

## Scope

- Included: quantity validation, stock checks, negative values, limits,
  concurrent stock updates.
- Excluded: pricing (`price-integrity.md`).
- Layers: business logic.

## Trigger Conditions

- Quantity fields in requests.
- Inventory/stock operations.
- Claims of "stock checks" to verify.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: quantity operations.
2. Identify trust boundaries: client counts.
3. Track relevant data: quantity → logic.
4. Identify validation: bounds and stock checks.
5. Identify security-sensitive operations: stock changes.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: negative/oversell tests.
9. Determine exploitability or correctness impact: abuse.
10. Validate the finding: tampered-quantity tests.

## Evidence Requirements

- E1: quantity code.
- E2: missing bounds/stock check.
- E3: test demonstrating negative/oversell acceptance.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- HIGH for stock/financial abuse; MEDIUM otherwise.

## Safe Reproduction

- Local tests with negative/zero/max/oversell quantities.

## Root Cause

- No bounds; non-atomic stock updates; client-trusted counts.

## Impact

- Stock manipulation, free items, inventory corruption.

## Remediation

- Server-side bounds; atomic stock updates; unique constraints.

## Regression Test

- Tests asserting quantity bounds and atomic stock behavior.

## Common False Positives

- Quantities recomputed server-side (verify).

## Related Skills

- `price-integrity.md`
- `../database/race-condition-database.md`
- `../input-validation/boundary-validation.md`

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
- CWE-697
