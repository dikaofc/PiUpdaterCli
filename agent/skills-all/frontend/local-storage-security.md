# Skill: Local Storage Security

## Purpose

Analyze localStorage security specifically: sensitive values, lack of
isolation, and XSS exposure of everything stored.

## Scope

- Included: localStorage tokens/keys/PII, exposure to XSS, cross-tab
  persistence.
- Excluded: other storage (`browser-storage.md`).
- Layers: frontend.

## Trigger Conditions

- Auth tokens in localStorage.
- Claims of "secure client storage" to verify.

## Inputs

- frontend code

## Investigation Method

1. Identify entry points: localStorage access.
2. Identify trust boundaries: N/A.
3. Track relevant data: stored values.
4. Identify validation: sensitivity.
5. Identify security-sensitive operations: auth state.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: storage tests.
9. Determine exploitability or correctness impact: theft.
10. Validate the finding: code review.

## Evidence Requirements

- E1: localStorage code.
- E2: sensitive value stored.

## Confidence

- CONFIRMED with E2.

## Severity

- MEDIUM–HIGH depending on value.

## Safe Reproduction

- Local code inspection.

## Root Cause

- Storing tokens in localStorage for convenience.

## Impact

- Token theft via any XSS.

## Remediation

- Prefer httpOnly cookies; if unavoidable, minimize lifetime and validate
  server-side.

## Regression Test

- Tests asserting no tokens in localStorage.

## Common False Positives

- Non-sensitive preference data (verify).

## Related Skills

- `browser-storage.md`
- `../session/cookie-security.md`
- `frontend-auth-state.md`

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

- OWASP HTML5 Security Cheat Sheet
- CWE-922
