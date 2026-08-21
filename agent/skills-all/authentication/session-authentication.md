# Skill: Session Authentication

## Purpose

Audit how authenticated sessions are created from credentials/tokens and verified on each request.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: session auth, session verification, middleware.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find session verification middleware: where the session/token is validated per request.
2. Check binding: session tied to user ID, and checked against revocation (session store)?
3. Check freshness/expiry enforced on each request (not just at issuance).
4. Check alternate entry points using weaker verification (in-memory sessions, cached auth results).
5. Test locally: tamper session data, replay old tokens, cross-user session values.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A per-request verification flow with binding/expiry cited, plus tamper/replay behavioral tests.

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

Session verification incomplete (data not re-checked, expiry ignored, store not consulted).

## Impact

Session hijacking/tampering, stale-session privilege retention.

## Remediation

Server-side session store, bind to user+device, check revocation/expiry per request, constant-time comparisons.

## Regression Test

Tests asserting revoked/expired/tampered sessions fail on every authenticated path.

## Common False Positives

Stateless JWT designs with short TTL and key rotation considered under jwt-analysis instead.

## Related Skills

- session-management.md
- authentication-flow-analysis.md
- jwt-analysis.md
- token-replay.md

## References

- OWASP Session Management Cheat Sheet
- CWE-384 (session fixation)

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
