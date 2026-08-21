# Skill: Integration Test Security

## Purpose

Design security-aware integration tests: end-to-end flows (auth, sessions,
authorization, business logic) against real components.

## Scope

- Included: flow-level tests, cross-component security behavior.
- Excluded: unit tests (`unit-test-security.md`).
- Layers: integration.

## Trigger Conditions

- Auth/authorization flow verification.
- Multi-component security paths.

## Inputs

- API specs
- flow definitions

## Investigation Method

1. Identify entry points: flows.
2. Identify trust boundaries: N/A.
3. Track relevant data: flow state.
4. Identify validation: flow assertions.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: flow-level checks.
7. Inspect error handling: N/A.
8. Inspect tests: coverage.
9. Determine exploitability or correctness impact: N/A.
10. Validate the finding: run integration tests.

## Evidence Requirements

- E1: flow specs.
- E3: integration tests demonstrating behavior.

## Confidence

- CONFIRMED with passing tests.

## Severity

- N/A.

## Safe Reproduction

- Local test environment with fixtures/mocks.

## Root Cause

- N/A.

## Impact

- Confidence in end-to-end security behavior.

## Remediation

- Flow-level integration tests per security requirement.

## Regression Test

- Integration tests as regression suite.

## Common False Positives

- Tests not exercising real components (mocked away the subject).

## Related Skills

- `unit-test-security.md`
- `negative-testing.md`
- `../workflows/auth-audit.md`

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

- Integration testing docs
- OWASP ASVS V14
