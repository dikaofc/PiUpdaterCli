# Skill: Browser Storage

## Purpose

Analyze browser storage usage: what is stored in localStorage/sessionStorage/
IndexedDB/cookies, sensitivity, and exposure to XSS and other tabs.

## Scope

- Included: storage inventory, sensitive values, XSS exposure, cross-origin
  isolation.
- Excluded: cookie attributes (`../session/cookie-security.md`).
- Layers: frontend.

## Trigger Conditions

- Tokens/PII in localStorage.
- Claims of "safe storage" to verify.

## Inputs

- frontend code

## Investigation Method

1. Identify entry points: storage writes/reads.
2. Identify trust boundaries: storage → scripts.
3. Track relevant data: stored values.
4. Identify validation: sensitivity assessment.
5. Identify security-sensitive operations: credential storage.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: storage tests.
9. Determine exploitability or correctness impact: theft via XSS.
10. Validate the finding: storage inventory review.

## Evidence Requirements

- E1: storage code.
- E2: sensitive value in JS-accessible storage.

## Confidence

- CONFIRMED with E2.

## Severity

- MEDIUM–HIGH depending on stored data.

## Safe Reproduction

- Local inspection of app storage patterns.

## Root Cause

- Storing tokens/PII in JS-accessible storage.

## Impact

- Credential theft via any XSS; cross-tab access.

## Remediation

- httpOnly cookies for tokens; minimize stored PII; short lifetimes.

## Regression Test

- Tests asserting no sensitive values in JS-accessible storage.

## Common False Positives

- Non-sensitive cache data (verify).

## Related Skills

- `local-storage-security.md`
- `../session/cookie-security.md`
- `../web/xss-analysis.md`

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
- CWE-922 / CWE-315
