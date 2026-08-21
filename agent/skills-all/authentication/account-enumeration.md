# Skill: Account Enumeration

## Purpose

Find account enumeration: distinguishable responses for existing vs non-existing accounts across login, registration, reset, and other endpoints.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: account enumeration, user enumeration, oracle.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Test each identity-bearing flow with an existing and a non-existing account: login, password reset, registration, signup, API errors, invite flows.
2. Look for differences: status codes, response bodies, error messages, timing, email/username length behaviors.
3. Check rate-limit responses (limit always reached for existing?), captcha triggers, session cookies set.
4. Check email flows that leak presence (registration "email already in use", reset success vs failure).
5. Verify timing constantness for credential checks (hash comparison).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A controlled local test producing a distinguishable response for existing vs non-existing accounts, with the message/timing code cited.

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

Different error messages/responses/timings across the existence boundary.

## Impact

Account discovery → targeted phishing, credential stuffing lists, harassment, reset attacks.

## Remediation

Generic responses ("invalid credentials", "we sent a link if the account exists"), constant timing, and uniform rate limiting.

## Regression Test

Tests asserting identical responses/timing for both existence cases across every identity flow.

## Common False Positives

Knowingly public user directories (handle registration is public); timing differences below measurable thresholds.

## Related Skills

- login-state-machine.md
- password-reset.md
- api-error-handling.md
- bruteforce-defense.md

## References

- OWASP User Enumeration
- CWE-203 (observable response discrepancy)

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
