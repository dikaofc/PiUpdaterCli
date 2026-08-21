# Skill: Security Test Design

## Purpose

Design security tests from threat models and abuse cases: turning attack paths
into executable tests.

## Scope

- Included: abuse-case derivation, test matrix design, coverage mapping.
- Excluded: specific types (other testing skills).
- Layers: testing.

## Trigger Conditions

- Threat-model-driven testing.
- Security requirements verification.

## Inputs

- threat models
- security requirements

## Investigation Method

1. Identify entry points: attack paths.
2. Identify trust boundaries: N/A.
3. Track relevant data: abuse cases.
4. Identify validation: test matrix.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: coverage.
9. Determine exploitability or correctness impact: N/A.
10. Validate the finding: run the matrix.

## Evidence Requirements

- E1: threat model/requirements.
- E3: tests demonstrating controls.

## Confidence

- CONFIRMED with passing security tests.

## Severity

- N/A.

## Safe Reproduction

- Local tests per abuse case.

## Root Cause

- N/A.

## Impact

- Requirements → verified behavior.

## Remediation

- Security test matrix per requirement; CI execution.

## Regression Test

- Security tests as regression suite.

## Common False Positives

- Tests not mapping to real attack paths.

## Related Skills

- `negative-testing.md`
- `reproduction-test-design.md`
- `../context/threat-modeling.md`

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

- OWASP ASVS V14
- OWASP Security Testing Guide
