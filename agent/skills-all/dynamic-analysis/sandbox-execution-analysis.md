# Skill: Sandbox Execution Analysis

## Purpose

Analyze behavior in sandboxes: running untrusted code/artifacts in isolated
environments to observe behavior safely.

## Scope

- Included: sandbox design, egress control, observation, cleanup.
- Excluded: production systems.
- Layers: testing.

## Trigger Conditions

- Analyzing untrusted artifacts/code.
- Malware-adjacent analysis (defensive).

## Inputs

- artifacts
- sandbox infra

## Investigation Method

1. Identify entry points: artifact execution.
2. Identify trust boundaries: sandbox isolation.
3. Track relevant data: behavior.
4. Identify validation: isolation controls.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: observations.
10. Validate the finding: repeat runs.

## Evidence Requirements

- E3: sandboxed observations.

## Confidence

- HIGH with E3.

## Severity

- N/A.

## Safe Reproduction

- Isolated sandboxes with no egress; snapshots; cleanup.

## Root Cause

- N/A.

## Impact

- Safe behavioral evidence.

## Remediation

- Per findings.

## Regression Test

- Per findings.

## Common False Positives

- Sandbox-specific behavior (state environment).

## Related Skills

- `dynamic-behavior-analysis.md`
- `../context/runtime-model.md`
- `../files/parser-security.md`

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

- Sandboxing references
- CWE-693
