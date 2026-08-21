# Skill: Price Integrity

## Purpose

Analyze price and total integrity: whether prices, discounts, and totals are
computed server-side and cannot be tampered with via request fields.

## Scope

- Included: client-sent prices/totals, discount abuse, negative prices,
  floating-point money math, coupon logic.
- Excluded: quantity logic (`quantity-integrity.md`).
- Layers: business logic.

## Trigger Conditions

- Price/total fields in requests.
- Discount/coupon features.
- Float arithmetic for money.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: pricing operations.
2. Identify trust boundaries: client vs server pricing.
3. Track relevant data: price fields.
4. Identify validation: server-side recomputation.
5. Identify security-sensitive operations: charges.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: tampering/rounding tests.
9. Determine exploitability or correctness impact: price manipulation.
10. Validate the finding: tampered-price tests.

## Evidence Requirements

- E1: pricing code.
- E2: client-influenced price path.
- E3: test demonstrating altered price/negative total.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- HIGH for financial loss; MEDIUM for minor.

## Safe Reproduction

- Local tests with tampered price/discount payloads and rounding edges.

## Root Cause

- Trusting client prices; float math; unvalidated discounts.

## Impact

- Free/cheap purchases, negative charges, financial loss.

## Remediation

- Server-side pricing; integer cents/Decimal; validated discounts;
  idempotent charges.

## Regression Test

- Tests asserting server-side totals and tamper resistance.

## Common False Positives

- Prices recomputed server-side (verify).

## Related Skills

- `quantity-integrity.md`
- `../input-validation/parameter-tampering.md`
- `duplicate-operation.md`

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
