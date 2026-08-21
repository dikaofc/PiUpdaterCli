# Skill: Confidence Assessment

## Purpose

Assign confidence from evidence, separate from severity, using the five-level
model.

## Scope

- Included: evidence-to-confidence mapping, calibration.
- Excluded: severity (`severity-assessment.md`).
- Layers: reporting.

## Trigger Conditions

- Every finding.

## Inputs

- evidence level (E0–E5)

## Investigation Method

1. Identify entry points: N/A.
2. Identify trust boundaries: N/A.
3. Track relevant data: evidence chain.
4. Identify validation: each link verified.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: reproduction.
9. Determine exploitability or correctness impact: N/A.
10. Validate the finding: per `../context/confidence-model.md`.

## Evidence Requirements

- E-level drives the ceiling per the mapping table.

## Confidence

- The subject.

## Severity

- Independent axis.

## Safe Reproduction

- N/A.

## Root Cause

- N/A.

## Impact

- Honest reporting.

## Remediation

- N/A.

## Regression Test

- N/A.

## Common False Positives

- Confusing confidence with severity.

## Related Skills

- `finding-classification.md`
- `../context/confidence-model.md`
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

- `../context/confidence-model.md`
