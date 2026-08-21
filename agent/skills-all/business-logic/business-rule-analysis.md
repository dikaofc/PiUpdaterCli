# Skill: Business Rule Analysis

## Purpose

Analyze business rule enforcement: whether intended rules (eligibility,
limits, eligibility, entitlements, approval flows) are enforced server-side and
cannot be bypassed by request manipulation.

## Scope

- Included: rule identification, enforcement points, bypass paths, rule
  consistency.
- Excluded: specific rules (price, quantity skills).
- Layers: business logic.

## Trigger Conditions

- Eligibility/entitlement logic.
- Claims of "business rules" to verify.
- Logic-related findings.

## Inputs

- source code
- specs (rules)
- tests

## Investigation Method

1. Identify entry points: rule-consuming operations.
2. Identify trust boundaries: client vs server truth.
3. Track relevant data: rule inputs.
4. Identify validation: server-side rule enforcement.
5. Identify security-sensitive operations: entitlement/eligibility grants.
6. Inspect authorization: rule bypass.
7. Inspect error handling: N/A.
8. Inspect tests: rule edge tests.
9. Determine exploitability or correctness impact: bypass.
10. Validate the finding: rule bypass tests.

## Evidence Requirements

- E1: rule code.
- E2: enforcement gap.
- E3: test demonstrating rule bypass.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM–HIGH depending on rule value.

## Safe Reproduction

- Local tests against fixture data for each rule.

## Root Cause

- Rules in UI only; incomplete server checks; client-trusted inputs.

## Impact

- Free entitlements, quota bypass, financial loss.

## Remediation

- Enforce rules server-side; centralize; test every rule path.

## Regression Test

- Rule tests covering eligibility edges and bypass attempts.

## Common False Positives

- Rules enforced in shared services (verify).

## Related Skills

- `quota-bypass-analysis.md`
- `price-integrity.md`
- `../input-validation/parameter-tampering.md`
- `../authorization/access-control-analysis.md`

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

- OWASP API Security Top 10 — Business Logic
- CWE-840
