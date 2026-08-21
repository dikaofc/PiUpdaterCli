# Skill: Token Replay

## Purpose

Detect token replay: tokens usable multiple times, across contexts, or after revocation/expiry.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: token replay, replay attack, nonce.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Identify bearer tokens: JWTs, API keys, OTPs, signed URLs, webhook signatures — and their use counts.
2. Check one-time usage: are tokens single-use or reusable for the same operation?
3. Check context binding: audience, scope, nonce, request-specific data signed into the token.
4. Check revocation: can a stolen token be revoked, and is it checked?
5. Test locally: replay the token for the same/different requests and observe acceptance.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local replay test showing the same token accepted across operations or after expiry, with the verification code cited.

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

Drive a local app with a test client that captures cookies/tokens; assert cookie flags and expiry in automated tests.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Tokens authenticate the principal but not the operation/context, and lack revocation/one-time semantics where needed.

## Impact

Authorization-code replay, payment replay, webhook replay, session reuse.

## Remediation

Bind tokens to context (audience/scope/nonce/one-time), enforce expiry and revocation, use nonces for idempotent operations.

## Regression Test

Replay tests asserting rejection for consumed, expired, and context-mismatched tokens.

## Common False Positives

Long-lived access tokens by design (with rotation and revocation); idempotency keys deliberately allowing safe retries.

## Related Skills

- jwt-analysis.md
- token-generation.md
- replay-protection.md
- logout-security.md

## References

- OWASP Session Management Cheat Sheet
- CWE-294 (authentication bypass by capture-replay)

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
