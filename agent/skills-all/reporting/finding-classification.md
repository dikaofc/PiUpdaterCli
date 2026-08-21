# Skill: Finding Classification

## Purpose

Classify findings consistently: type (security vs correctness), category,
severity, confidence, and evidence level.

## Scope

- Included: classification scheme, type assignment, evidence mapping.
- Excluded: severity details (`severity-assessment.md`).
- Layers: reporting.

## Trigger Conditions

- Every finding.
- Report preparation.

## Inputs

- investigation results

## Investigation Method

1. Identify entry points: the finding's trigger.
2. Identify trust boundaries: crossed.
3. Track relevant data: path.
4. Identify validation: checks.
5. Identify security-sensitive operations: sinks.
6. Inspect authorization: role.
7. Inspect error handling: N/A.
8. Inspect tests: evidence.
9. Determine exploitability or correctness impact: type/impact.
10. Validate the finding: evidence level.

## Evidence Requirements

- E-level recorded with every classification.

## Confidence

- Recorded separately.

## Severity

- Recorded separately.

## Safe Reproduction

- N/A.

## Root Cause

- N/A.

## Impact

- Consistent taxonomy across reports.

## Remediation

- N/A.

## Regression Test

- N/A.

## Common False Positives

- Type misclassification (security vs correctness).

## Related Skills

- `severity-assessment.md`
- `confidence-assessment.md`
- `../references/vulnerability-taxonomy.md`

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

- OWASP / CWE classification
- `../references/bug-taxonomy.md`
