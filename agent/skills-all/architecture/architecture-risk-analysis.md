# Skill: Architecture Risk Analysis

## Purpose

Analyze architectural risk: systemic weaknesses in design (trust boundaries,
data flows, coupling) that create vulnerability classes.

## Scope

- Included: boundary design, flow design, component trust, systemic gaps.
- Excluded: line-level findings (other skills).
- Layers: architecture.

## Trigger Conditions

- Architecture reviews.
- Recurring finding patterns.

## Inputs

- architecture docs/code
- finding history

## Investigation Method

1. Identify entry points: boundaries.
2. Identify trust boundaries: the subject.
3. Track relevant data: flows.
4. Identify validation: systemic enforcement.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: systemic checks.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: systemic risk.
10. Validate the finding: trace design vs code.

## Evidence Requirements

- E1: architecture evidence.
- E2: systemic gap traced.

## Confidence

- MEDIUM–HIGH.

## Severity

- Per systemic impact.

## Safe Reproduction

- N/A (design analysis).

## Root Cause

- Design-level defects.

## Impact

- Vulnerability classes across the system.

## Remediation

- Design-level fixes (boundary placement, central enforcement).

## Regression Test

- Systemic boundary tests.

## Common False Positives

- Constraints enforced elsewhere (verify).

## Related Skills

- `trust-zone-analysis.md`
- `dependency-graph-analysis.md`
- `../code-review/architecture-code-review.md`
- `../context/threat-modeling.md`

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
