# Skill: Unit Test Security

## Purpose

Design security-aware unit tests: testing validation, authorization logic,
and security primitives at unit level.

## Scope

- Included: validation functions, authorization checks, crypto/token units.
- Excluded: integration/e2e (`integration-test-security.md`).
- Layers: testing.

## Trigger Conditions

- Security-sensitive functions.
- Fix verification at unit level.

## Inputs

- source code

## Investigation Method

1. Identify entry points: security functions.
2. Identify trust boundaries: N/A.
3. Track relevant data: inputs.
4. Identify validation: unit assertions.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: check units.
7. Inspect error handling: N/A.
8. Inspect tests: coverage.
9. Determine exploitability or correctness impact: N/A.
10. Validate the finding: run unit tests.

## Evidence Requirements

- E1: function code.
- E3: unit tests with hostile inputs.

## Confidence

- CONFIRMED with passing tests.

## Severity

- N/A.

## Safe Reproduction

- Local unit tests with fixtures.

## Root Cause

- N/A.

## Impact

- Confidence in security primitives.

## Remediation

- Unit tests for validation/authz/token functions; mutation coverage.

## Regression Test

- Security unit tests as regression suite.

## Common False Positives

- Tests that bypass the real code path (mocks misconfigured).

## Related Skills

- `integration-test-security.md`
- `security-test-design.md`
- `../static-analysis/static-code-analysis.md`

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

- Unit testing docs (per language)
- OWASP ASVS V14
