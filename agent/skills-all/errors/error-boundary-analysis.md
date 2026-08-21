# Skill: Error Boundary Analysis

## Purpose

Analyze error boundaries: centralized error handling that converts exceptions
to safe responses, prevents crashes, and preserves state.

## Scope

- Included: global error handlers, boundary coverage, crash containment,
  error-state cleanup.
- Excluded: exception correctness (`exception-analysis.md`).
- Layers: framework boundaries.

## Trigger Conditions

- Missing central error handlers.
- Claims of "handled globally" to verify.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: request/process boundaries.
2. Identify trust boundaries: N/A.
3. Track relevant data: exception flow.
4. Identify validation: boundary handler coverage.
5. Identify security-sensitive operations: state changes.
6. Inspect authorization: N/A.
7. Inspect error handling: the subject.
8. Inspect tests: boundary tests.
9. Determine exploitability or correctness impact: crash/leak.
10. Validate the finding: boundary tests.

## Evidence Requirements

- E1: error handler code.
- E2: uncovered boundary.
- E3: test demonstrating crash/leak without boundary.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM (availability); HIGH for crash loops.

## Safe Reproduction

- Local tests throwing at each boundary.

## Root Cause

- No central handler; per-handler error handling drift.

## Impact

- Crashes, partial responses, process death.

## Remediation

- Central error boundary; consistent error responses; crash containment.

## Regression Test

- Boundary tests asserting safe response on exceptions.

## Common False Positives

- Framework-provided boundaries (verify).

## Related Skills

- `exception-analysis.md`
- `../api/api-error-handling.md`
- `fallback-security.md`

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

- OWASP Error Handling Cheat Sheet
- CWE-248
