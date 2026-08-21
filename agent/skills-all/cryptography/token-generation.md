# Skill: Token Generation

## Purpose

Audit token generation (session, reset, API, OTP, signed URLs): randomness, entropy, encoding, and misuse.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: token generation, entropy, base64, signed url.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find token generation sites: session IDs, reset tokens, API tokens, invite links, signed URLs, OTPs.
2. Check entropy: >=128 bits for opaque tokens, from crypto-secure RNG.
3. Check encoding: URL-safe, no truncation, correct charset.
4. Check token semantics: opaque-random vs signed (JWT) vs stateless — each needs different controls.
5. Check storage/transport: hashed at rest for high-value tokens (reset tokens), delivered over secure channels.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- Token generation code cited with entropy estimation; a local test sampling tokens for collision/uniqueness.

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

Use known-answer tests (NIST vectors) against local code; verify with unit tests, never with production keys.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Low-entropy or predictable token generation, or weak encoding reducing effective entropy.

## Impact

Token prediction → session/reset/API hijack.

## Remediation

Crypto-secure 128+ bit opaque tokens, URL-safe encoding, hashed storage for one-time tokens, expiry+revocation.

## Regression Test

Tests asserting token length/entropy and unique samples across thousands.

## Common False Positives

Tokens never exposed to clients (server-internal); test-only fixed tokens.

## Related Skills

- randomness-analysis.md
- token-replay.md
- password-reset.md
- jwt-analysis.md

## References

- OWASP Password Storage Cheat Sheet (random tokens)
- CWE-330

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
