# Skill: Taint Analysis

## Purpose

Trace untrusted data from sources to sinks: automated or manual taint
analysis to find unvalidated paths.

## Scope

- Included: source/sink identification, taint propagation, sanitizer checks.
- Excluded: full data-flow modeling (`data-flow-analysis.md`).
- Layers: source.

## Trigger Conditions

- Injection-focused audits.
- SAST taint findings.

## Inputs

- source code
- taint tool reports

## Investigation Method

1. Identify entry points: sources.
2. Identify trust boundaries: N/A.
3. Track relevant data: taint propagation.
4. Identify validation: sanitizers.
5. Identify security-sensitive operations: sinks.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: paths.
10. Validate the finding: paths need runtime confirmation.

## Evidence Requirements

- E1: source/sink code.
- E2: tainted path traced.
- E3: behavioral confirmation for reports.

## Confidence

- E2 gives MEDIUM; E3 gives HIGH+.

## Severity

- Per validated sink impact.

## Safe Reproduction

- Controlled tests for confirmed paths.

## Root Cause

- N/A (identifies paths).

## Impact

- Finds injection paths.

## Remediation

- Per finding.

## Regression Test

- Per confirmed path.

## Common False Positives

- Sanitizers missed by the analysis; unreachable paths.

## Related Skills

- `data-flow-analysis.md`
- `static-code-analysis.md`
- `../injection/sql-injection.md`

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

- OWASP SAST guidance
- CWE
