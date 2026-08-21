# Skill: Middleware Analysis

## Purpose

Analyze middleware chains: ordering, coverage, and bypasses of auth,
validation, and security middleware.

## Scope

- Included: middleware order, path coverage, conditional application,
  bypass routes.
- Excluded: middleware implementations themselves (other skills).
- Layers: web/API framework.

## Trigger Conditions

- Auth/validation middleware changes.
- Claims of "all routes protected" to verify.

## Inputs

- source code (middleware wiring)
- route registrations

## Investigation Method

1. Identify entry points: route groups.
2. Identify trust boundaries: middleware coverage.
3. Track relevant data: request → middleware.
4. Identify validation: order/coverage.
5. Identify security-sensitive operations: protected routes.
6. Inspect authorization: middleware coverage.
7. Inspect error handling: N/A.
8. Inspect tests: coverage tests.
9. Determine exploitability or correctness impact: bypass.
10. Validate the finding: route-coverage tests.

## Evidence Requirements

- E1: middleware wiring.
- E2: uncovered route.
- E3: test showing a route bypasses middleware.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- HIGH for auth middleware bypass.

## Safe Reproduction

- Local route tests.

## Root Cause

- Conditional middleware; ordering errors; regex scope mistakes.

## Impact

- Unprotected routes.

## Remediation

- Default-apply middleware; explicit exemptions reviewed; coverage tests.

## Regression Test

- Route × middleware coverage tests.

## Common False Positives

- Middleware applied at gateway (verify chain).

## Related Skills

- `../api/api-authentication.md`
- `controller-analysis.md`
- `backend-entrypoint-analysis.md`

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

- Framework middleware docs
- CWE-285
