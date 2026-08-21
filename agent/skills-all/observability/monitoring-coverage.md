# Skill: Monitoring Coverage

## Purpose

Analyze monitoring coverage: whether security and reliability events are
observable and monitored for detection.

## Scope

- Included: metric/event coverage, detection gaps, dashboards.
- Excluded: alerting rules (`alerting-correctness.md`).
- Layers: observability.

## Trigger Conditions

- Security operations review.
- Claims of "monitored" to verify.

## Inputs

- monitoring configs
- code (metrics)

## Investigation Method

1. Identify entry points: monitored events.
2. Identify trust boundaries: N/A.
3. Track relevant data: N/A.
4. Identify validation: coverage vs events.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: blind spots.
10. Validate the finding: config review.

## Evidence Requirements

- E1: monitoring configs.
- E2: coverage gap.

## Confidence

- CONFIRMED with E2.

## Severity

- LOW–MEDIUM (detection gap).

## Safe Reproduction

- N/A.

## Root Cause

- Missing instrumentation.

## Impact

- Undetected incidents.

## Remediation

- Instrument security events; coverage reviews.

## Regression Test

- N/A.

## Common False Positives

- Events monitored elsewhere (verify).

## Related Skills

- `alerting-correctness.md`
- `audit-trail-analysis.md`
- `../dynamic-analysis/runtime-instrumentation.md`

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

- Observability references
