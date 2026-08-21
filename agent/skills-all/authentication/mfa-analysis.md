# Skill: Multi-Factor Authentication (MFA) Analysis

## Purpose

Audit MFA: enrollment, verification methods, bypasses (fallback, backup codes, device binding), and step-up application.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: mfa, 2fa, totp, fallback, bypass.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Map MFA enrollment and verification: TOTP, SMS, push, hardware keys, backup codes.
2. Check enrollment: MFA session bound to the user; can an attacker enroll during a hijacked session?
3. Check fallbacks: "remember this device", SMS fallback, support-based recovery — each a bypass path.
4. Check verification: rate limited, constant-time, replay resistant (TOTP window handling).
5. Check step-up: is MFA required for the sensitive actions it claims to protect (password change, payments, admin)?



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local flow test showing an MFA bypass (fallback, weak binding, replay) or step-up gaps, with the enforcement code cited.

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

Fallback/alternative paths without equivalent assurance, or MFA not enforced where advertised.

## Impact

Account takeover despite "MFA enabled" claims.

## Remediation

Require re-authentication for MFA changes, secure backup codes (single-use, hashed), rate-limit verification, enforce step-up consistently.

## Regression Test

Tests asserting MFA cannot be removed/added without re-auth and verification tolerates no replay.

## Common False Positives

MFA enforced by an upstream IdP (Okta/Azure AD) with proper step-up; optional-MFA products where the baseline is documented.

## Related Skills

- otp-analysis.md
- authentication-flow-analysis.md
- session-authentication.md

## References

- NIST SP 800-63B (AAL)
- OWASP MFA Cheat Sheet
- CWE-308

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
