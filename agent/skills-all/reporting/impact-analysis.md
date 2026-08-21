# Skill: Impact Analysis

## Purpose

Analyze realistic impact: confidentiality, integrity, availability, financial,
and business consequences — separating observed from projected.

## Scope

- Included: impact classes, observed vs projected, likelihood.
- Excluded: severity scoring (`severity-assessment.md`).
- Layers: reporting.

## Trigger Conditions

- Every finding.

## Inputs

- behavior evidence (E3/E4)

## Investigation Method

1. Identify entry points: the defect.
2. Identify trust boundaries: scope.
3. Track relevant data: N/A.
4. Identify validation: N/A.
5. Identify security-sensitive operations: consequence.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: classes.
10. Validate the finding: evidence-backed claims.

## Evidence Requirements

- E4 for observed impact; projected impact labeled.

## Confidence

- Independent.

## Severity

- Derived partly from impact.

## Safe Reproduction

- N/A.

## Root Cause

- N/A.

## Impact

- The subject.

## Remediation

- N/A.

## Regression Test

- N/A.

## Common False Positives

- Inflated or speculative impact.

## Related Skills

- `severity-assessment.md`
- `../context/evidence-model.md`
- `../templates/vulnerability-report.md`

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

- OWASP Risk Rating
