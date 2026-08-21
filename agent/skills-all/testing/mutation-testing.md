# Skill: Mutation Testing

## Purpose

Use mutation testing to assess test quality: introducing mutations (flipped
conditions, removed checks) to find tests that do not actually verify
behavior.

## Scope

- Included: mutation runs, surviving mutations, test strengthening.
- Excluded: test design (other testing skills).
- Layers: testing quality.

## Trigger Conditions

- Security-critical code with thin tests.
- Claims of "well tested" to verify.

## Inputs

- test suite
- source code

## Investigation Method

1. Identify entry points: security-critical functions.
2. Identify trust boundaries: N/A.
3. Track relevant data: N/A.
4. Identify validation: surviving mutations.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: mutation coverage.
7. Inspect error handling: N/A.
8. Inspect tests: the subject.
9. Determine exploitability or correctness impact: N/A.
10. Validate the finding: run mutation analysis.

## Evidence Requirements

- E1: test/code pairing.
- E3: surviving mutations in security logic.

## Confidence

- CONFIRMED with surviving mutations.

## Severity

- INFORMATIONAL–MEDIUM (test quality risk).

## Safe Reproduction

- Local mutation runs (bounded scope).

## Root Cause

- N/A.

## Impact

- Undetected regressions.

## Remediation

- Strengthen tests for surviving mutations in security logic.

## Regression Test

- Added assertions for mutated behaviors.

## Common False Positives

- Equivalent mutations (semantically identical) — exclude.

## Related Skills

- `unit-test-security.md`
- `regression-testing.md`
- `security-test-design.md`

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

- PIT/Stryker docs
- OWASP ASVS V14
