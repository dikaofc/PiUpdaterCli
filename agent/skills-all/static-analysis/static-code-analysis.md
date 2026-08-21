# Skill: Static Code Analysis

## Purpose

Perform static code analysis: systematic code inspection and tool-assisted
analysis (SAST) to find defect candidates, with validation.

## Scope

- Included: manual inspection patterns, SAST tool usage, result validation.
- Excluded: runtime analysis (`../dynamic-analysis/*`).
- Layers: source.

## Trigger Conditions

- Audit kickoff (static pass).
- SAST findings triage.

## Inputs

- source code
- SAST reports

## Investigation Method

1. Identify entry points: high-risk code.
2. Identify trust boundaries: N/A.
3. Track relevant data: candidate paths.
4. Identify validation: rule checks.
5. Identify security-sensitive operations: sinks.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: candidates.
10. Validate the finding: every candidate needs data-flow/runtime validation.

## Evidence Requirements

- E1: static evidence.
- E2+: candidates must progress up the evidence ladder before reporting.

## Confidence

- Per evidence level; SAST hits alone are LOW.

## Severity

- Not assignable from static alone.

## Safe Reproduction

- N/A (static pass feeds controlled reproductions).

## Root Cause

- N/A (supports root-cause work).

## Impact

- Efficient candidate discovery.

## Remediation

- Fix validated candidates per root cause.

## Regression Test

- For confirmed candidates.

## Common False Positives

- SAST noise; patterns without reachability — the primary FP source.

## Related Skills

- `taint-analysis.md`
- `data-flow-analysis.md`
- `call-graph-analysis.md`
- `../testing/security-test-design.md`

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

- OWASP Source Code Analysis Tools
- CWE
