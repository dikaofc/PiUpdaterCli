# Skill: Data Flow Analysis

## Purpose

Analyze data flow statically: complete source → transformation → validation →
authorization → sink modeling to validate or kill findings.

## Scope

- Included: flow modeling, validation points, encoding, authorization.
- Excluded: runtime confirmation (`../dynamic-analysis/*`).
- Layers: source.

## Trigger Conditions

- Validating any injection/leak finding.
- Understanding data paths.

## Inputs

- source code

## Investigation Method

1. Identify entry points: sources.
2. Identify trust boundaries: crossings.
3. Track relevant data: full path.
4. Identify validation: checks per step.
5. Identify security-sensitive operations: sinks.
6. Inspect authorization: per step.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: path verdict.
10. Validate the finding: confirm path; escalate to E3 for reports.

## Evidence Requirements

- E2 minimum for path claims; E3 for reporting findings.

## Confidence

- E2 = MEDIUM; E3+ = HIGH/CONFIRMED.

## Severity

- Per sink.

## Safe Reproduction

- Controlled tests for reported paths.

## Root Cause

- N/A (models paths).

## Impact

- Foundation of evidence-based findings.

## Remediation

- Per finding.

## Regression Test

- Per confirmed finding.

## Common False Positives

- Incomplete modeling missing downstream sanitizers.

## Related Skills

- `taint-analysis.md`
- `call-graph-analysis.md`
- `../context/data-flow-analysis.md`

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
- CWE
