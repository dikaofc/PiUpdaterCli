# Skill: Architecture Code Review

## Purpose

Review architectural code: trust boundaries, data-flow design, and
security-relevant architecture decisions.

## Scope

- Included: boundary placement, enforcement design, component trust.
- Excluded: line-level review (other skills).
- Layers: architecture.

## Trigger Conditions

- Architecture changes.
- Design-phase review.

## Inputs

- architecture docs/code

## Investigation Method

1. Identify entry points: boundaries.
2. Identify trust boundaries: the subject.
3. Track relevant data: cross-boundary flows.
4. Identify validation: enforcement design.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: design-level.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: design gaps.
10. Validate the finding: trace design vs implementation.

## Evidence Requirements

- E1: architecture evidence.
- E2: design gap traced.

## Confidence

- MEDIUM–HIGH.

## Severity

- Per gap.

## Safe Reproduction

- N/A (design analysis).

## Root Cause

- Per finding.

## Impact

- Systemic security weaknesses.

## Remediation

- Design-level fixes.

## Regression Test

- Boundary tests.

## Common False Positives

- Design constraints not actually enforced (that IS the finding).

## Related Skills

- `../architecture/architecture-risk-analysis.md`
- `security-code-review.md`
- `../SECURITY_BOUNDARIES.md`

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

- OWASP ASVS V1
- Threat modeling references
