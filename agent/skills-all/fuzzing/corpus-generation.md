# Skill: Corpus Generation

## Purpose

Build effective fuzz corpora: seed inputs covering formats, edge cases, and
structure to maximize fuzzing value.

## Scope

- Included: seed selection, structure coverage, minimization.
- Excluded: harness design (`fuzz-harness-design.md`).
- Layers: testing.

## Trigger Conditions

- Starting fuzz campaigns.
- Improving coverage.

## Inputs

- formats/protocols
- existing samples

## Investigation Method

1. Identify entry points: format variants.
2. Identify trust boundaries: N/A.
3. Track relevant data: structure coverage.
4. Identify validation: seed quality.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: N/A.
10. Validate the finding: corpus coverage runs.

## Evidence Requirements

- E1: corpus evidence.
- E3: coverage measurements.

## Confidence

- CONFIRMED with coverage data.

## Severity

- N/A.

## Safe Reproduction

- Local corpus generation.

## Root Cause

- N/A.

## Impact

- Better fuzzing coverage.

## Remediation

- Diverse seeds; minimize corpus; regenerate on format changes.

## Regression Test

- Corpus coverage checks.

## Common False Positives

- Corpora without structure diversity.

## Related Skills

- `fuzzing-strategy.md`
- `fuzz-harness-design.md`

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

- Fuzzing corpus guidance (libFuzzer docs)
