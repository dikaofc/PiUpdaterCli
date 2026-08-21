# Skill: Remediation Analysis

## Purpose

Analyze remediation options: minimal fixes that address root cause with
acceptable regression risk.

## Scope

- Included: fix design, minimality, regression risk, verification.
- Excluded: writing fixes (fixing mode in METHODOLOGY.md).
- Layers: reporting.

## Trigger Conditions

- Every finding before closing.

## Inputs

- root cause
- code context

## Investigation Method

1. Identify entry points: the defect.
2. Identify trust boundaries: N/A.
3. Track relevant data: N/A.
4. Identify validation: what to add/fix.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: regression coverage.
9. Determine exploitability or correctness impact: fix sufficiency.
10. Validate the finding: proposed fix + test design.

## Evidence Requirements

- E5: fix validated against reproduction.

## Confidence

- Independent.

## Severity

- Independent.

## Safe Reproduction

- N/A.

## Root Cause

- Input.

## Impact

- N/A.

## Remediation

- The subject.

## Regression Test

- Mandatory companion.

## Common False Positives

- Over-broad fixes introducing regressions.

## Related Skills

- `root-cause-analysis.md`
- `../METHODOLOGY.md` (Fixing Mode)
- `../references/remediation-matrix.md`

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

- `../references/remediation-matrix.md`
