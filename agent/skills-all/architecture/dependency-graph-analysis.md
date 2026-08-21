# Skill: Dependency Graph Analysis

## Purpose

Analyze the architecture-level dependency graph: coupling, cycles, and
trust flows between components.

## Scope

- Included: component dependencies, cycles, coupling, trust flow.
- Excluded: package dependencies (`../dependencies/*`).
- Layers: architecture.

## Trigger Conditions

- Architecture reviews.
- Refactor planning.

## Inputs

- code/architecture

## Investigation Method

1. Identify entry points: components.
2. Identify trust boundaries: inter-component.
3. Track relevant data: dependency edges.
4. Identify validation: coupling/cycles.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: risk.
10. Validate the finding: graph verification.

## Evidence Requirements

- E1: dependency evidence.

## Confidence

- HIGH with verified edges.

## Severity

- INFORMATIONAL–MEDIUM.

## Safe Reproduction

- N/A.

## Root Cause

- N/A.

## Impact

- Coupling-driven bugs.

## Remediation

- Decouple; remove cycles.

## Regression Test

- N/A.

## Common False Positives

- Static coupling without runtime dependency.

## Related Skills

- `architecture-risk-analysis.md`
- `../static-analysis/call-graph-analysis.md`

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

- Software architecture references
