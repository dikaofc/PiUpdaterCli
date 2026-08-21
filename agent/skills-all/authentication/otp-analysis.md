# Skill: OTP Analysis

## Purpose

Audit OTP flows (email/SMS/TOTP/hotp): randomness, expiry, rate limits, delivery channel security, and replay.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: otp, one-time password, totp, sms otp.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find OTP issuance and verification: code generation, delivery (SMS/email/push), storage, verification.
2. Check randomness: crypto-random 6-8 digits, no sequential/guessable codes.
3. Check expiry and retry limits: codes expire, attempts bounded, resend throttled.
4. Check channel security: SMS interception model acknowledged, email OTP to verified inbox only.
5. Check verification logic: constant-time compare, no oracle on digit correctness, single-use.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test showing guessable codes, missing attempt limits, or reusable codes, with the OTP code cited.

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

Predictable code generation or missing attempt/expiry enforcement.

## Impact

OTP bypass → account takeover; SMS OTP weaker to SIM swap (acknowledged in model).

## Remediation

Crypto-random codes, short TTL, bounded attempts with backoff, single-use, delivery to verified channels without URL leakage.

## Regression Test

Tests asserting code randomness distribution, attempt limits, and one-time use.

## Common False Positives

OTP enforced by a provider SDK with configured limits; document-chosen channels matching threat model.

## Related Skills

- mfa-analysis.md
- token-generation.md
- bruteforce-defense.md

## References

- NIST SP 800-63B (OTP verifiers)
- RFC 6238 (TOTP)
- CWE-330 (insufficient randomness)

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
