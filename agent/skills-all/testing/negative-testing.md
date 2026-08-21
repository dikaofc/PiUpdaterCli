# Skill: Negative Testing

## Purpose

Design negative tests: cases that MUST fail (unauthorized access, invalid
input, denied transitions) and verifying the system rejects them correctly.

## Scope

- Included: denial assertions, error-path behavior, authorization negatives.
- Excluded: boundary values (`boundary-testing.md`).
- Layers: testing.

## Trigger Conditions

- Authorization/validation code under test.
- Fix verification.

## Inputs

- access rules
- validation specs

## Investigation Method

1. Identify entry points: protected operations.
2. Identify trust boundaries: N/A.
3. Track relevant data: denial conditions.
4. Identify validation: expected rejections.
5. Identify security-sensitive operations: denied actions.
6. Inspect authorization: denial assertions.
7. Inspect error handling: safe denial.
8. Inspect tests: coverage gaps.
9. Determine exploitability or correctness impact: N/A.
10. Validate the finding: run negative tests.

## Evidence Requirements

- E1: rules/specs.
- E3: tests demonstrating correct rejection.

## Confidence

- CONFIRMED with passing negative tests.

## Severity

- N/A (testing artifact).

## Safe Reproduction

- Local tests with denied inputs.

## Root Cause

- N/A.

## Impact

- Prevents regressions in denials.

## Remediation

- Add negative tests per rule; CI enforcement.

## Regression Test

- Negative tests as regression tests for denial behavior.

## Common False Positives

- Tests asserting denials that pass for wrong reasons (verify error type).

## Related Skills

- `boundary-testing.md`
- `regression-testing.md`
- `security-test-design.md`
- `../checklists/authorization.md`

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

- Software testing references
- OWASP ASVS V14
