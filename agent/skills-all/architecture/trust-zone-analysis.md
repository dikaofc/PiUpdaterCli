# Skill: Trust Zone Analysis

## Purpose

Analyze trust zones: grouping components by trust level and verifying that
cross-zone interactions are controlled.

## Scope

- Included: zone definition, cross-zone flows, control placement.
- Excluded: individual boundary checks (other skills).
- Layers: architecture.

## Trigger Conditions

- Architecture design/review.
- Trust-boundary questions.

## Inputs

- architecture docs/code

## Investigation Method

1. Identify entry points: zones.
2. Identify trust boundaries: the subject.
3. Track relevant data: cross-zone flows.
4. Identify validation: controls per crossing.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: zone checks.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: zone gaps.
10. Validate the finding: trace flows.

## Evidence Requirements

- E1: zone evidence.
- E2: uncontrolled crossing.

## Confidence

- MEDIUM–HIGH.

## Severity

- Per crossing impact.

## Safe Reproduction

- N/A.

## Root Cause

- N/A.

## Impact

- Uncontrolled zone access.

## Remediation

- Controls at zone crossings.

## Regression Test

- Zone crossing tests.

## Common False Positives

- Zones defined but not real in code.

## Related Skills

- `architecture-risk-analysis.md`
- `../reconnaissance/trust-boundary-discovery.md`
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

- Threat modeling references
- OWASP ASVS V1
