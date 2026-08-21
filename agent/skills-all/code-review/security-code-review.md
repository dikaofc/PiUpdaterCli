# Skill: Security Code Review

## Purpose

Perform security-focused code review: systematically reviewing code changes or
files for security defects with evidence.

## Scope

- Included: review scope, checklist application, finding validation.
- Excluded: correctness-only review (`../code-review` variants).
- Layers: any.

## Trigger Conditions

- Pre-merge security review.
- Security-audit component review.

## Inputs

- code/diff
- context

## Investigation Method

1. Identify entry points: changed code paths.
2. Identify trust boundaries: crossings.
3. Track relevant data: data flows.
4. Identify validation: checks.
5. Identify security-sensitive operations: sinks.
6. Inspect authorization: checks.
7. Inspect error handling: N/A.
8. Inspect tests: coverage.
9. Determine exploitability or correctness impact: candidates.
10. Validate the finding: candidates need E2+/E3 before reporting.

## Evidence Requirements

- E1 candidates; E2+ for reported findings.

## Confidence

- Per evidence.

## Severity

- Per impact.

## Safe Reproduction

- Controlled tests for reported findings.

## Root Cause

- Per finding.

## Impact

- Pre-merge security defects.

## Remediation

- Per finding with regression tests.

## Regression Test

- Per confirmed finding.

## Common False Positives

- Pattern matches without reachability.

## Related Skills

- `diff-review.md`
- `pull-request-review.md`
- `dangerous-change-analysis.md`
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

- OWASP Code Review Guide
- OWASP ASVS
