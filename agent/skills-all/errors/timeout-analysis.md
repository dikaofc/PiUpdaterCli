# Skill: Timeout Analysis

## Purpose

Analyze timeouts: missing/infinite timeouts on external calls, work, and
connections causing hangs and resource exhaustion.

## Scope

- Included: HTTP/DB/queue timeouts, connection timeouts, per-request work
  timeouts, hanging threads/tasks.
- Excluded: retry behavior (`retry-analysis.md`).
- Layers: integration + runtime.

## Trigger Conditions

- External calls without timeouts.
- Claims of "timeout configured" to verify.

## Inputs

- source code
- configs
- tests

## Investigation Method

1. Identify entry points: external calls/work.
2. Identify trust boundaries: N/A.
3. Track relevant data: call duration limits.
4. Identify validation: timeout presence/values.
5. Identify security-sensitive operations: N/A (availability).
6. Inspect authorization: N/A.
7. Inspect error handling: timeout failures handled.
8. Inspect tests: hang tests.
9. Determine exploitability or correctness impact: hangs.
10. Validate the finding: slow-service tests.

## Evidence Requirements

- E1: call code.
- E2: missing timeout.
- E3: test demonstrating hang/exhaustion (with test timeouts).

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM–HIGH (availability).

## Safe Reproduction

- Local tests with a slow mock service; assert bounded duration.

## Root Cause

- Default-infinite timeouts; no per-request deadlines.

## Impact

- Hangs, thread/connection exhaustion, cascading failures.

## Remediation

- Set timeouts on all external calls; propagate deadlines; context timeouts.

## Regression Test

- Tests asserting bounded completion with slow mocks.

## Common False Positives

- Defaults in HTTP clients providing timeouts (verify).

## Related Skills

- `retry-analysis.md`
- `../performance/connection-leak.md`
- `../performance/resource-exhaustion.md`

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

- Network/framework timeout docs
- CWE-404 / CWE-400
