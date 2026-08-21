# Skill: Executive Summary

## Purpose

Produce executive summaries: concise risk communications for non-technical
readers, with priorities and next steps.

## Scope

- Included: summary structure, risk framing, priorities.
- Excluded: detailed reports (`security-reporting.md`).
- Layers: reporting.

## Trigger Conditions

- Audit delivery.

## Inputs

- full findings
- audit summary

## Investigation Method

1. Identify entry points: findings.
2. Identify trust boundaries: N/A.
3. Track relevant data: N/A.
4. Identify validation: N/A.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: top risks.
10. Validate the finding: accuracy vs findings.

## Evidence Requirements

- Consistent with detailed findings.

## Confidence

- Summarized per finding.

## Severity

- Summarized per finding.

## Safe Reproduction

- N/A.

## Root Cause

- Summarized.

## Impact

- Emphasized.

## Remediation

- Next steps.

## Regression Test

- N/A.

## Common False Positives

- Overstating or understating risk vs findings.

## Related Skills

- `security-reporting.md`
- `../templates/audit-summary.md`
- `severity-assessment.md`

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

- Security report writing references
