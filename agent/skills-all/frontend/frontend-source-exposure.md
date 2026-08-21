# Skill: Frontend Source Exposure

## Purpose

Analyze frontend source exposure: source maps, comments, internal logic, and
secrets leaking through shipped bundles.

## Scope

- Included: source maps in prod, revealing comments/keys, internal logic in
  bundles.
- Excluded: general data exposure (`frontend-data-exposure.md`).
- Layers: frontend artifacts.

## Trigger Conditions

- Source maps deployed.
- Claims of "minified only" to verify.

## Inputs

- frontend build config
- shipped bundles

## Investigation Method

1. Identify entry points: bundle assets.
2. Identify trust boundaries: N/A.
3. Track relevant data: source content.
4. Identify validation: source-map/strip settings.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: disclosure.
10. Validate the finding: bundle/source-map review.

## Evidence Requirements

- E1: build config/artifacts.
- E2: exposed source/secrets.

## Confidence

- CONFIRMED with E2.

## Severity

- LOW–MEDIUM (reconnaissance); HIGH if secrets in bundles.

## Safe Reproduction

- Local build inspection.

## Root Cause

- Source maps in prod; secrets in client code.

## Impact

- Source disclosure aiding attacks.

## Remediation

- No source maps in prod; strip comments/secrets; minimize bundle exposure.

## Regression Test

- Build assertions on source-map settings.

## Common False Positives

- Obfuscation misread as protection (still disclosable).

## Related Skills

- `frontend-data-exposure.md`
- `../secrets/hardcoded-secret-detection.md`
- `frontend-api-security.md`

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

- OWASP client-side guidance
- CWE-200
