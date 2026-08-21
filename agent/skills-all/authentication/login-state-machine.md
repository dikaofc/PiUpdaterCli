# Skill: Login State Machine

## Purpose

Audit the login state machine: pending/verified/blocked states, transitions, and logic that lets attackers skip steps.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: login state machine, auth state, pending state, bypass.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Model the auth states: anonymous, pending (unverified email/phone), MFA-pending, authenticated, blocked/suspended, expired.
2. Check each transition: what gates moving to authenticated? Are gates enforced server-side?
3. Check pending-state privileges: can an unverified user access features that require verification?
4. Check suspension/block states: can a suspended user re-authenticate through another path (OAuth link, reset)?
5. Check step sequences: MFA-skip parameters, state flags from client, or defaulting unverified → verified.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A state diagram with gates cited; a local test reaching an unauthorized state via a skipped transition.

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

Missing server-side gate between states, or client-controllable state flags.

## Impact

Authentication bypass (unverified access, suspended reactivation, MFA skip).

## Remediation

Server-side state machine with enforced transitions, re-derive state from server data, invalidate sessions on state changes.

## Regression Test

State-transition tests covering every edge (blocked→authenticated, unverified→privileged).

## Common False Positives

States that carry no privilege difference; gates enforced by the auth library defaults.

## Related Skills

- state-transition-analysis.md
- email-verification.md
- session-authentication.md
- mfa-analysis.md

## References

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
