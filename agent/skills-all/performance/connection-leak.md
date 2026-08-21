# Skill: Connection Leak

## Purpose

Analyze connection leaks: DB/HTTP/queue connections not closed or returned on
all paths, exhausting pools.

## Scope

- Included: pool return, close on error paths, timeout on acquire.
- Excluded: fds (`file-descriptor-leak.md`).
- Layers: runtime.

## Trigger Conditions

- Manual connection handling.
- Claims of "pool healthy" to verify.

## Inputs

- source code
- pool configs

## Investigation Method

1. Identify entry points: connection acquisition.
2. Identify trust boundaries: N/A.
3. Track relevant data: connection lifecycle.
4. Identify validation: close/return on all paths.
5. Identify security-sensitive operations: N/A (availability).
6. Inspect authorization: N/A.
7. Inspect error handling: close on exceptions.
8. Inspect tests: leak tests.
9. Determine exploitability or correctness impact: pool exhaustion.
10. Validate the finding: pool-usage tests.

## Evidence Requirements

- E1: connection code.
- E2: leak path.
- E3: test demonstrating pool exhaustion.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM–HIGH.

## Safe Reproduction

- Local tests with a small pool and error paths.

## Root Cause

- Missing close in error paths; manual management.

## Impact

- Pool exhaustion, outages.

## Remediation

- Try-with-resources/context managers; pool timeouts; central acquisition.

## Regression Test

- Tests asserting connections return on success and failure.

## Common False Positives

- Pools with built-in reaping (verify).

## Related Skills

- `file-descriptor-leak.md`
- `resource-exhaustion.md`
- `../errors/timeout-analysis.md`

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

- Connection pool docs
- CWE-404 / CWE-775
