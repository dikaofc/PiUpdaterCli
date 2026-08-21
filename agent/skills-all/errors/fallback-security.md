# Skill: Fallback Security

## Purpose

Analyze fallback behavior: insecure fallbacks on failure (deny-all vs
allow-all, default creds, degraded auth) that weaken security when things
break.

## Scope

- Included: fail-open vs fail-closed, fallback credentials, degraded modes,
  circuit-breaker defaults.
- Excluded: retries (`retry-analysis.md`).
- Layers: resilience + auth.

## Trigger Conditions

- Catch-all fallbacks in auth/authorization.
- Circuit breakers with permissive defaults.
- Claims of "safe fallback" to verify.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: failure paths.
2. Identify trust boundaries: N/A.
3. Track relevant data: fallback decisions.
4. Identify validation: fail-closed semantics.
5. Identify security-sensitive operations: auth/authorization.
6. Inspect authorization: fallback permissions.
7. Inspect error handling: the subject.
8. Inspect tests: failure-injection tests.
9. Determine exploitability or correctness impact: insecure fallback.
10. Validate the finding: failure-injection tests.

## Evidence Requirements

- E1: fallback code.
- E2: insecure fallback identified.
- E3: test demonstrating fail-open behavior.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- HIGH for auth fail-open; MEDIUM otherwise.

## Safe Reproduction

- Local tests injecting failures and asserting fail-closed.

## Root Cause

- Fallbacks granting access on error; default-allow catch blocks.

## Impact

- Authorization bypass during outages, credential fallbacks.

## Remediation

- Fail closed by default; no fallback credentials; alert on degraded mode.

## Regression Test

- Failure-injection tests asserting secure fallback.

## Common False Positives

- Fallbacks that deny (verify direction).

## Related Skills

- `exception-analysis.md`
- `../authorization/server-side-authorization.md`
- `../patterns/secure-error-handling.md`

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
- CWE-636
