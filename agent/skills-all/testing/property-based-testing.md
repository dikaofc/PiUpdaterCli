# Skill: Property Based Testing

## Purpose

Design property-based tests: generating many inputs to verify invariants
(no crash, no invariant violation, no unauthorized access) across input space.

## Scope

- Included: property definitions, generators, shrinking, invariant checks.
- Excluded: fuzzing external binaries (`../fuzzing/*`).
- Layers: testing.

## Trigger Conditions

- Parsers, validators, business invariants.
- Security invariants (isolation, immutability).

## Inputs

- invariants/specs

## Investigation Method

1. Identify entry points: property targets.
2. Identify trust boundaries: N/A.
3. Track relevant data: generated inputs.
4. Identify validation: invariant assertions.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: isolation invariants.
7. Inspect error handling: N/A.
8. Inspect tests: generator quality.
9. Determine exploitability or correctness impact: N/A.
10. Validate the finding: run property tests.

## Evidence Requirements

- E1: invariants.
- E3: property tests with shrunk counterexamples.

## Confidence

- CONFIRMED with passing property tests (as evidence of behavior).

## Severity

- N/A.

## Safe Reproduction

- Local property tests with generators (bounded).

## Root Cause

- N/A.

## Impact

- Broad input-space coverage.

## Remediation

- Property tests for invariants; shrink minimal failures into regression
  tests.

## Regression Test

- Shrunk counterexamples added as regression tests.

## Common False Positives

- Weak generators missing the bug space.

## Related Skills

- `boundary-testing.md`
- `../fuzzing/fuzzing-strategy.md`
- `mutation-testing.md`

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

- Hypothesis/QuickCheck/Proptest docs
- OWASP ASVS V14
