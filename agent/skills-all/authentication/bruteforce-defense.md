# Skill: Brute-Force Defense

## Purpose

Assess brute-force protection: per-account lockout/backoff, oracles (error timing), and DoS trade-offs.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: bruteforce, lockout, backoff, throttling.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Check failure handling: lockout after N failures? Exponential backoff? Delays?
2. Check lockout scope: account or IP? Can lockout be used to DoS other users (account lockout attack)?
3. Check timing oracles: distinguishable responses/timings for "user exists" vs "wrong password".
4. Check verification function cost (fast hash = fast brute force; pwverify with high cost is itself a defense).
5. Test locally: simulate repeated failures and verify the throttle/lockout behavior.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local failure-simulation test showing throttling behavior (or its absence) and any oracle, with the defense code cited.

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

Missing per-account throttling or lockout, or lockout keyed trivially (IP-only, spoofable).

## Impact

Bulk password guessing, account takeover, or DoS via account lockout.

## Remediation

Exponential backoff per account+IP, CAPTCHA instead of hard lockout, constant-time generic errors, expensive verification hashing.

## Regression Test

Tests asserting backoff/lockout behavior after N failures without creating false positives on legit users.

## Common False Positives

Throttles at the gateway; slow hash alone being an intentional rate control; generic errors already hiding oracles.

## Related Skills

- credential-stuffing-defense.md
- account-enumeration.md
- api-rate-limiting.md
- otp-analysis.md

## References

- OWASP Authentication Cheat Sheet
- OWASP Abuse of Authentication
- CWE-307 (improper restriction of excessive authentication attempts)

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
