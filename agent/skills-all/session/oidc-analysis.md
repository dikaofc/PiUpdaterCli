# Skill: OpenID Connect (OIDC) Analysis

## Purpose

Audit OIDC integration: token validation (issuer, audience, signature, nonce), discovery, and session establishment from ID tokens.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: oidc, openid connect, id token, nonce, issuer.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find OIDC handshake: discovery, authorization request, token endpoint exchange, ID token verification.
2. Check ID token validation: signature via JWKS, issuer match, audience match, nonce (CSRF), expiry.
3. Check what the app trusts from the ID token: email/roles claimed vs verified, account linking rules.
4. Check discovery misconfiguration: forced issuer, insecure JWKS fetch, algorithm confusion.
5. Check session creation from OIDC: local session bound to the IdP subject and revocation of IdP sessions on logout.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- The ID-token verification code cited (claims checked) and a local test demonstrating missing validation.

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

Partial ID-token validation (signature but no issuer/audience/nonce) or trusting unverified claims.

## Impact

Token substitution, account linking takeover, replay across apps.

## Remediation

Validate signature+issuer+audience+nonce+expiry, use verified claims for auth decisions, link accounts via verified subject, propagate logout.

## Regression Test

Tests with forged issuer/audience and missing nonce asserting rejection.

## Common False Positives

OIDC handled by certified middleware (ASP.NET, Spring, Auth0 SDK) with defaults; claims documented as non-authoritative.

## Related Skills

- oauth-analysis.md
- jwt-analysis.md
- account-linking-analysis.md

## References

- OpenID Connect Core 1.0
- OWASP Authentication Cheat Sheet
- CWE-287

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
