# Skill: Boundary Testing

## Purpose

Design boundary tests: testing values at and around limits (min, max, max+1,
empty, null, negative) to catch off-by-one and limit bugs.

## Scope

- Included: numeric/string/collection boundaries, limit enforcement.
- Excluded: random values (`property-based-testing.md`).
- Layers: testing.

## Trigger Conditions

- Validation/limits code.
- Bug fixes at boundaries.

## Inputs

- limits/specs

## Investigation Method

1. Identify entry points: boundary-checked code.
2. Identify trust boundaries: N/A.
3. Track relevant data: boundary values.
4. Identify validation: expected acceptance/rejection.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: coverage.
9. Determine exploitability or correctness impact: N/A.
10. Validate the finding: run boundary tests.

## Evidence Requirements

- E1: limits.
- E3: boundary tests demonstrating behavior.

## Confidence

- CONFIRMED with passing tests.

## Severity

- N/A.

## Safe Reproduction

- Local tests with boundary values.

## Root Cause

- N/A.

## Impact

- Prevents off-by-one and limit bypasses.

## Remediation

- Boundary test sets per limit (min, max, max+1, empty).

## Regression Test

- Boundary tests as regression suite.

## Common False Positives

- Tests at wrong limits (verify spec).

## Related Skills

- `negative-testing.md`
- `property-based-testing.md`
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

- Test design references
- CWE-697
