# Skill: Dangerous Change Analysis

## Purpose

Identify high-risk changes: auth, crypto, parser, dependency, and
infrastructure changes needing extra scrutiny.

## Scope

- Included: risk classification of changes, required reviews.
- Excluded: detailed review (other skills).
- Layers: change triage.

## Trigger Conditions

- PR triage.
- Change classification.

## Inputs

- diffs
- file mappings

## Investigation Method

1. Identify entry points: changed files.
2. Identify trust boundaries: N/A.
3. Track relevant data: risk areas.
4. Identify validation: risk classification.
5. Identify security-sensitive operations: flagged areas.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: risk level.
10. Validate the finding: confirm classification.

## Evidence Requirements

- E1: file-level evidence.

## Confidence

- HIGH for clear classifications.

## Severity

- N/A (triage).

## Safe Reproduction

- N/A.

## Root Cause

- N/A.

## Impact

- Focuses review effort.

## Remediation

- Route high-risk changes through security review + tests.

## Regression Test

- N/A.

## Common False Positives

- Misclassified low-risk files as high-risk (verify content).

## Related Skills

- `security-code-review.md`
- `pull-request-review.md`
- `../workflows/security-review.md`

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

- Code review risk models
