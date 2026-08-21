# Skill: API Authentication

## Purpose

Audit how API clients authenticate: token schemes, key rotation, credential storage, and bypass vectors (missing auth, weak schemes, delegation).

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: api authentication, api keys, bearer, m2m.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Enumerate auth schemes: API keys, Bearer tokens, OAuth2 client credentials, mTLS, cookies, HMAC-signed requests.
2. Check key/token strength, storage (server-side only), rotation, and scoping (per-client).
3. Verify every endpoint enforces the scheme and rejects missing/invalid credentials uniformly.
4. Check client-credential flows (service-to-service): secret exposure, replay, audience validation.
5. Test locally: hit each endpoint without/with tampered credentials and confirm rejection.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- An auth coverage table per endpoint (behaviorally verified) plus credential-handling code review of the scheme implementation.

Minimum bar: **static evidence (E1)** to open a line of inquiry; **behavioral evidence (E3)** or better for a confirmed report. See `context/evidence-model.md`.

## Confidence

Use one of:

- **CONFIRMED** — behavior reproduced and root cause validated (E3+).
- **HIGH CONFIDENCE** — strong static + data-flow evidence, controlled verification pending.
- **MEDIUM CONFIDENCE** — plausible path but some assumptions remain unverified.
- **LOW CONFIDENCE** — theoretical risk; requires validation.
- **FALSE POSITIVE** — disproven or mitigated after analysis.

Confidence is independent of severity (see `context/confidence-model.md`).

## Severity

Assess severity from actual **impact + exploitability + required privileges + interaction + affected scope + data sensitivity** (see `context/severity-model.md`). Do not automatically label this class CRITICAL. A finding must earn its severity from evidence.

Typical range for this skill: LOW–HIGH depending on reachability and data sensitivity.

## Safe Reproduction

Use a local API with seeded mock data and a scratch test user/tenant; assert with integration tests, not against production.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Auth enforced selectively, or credentials stored/exposed insecurely (logs, client-side, default keys).

## Impact

Unauthenticated API access, credential theft, abuse of service identities.

## Remediation

Enforce auth globally (default-deny), server-side secret management, per-client scoped keys, rotation policy, mTLS where appropriate.

## Regression Test

Tests asserting unauthenticated/tampered requests fail for every endpoint; rotation tests.

## Common False Positives

Public endpoints intentionally unauthenticated; auth enforced via a gateway not visible in the app code.

## Related Skills

- authentication-flow-analysis.md
- api-authorization.md
- token-generation.md
- cloud-iam-analysis.md

## References

- OWASP API Security Top 10 (API2/API7)
- NIST SP 800-63B

## Review Checklist

- [ ] Entry point identified
- [ ] Trust boundary identified
- [ ] Data flow understood
- [ ] Validation checked
- [ ] Authorization checked
- [ ] Runtime behavior verified
- [ ] Evidence collected (E1–E5 level recorded)
- [ ] Severity assigned (impact-based)
- [ ] Confidence assigned (separate from severity)
- [ ] Root cause identified
- [ ] Remediation proposed
- [ ] Regression test proposed
