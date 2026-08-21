# Skill: Email Verification

## Purpose

Audit email verification/signup confirmation: token handling, channel binding, verification bypass, and abuse (open signup flows).

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: email verification, signup confirmation, email change.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Map verification flows: signup confirmation, email change, re-verification.
2. Check token handling: crypto-random, single-use, expiring, bound to the new address and account.
3. Check verification bypass: setting verified=true directly, race on re-send, token reuse across addresses.
4. Check email-change flows: does changing email require current-email verification or re-auth?
5. Check what verified status gates: privilege, notifications, money movement?



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test showing a verification bypass or token weakness, with the verification logic cited.

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

Verification not enforced as a state transition (any write to verified flag) or token mishandling.

## Impact

Account hijack via unverified addresses, spam abuse of open verification, privilege bypass.

## Remediation

Strict verified-state transitions, crypto-random expiring tokens, re-auth for email changes, uniform rate limits on re-send.

## Regression Test

Tests asserting tokens are single-use/expiring and that verified state cannot be set except via the flow.

## Common False Positives

Optional verification features (no security gate) — assess per product rules.

## Related Skills

- password-reset.md
- login-state-machine.md
- token-generation.md

## References

- OWASP Authentication Cheat Sheet
- CWE-287 (improper authentication)

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
