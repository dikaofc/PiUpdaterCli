# Skill: Frontend Data Exposure

## Purpose

Analyze what data the frontend receives, stores, and exposes: over-fetched
sensitive data, secrets in bundles, and data visible to any user of the page.

## Scope

- Included: API response over-fetch into frontend, secrets/keys in JS bundles,
  sensitive data in DOM/state.
- Excluded: storage specifics (`browser-storage.md`).
- Layers: frontend.

## Trigger Conditions

- Sensitive fields in frontend state/API responses.
- Claims of "client can't see X" to verify.

## Inputs

- frontend code
- API responses

## Investigation Method

1. Identify entry points: data into the client.
2. Identify trust boundaries: server → client.
3. Track relevant data: sensitive fields.
4. Identify validation: response filtering.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: response-shape tests.
9. Determine exploitability or correctness impact: exposure.
10. Validate the finding: inspect responses/bundles.

## Evidence Requirements

- E1: response/bundle evidence.
- E3: test showing sensitive data in client payloads.

## Confidence

- CONFIRMED with E3; HIGH with E1.

## Severity

- MEDIUM for sensitive over-fetch; HIGH for credentials in bundles.

## Safe Reproduction

- Local bundle/response inspection.

## Root Cause

- Returning entities to the client; bundling secrets.

## Impact

- Data disclosure to anyone with page access.

## Remediation

- Filtered responses; no secrets in client bundles; field-level data
  minimization.

## Regression Test

- Response-shape/bundle tests asserting no sensitive data.

## Common False Positives

- Data needed for legitimate UI (verify necessity).

## Related Skills

- `../api/api-data-exposure.md`
- `browser-storage.md`
- `frontend-source-exposure.md`

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

- OWASP API Security — Excessive Data Exposure
- CWE-200
