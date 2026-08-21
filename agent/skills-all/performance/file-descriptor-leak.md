# Skill: File Descriptor Leak

## Purpose

Analyze file descriptor leaks: files/streams/sockets opened without closing,
exhausting the fd limit.

## Scope

- Included: file/stream/socket lifecycle, close on error paths.
- Excluded: connections (`connection-leak.md`).
- Layers: runtime.

## Trigger Conditions

- Manual file/socket handling.
- Claims of "no leaks" to verify.

## Inputs

- source code

## Investigation Method

1. Identify entry points: open operations.
2. Identify trust boundaries: N/A.
3. Track relevant data: fd lifecycle.
4. Identify validation: close coverage.
5. Identify security-sensitive operations: N/A (availability).
6. Inspect authorization: N/A.
7. Inspect error handling: close on errors.
8. Inspect tests: leak tests.
9. Determine exploitability or correctness impact: exhaustion.
10. Validate the finding: fd-count tests.

## Evidence Requirements

- E1: open/close code.
- E2: leak path.
- E3: test demonstrating fd growth.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM.

## Safe Reproduction

- Local tests counting fds over iterations.

## Root Cause

- Missing close; exceptions before close.

## Impact

- Fd exhaustion, open-file limits, crashes.

## Remediation

- Resource wrappers (with/RAII); close in finally.

## Regression Test

- Tests asserting fd stability.

## Common False Positives

- OS/GC reaping (verify).

## Related Skills

- `connection-leak.md`
- `resource-exhaustion.md`
- `../files/path-traversal.md`

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

- OS fd docs
- CWE-404
