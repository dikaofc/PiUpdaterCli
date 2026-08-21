# Skill: False Positive Analysis

## Purpose

Analyze and document false positives: applying the disprove-first discipline
and recording the invalidation evidence.

## Scope

- Included: invalidation questions, classification, residual risk.
- Excluded: initial discovery (other skills).
- Layers: reporting.

## Trigger Conditions

- Every candidate finding.

## Inputs

- candidate findings
- code

## Investigation Method

1. Identify entry points: the claim.
2. Identify trust boundaries: N/A.
3. Track relevant data: the path.
4. Identify validation: each invalidation question.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: compensating controls.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: verdict.
10. Validate the finding: per `../context/false-positive-model.md`.

## Evidence Requirements

- Evidence that disproves the claim.

## Confidence

- FALSE POSITIVE when disproved.

## Severity

- N/A.

## Safe Reproduction

- N/A.

## Root Cause

- N/A.

## Impact

- Reduces noise.

## Remediation

- N/A.

## Regression Test

- Negative controls from FP analysis.

## Common False Positives

- Disproving with assumptions instead of evidence.

## Related Skills

- `finding-classification.md`
- `../context/false-positive-model.md`
- `../context/evidence-model.md`

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

- `../context/false-positive-model.md`
