# Skill: Controller Analysis

## Purpose

Analyze controllers/handlers: input binding, validation application,
authorization calls, and response safety.

## Scope

- Included: binding, validation calls, authz calls, response mapping.
- Excluded: service logic (`service-layer-analysis.md`).
- Layers: controller.

## Trigger Conditions

- New endpoints.
- Mass-assignment/validation questions.

## Inputs

- source code

## Investigation Method

1. Identify entry points: controller actions.
2. Identify trust boundaries: request → controller.
3. Track relevant data: bound fields.
4. Identify validation: applied at controller.
5. Identify security-sensitive operations: service calls.
6. Inspect authorization: authz calls present.
7. Inspect error handling: N/A.
8. Inspect tests: coverage.
9. Determine exploitability or correctness impact: gaps.
10. Validate the finding: controller tests.

## Evidence Requirements

- E1: controller code.
- E2: gap.
- E3: test demonstrating it.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM–HIGH.

## Safe Reproduction

- Local controller tests.

## Root Cause

- Missing validation/authz in controllers; mass assignment.

## Impact

- Injection, unauthorized actions.

## Remediation

- Validate + authorize in controllers; thin controllers; response DTOs.

## Regression Test

- Per-controller negative tests.

## Common False Positives

- Validation in framework binding (verify).

## Related Skills

- `middleware-analysis.md`
- `service-layer-analysis.md`
- `../input-validation/mass-assignment.md`

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

- Framework controller docs
- OWASP ASVS V5
