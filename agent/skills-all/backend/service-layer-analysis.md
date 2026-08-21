# Skill: Service Layer Analysis

## Purpose

Analyze service layer logic: authorization enforcement, transaction
boundaries, business rules, and error handling in services.

## Scope

- Included: service functions, authz placement, transactions, rules.
- Excluded: controllers (`controller-analysis.md`).
- Layers: service.

## Trigger Conditions

- Business-logic audits.
- Authorization questions.

## Inputs

- source code

## Investigation Method

1. Identify entry points: service calls.
2. Identify trust boundaries: controller → service.
3. Track relevant data: parameters.
4. Identify validation: re-validation in service.
5. Identify security-sensitive operations: state changes.
6. Inspect authorization: service-level checks.
7. Inspect error handling: N/A.
8. Inspect tests: coverage.
9. Determine exploitability or correctness impact: gaps.
10. Validate the finding: service tests.

## Evidence Requirements

- E1: service code.
- E2: gap.
- E3: test demonstrating it.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM–HIGH.

## Safe Reproduction

- Local service unit tests.

## Root Cause

- Authz/rules only in controllers; services trust callers.

## Impact

- Bypass of checks when services called directly (jobs, other services).

## Remediation

- Enforce authorization/rules in services; validate at service boundary.

## Regression Test

- Direct service-call tests.

## Common False Positives

- Single-caller services with controller checks (verify all callers).

## Related Skills

- `controller-analysis.md`
- `repository-layer-analysis.md`
- `../authorization/server-side-authorization.md`

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

- OWASP ASVS V1
