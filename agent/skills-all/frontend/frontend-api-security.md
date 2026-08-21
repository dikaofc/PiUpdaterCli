# Skill: Frontend API Security

## Purpose

Analyze frontend-to-API interaction: credentials in requests, CORS, CSRF
exposure, API key exposure, and error handling in the client.

## Scope

- Included: token handling in requests, CORS implications, CSRF exposure,
  client-side keys.
- Excluded: server API issues (`../api/*`).
- Layers: frontend.

## Trigger Conditions

- API keys/tokens in client code.
- Claims of "secure client API use" to verify.

## Inputs

- frontend code

## Investigation Method

1. Identify entry points: API calls.
2. Identify trust boundaries: client → API.
3. Track relevant data: credentials.
4. Identify validation: exposure assessment.
5. Identify security-sensitive operations: authenticated calls.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: exposure.
10. Validate the finding: code review.

## Evidence Requirements

- E1: client API code.
- E2: exposed credential/bypass.

## Confidence

- CONFIRMED with E2.

## Severity

- MEDIUM–HIGH.

## Safe Reproduction

- Local code inspection.

## Root Cause

- Embedding keys; client-side auth decisions.

## Impact

- Credential theft, API abuse.

## Remediation

- Proxy through backend; server-held keys; proper token flows.

## Regression Test

- Tests asserting no secrets in client bundles.

## Common False Positives

- Public keys by design (verify).

## Related Skills

- `../api/api-authentication.md`
- `frontend-data-exposure.md`
- `../web/cors-analysis.md`

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
- CWE-798
