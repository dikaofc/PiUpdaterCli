# Skill: Credential Stuffing Defense

## Purpose

Assess defenses against credential stuffing and mass password abuse: rate limits, breach checks, anomaly detection, CAPTCHA gates.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: credential stuffing, password spraying, rate limit login.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Check login rate limiting: per-account and per-IP, distributed, applied before password verification cost.
2. Check breach-list rejection of known-bad passwords (stops reuse of stuffing lists).
3. Check anomaly signals: sudden geographic/IP/device changes, high failure rates, MFA challenges on anomalies.
4. Check CAPTCHA/step-up gates after repeated failures.
5. Verify limits are not bypassable by rotating proxies/IP headers.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local burst test showing limit enforcement or bypass, plus the config/algorithm cited.

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

Missing or bypassable rate limiting and no breach-list checks.

## Impact

Mass account takeover for users with reused passwords.

## Remediation

Distributed per-account+IP rate limits, breach-list password checks, anomaly-based step-up auth, CAPTCHA after failures.

## Regression Test

Automated stuffing-simulation tests asserting account-level limits and breach-list rejection.

## Common False Positives

Defenses enforced by WAF/Auth0/Okta layers; limits correctly keyed on strong identity.

## Related Skills

- bruteforce-defense.md
- password-policy.md
- api-rate-limiting.md
- mfa-analysis.md

## References

- OWASP Credential Stuffing Prevention Cheat Sheet
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
