# Skill: Password Reset

## Purpose

Audit password reset flows: token strength, token delivery, expiry, user enumeration, and host-header poisoning of reset links.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: password reset, reset token, forgot password.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Map the reset flow: request → token → delivery (email/SMS) → verify → set new password.
2. Check token generation: crypto-random, single-use, expiring, bound to account and request.
3. Check token delivery: to the account's verified channel only; no token leak in URLs/logs/history.
4. Check host-header use in reset links (poisoning → token to attacker).
5. Check post-reset behavior: sessions invalidated, re-auth required for sensitive actions, no privilege change (admin resetting user).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local flow test showing token weakness, reuse, expiry failure, or host poisoning, with the token logic cited.

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

Test flows against a local auth service with disposable accounts; never brute-force real accounts.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Predictable/long-lived tokens, weak binding, or channel confusion.

## Impact

Account takeover via reset, token theft via link poisoning or logs.

## Remediation

Crypto-random expiring single-use tokens, sent to verified channels with canonical URLs, sessions invalidated after reset, uniform responses.

## Regression Test

Tests asserting token randomness, one-time use, expiry, and post-reset invalidation.

## Common False Positives

Tokens never sent via insecure channels; email broken but feature disabled; reset via SSO (no password) paved path.

## Related Skills

- token-generation.md
- host-header-analysis.md
- account-enumeration.md
- session-expiration.md

## References

- OWASP Forgot Password Cheat Sheet
- CWE-640 (weak password recovery)

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
