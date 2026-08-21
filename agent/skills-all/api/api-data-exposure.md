# Skill: API Data Exposure

## Purpose

Audit API responses for over-exposure: excessive fields, credentials, internal metadata, and sensitive data in lists and errors.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: api data exposure, over-fetching, sensitive fields.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Compare response shapes against needed data (DTO vs full entity serialization).
2. Look for credentials/tokens/keys, internal IDs, admin flags, and internal metadata in responses.
3. Check list endpoints returning full objects instead of summaries.
4. Check search/filter endpoints leaking data via query parameters or error messages.
5. Check whether response of one user includes others' data fields (cross-tenant leaks).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local response showing sensitive fields exposed beyond the consumer's need or scope, with the serializer cited.

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

Serialization of full entities or shared DTOs that include sensitive fields.

## Impact

PII/credential disclosure, aids further attacks (password hashes, tokens, internal IDs).

## Remediation

Explicit response DTOs per endpoint, default-deny field selection, filter server-side, per-tenant serializers where needed.

## Regression Test

Contract tests asserting response schemas contain no sensitive fields.

## Common False Positives

Fields intentionally public per product spec; data already redacted at the source.

## Related Skills

- api-pagination.md
- frontend-data-exposure.md
- api-error-handling.md
- bola-analysis.md

## References

- OWASP API Security Top 10 (API3)
- CWE-200 (exposure of sensitive information)

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
