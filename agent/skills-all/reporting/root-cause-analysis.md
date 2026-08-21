# Skill: Root Cause Analysis

## Purpose

Identify the underlying defect behind a finding: the missing check, wrong
ordering, or broken invariant — not the symptom.

## Scope

- Included: causal chain, verification (E5), adjacent paths.
- Excluded: remediation (`remediation-analysis.md`).
- Layers: reporting/debugging.

## Trigger Conditions

- Every finding before remediation.
- Incident debugging.

## Inputs

- reproduction
- code

## Investigation Method

1. Identify entry points: trigger.
2. Identify trust boundaries: N/A.
3. Track relevant data: behavior chain.
4. Identify validation: the failing check.
5. Identify security-sensitive operations: the defect.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: N/A.
10. Validate the finding: fix changes behavior (E5).

## Evidence Requirements

- E5 for confirmed root cause.

## Confidence

- CONFIRMED with E5.

## Severity

- Independent.

## Safe Reproduction

- N/A.

## Root Cause

- The subject.

## Impact

- N/A.

## Remediation

- Follows from root cause.

## Regression Test

- From the reproduction.

## Common False Positives

- Treating a symptom as root cause.

## Related Skills

- `remediation-analysis.md`
- `../workflows/incident-debugging.md`
- `../templates/root-cause-analysis.md`

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

- Root cause analysis references
