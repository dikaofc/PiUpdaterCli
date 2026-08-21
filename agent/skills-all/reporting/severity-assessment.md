# Skill: Severity Assessment

## Purpose

Assign severity from impact, exploitability, privileges, interaction, scope,
persistence, and data sensitivity — never from appearance.

## Scope

- Included: factor scoring, level assignment, rationale.
- Excluded: confidence (`confidence-assessment.md`).
- Layers: reporting.

## Trigger Conditions

- Every finding.

## Inputs

- finding evidence
- impact analysis

## Investigation Method

1. Identify entry points: reachability.
2. Identify trust boundaries: scope crossing.
3. Track relevant data: N/A.
4. Identify validation: N/A.
5. Identify security-sensitive operations: impact.
6. Inspect authorization: privileges required.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: factors.
10. Validate the finding: per `../context/severity-model.md`.

## Evidence Requirements

- E3+ for HIGH; E4 for impact claims.

## Confidence

- Independent axis.

## Severity

- The subject.

## Safe Reproduction

- N/A.

## Root Cause

- N/A.

## Impact

- Prioritized remediation.

## Remediation

- N/A.

## Regression Test

- N/A.

## Common False Positives

- Rating by defect class name instead of factors.

## Related Skills

- `impact-analysis.md`
- `confidence-assessment.md`
- `../context/severity-model.md`
- `../references/severity-matrix.md`

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

- CVSS, OWASP Risk Rating
