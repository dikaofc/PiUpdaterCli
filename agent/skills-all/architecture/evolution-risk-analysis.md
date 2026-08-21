# Skill: Evolution Risk Analysis

## Purpose

Analyze evolution risk: how the system's growth (new features, layers,
integrations) has created drift from its security design.

## Scope

- Included: legacy layers, integration sprawl, security-model drift.
- Excluded: current-state audits (other skills).
- Layers: architecture history.

## Trigger Conditions

- Mature systems with layered growth.
- Post-incident reviews.

## Inputs

- codebase history
- architecture docs

## Investigation Method

1. Identify entry points: growth areas.
2. Identify trust boundaries: N/A.
3. Track relevant data: N/A.
4. Identify validation: design vs current code.
5. Identify security-sensitive operations: drifted areas.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: drift risk.
10. Validate the finding: compare design vs code.

## Evidence Requirements

- E1: historical/current evidence.
- E2: drift path.

## Confidence

- MEDIUM–HIGH.

## Severity

- Per drift impact.

## Safe Reproduction

- N/A.

## Root Cause

- N/A.

## Impact

- Weak points from unplanned growth.

## Remediation

- Align code with design; refactor drifted areas.

## Regression Test

- Boundary tests for drifted areas.

## Common False Positives

- Documented intentional deviations (verify).

## Related Skills

- `architecture-risk-analysis.md`
- `../code-review/architecture-code-review.md`

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

- Software evolution references
