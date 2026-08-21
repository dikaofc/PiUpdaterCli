# Skill: JWT Analysis

## Purpose

Audit JWT usage: algorithm confusion, signature verification, claims trust, key handling, and expiry enforcement.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: jwt, json web token, alg none, signature verification.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find JWT issuance and verification code (libraries and versions).
2. Check verification: signature verified with the correct algorithm and key? "none"/"HS256 with RSA public key" confusion?
3. Check claims: are role/tenant/email claims trusted from the token without server-side re-derivation?
4. Check key handling: secret length, rotation, kid header validation, exposure in client code.
5. Check expiry/iat/nbf enforcement and clock-skew handling.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- The verification code cited (algorithm allowlist, key source) plus a local test demonstrating alg confusion or claim trust.

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

Defaulting to unsafe verification (algorithm from header, weak keys, unverified claims).

## Impact

Forged tokens → authentication bypass and privilege escalation.

## Remediation

Pin algorithms and keys, verify signature with constant-time comparison, validate all claims (exp, aud, iss), re-derive roles server-side, strong secrets with rotation.

## Regression Test

Tests with alg:none, cross-algorithm, expired, and tampered-claim tokens asserting rejection.

## Common False Positives

JWTs for integrity-only (non-auth) payloads with intentional design; verification delegated to a well-configured library or IdP.

## Related Skills

- token-replay.md
- token-generation.md
- oauth-analysis.md
- oidc-analysis.md

## References

- OWASP JWT Cheat Sheet
- CWE-347 (improper verification of cryptographic signature)
- jwt.io

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
