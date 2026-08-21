# Skill: Backend Entrypoint Analysis

## Purpose

Analyze backend entry points (handlers, consumers, jobs, callbacks): input
handling, auth, and sinks per entry point.

## Scope

- Included: handler inventory, per-entry input validation, auth, sink
  reachability.
- Excluded: HTTP endpoint specifics (`../api/*`).
- Layers: backend.

## Trigger Conditions

- Backend audits.
- New handlers/consumers.

## Inputs

- source code

## Investigation Method

1. Identify entry points: all backend handlers/consumers.
2. Identify trust boundaries: external → logic.
3. Track relevant data: inputs per entry.
4. Identify validation: boundary validation.
5. Identify security-sensitive operations: sinks.
6. Inspect authorization: per-entry checks.
7. Inspect error handling: N/A.
8. Inspect tests: coverage.
9. Determine exploitability or correctness impact: gaps.
10. Validate the finding: per-entry tests.

## Evidence Requirements

- E1: handler code.
- E2: validation/auth gap.
- E3: test demonstrating the gap.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM–HIGH.

## Safe Reproduction

- Local handler tests.

## Root Cause

- Inconsistent per-handler controls.

## Impact

- Unvalidated/unauthorized operations.

## Remediation

- Centralized validation/auth; per-entry coverage tests.

## Regression Test

- Per-entry input/auth tests.

## Common False Positives

- Controls in shared middleware (verify).

## Related Skills

- `../reconnaissance/entrypoint-discovery.md`
- `middleware-analysis.md`
- `controller-analysis.md`

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

- OWASP ASVS V1/V5
