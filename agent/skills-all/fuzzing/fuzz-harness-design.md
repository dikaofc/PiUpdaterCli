# Skill: Fuzz Harness Design

## Purpose

Design safe, effective fuzz harnesses: entry functions that feed generated
input into the target with instrumentation and resource bounds.

## Scope

- Included: harness entry points, input shaping, memory/CPU bounds,
  instrumentation.
- Excluded: strategy selection (`fuzzing-strategy.md`).
- Layers: testing.

## Trigger Conditions

- Fuzzing parser/serializer targets.
- Claims of "fuzzable" to verify.

## Inputs

- target code

## Investigation Method

1. Identify entry points: target functions.
2. Identify trust boundaries: N/A.
3. Track relevant data: input to target.
4. Identify validation: harness correctness.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: harness smoke tests.
9. Determine exploitability or correctness impact: N/A.
10. Validate the finding: run harness.

## Evidence Requirements

- E1: harness code.
- E3: harness findings.

## Confidence

- CONFIRMED with findings.

## Severity

- N/A.

## Safe Reproduction

- Local sandboxed fuzzing.

## Root Cause

- N/A.

## Impact

- Effective coverage.

## Remediation

- Harness per high-risk target; bounds; sanitizer builds.

## Regression Test

- Harness smoke tests.

## Common False Positives

- Harnesses that skip the real entry path.

## Related Skills

- `fuzzing-strategy.md`
- `corpus-generation.md`
- `crash-triage.md`

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

- libFuzzer/AFL harness docs
