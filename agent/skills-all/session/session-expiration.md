# Skill: Session Expiration

## Purpose

Audit session expiry: absolute and idle timeouts, enforcement server-side, and outstanding tokens after expiry.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: session expiration, idle timeout, absolute timeout.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find expiry configuration: session TTL, idle timeout, sliding vs absolute.
2. Check enforcement: is expiry checked per request, or only at issuance?
3. Check long-lived tokens (remember me) and refresh tokens: same expiry rigor?
4. Check expiry state: after expiry, are cached copies/short-lived JWTs still honored?
5. Check compliance needs (session duration policies for sensitive systems).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- Config values and the per-request expiry check cited; a test showing expired data still honored if enforcement is absent.

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

Expiry declared but not enforced per request, or refresh paths with unbounded lifetimes.

## Impact

Stolen sessions usable long after user logout/timeout, compliance failures.

## Remediation

Enforce absolute+idle timeouts per request, cap refresh lifetimes, revoke on expiry, short-lived tokens with rotation.

## Regression Test

Time-based tests (injectable clock) asserting expired sessions are rejected.

## Common False Positives

Stateless JWT with intentionally short TTL; idle timeout enforced by the auth framework.

## Related Skills

- session-management.md
- logout-security.md
- token-replay.md
- jwt-analysis.md

## References

- OWASP Session Management Cheat Sheet
- CWE-613 (insufficient session expiration)

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
