# Skill: Server-Side Authorization

## Purpose

Verify authorization decisions are made server-side: never trust client-supplied roles, ownership, or feature flags.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: server side authorization, trust client, client claims.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find where authorization attributes come from: session/DB server-side vs request fields.
2. Search for client-controlled authorization signals: role in body, isAdmin query, feature flags from the client.
3. Check hidden-UI-only protections (buttons hidden but endpoints open).
4. Check client-side route guards as the only defense.
5. Test locally: bypass the client by calling the API directly with forged attributes.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A direct API call with forged client attributes succeeding, with the trust line cited.

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

Create two or more test users/tenants in a local environment and write integration tests asserting denied access.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Enforcing authorization on the client or accepting client-provided attributes.

## Impact

Trivial privilege escalation and data access regardless of UI.

## Remediation

Derive all authorization attributes server-side, enforce checks in the service layer, treat the client as a reference implementation only.

## Regression Test

Direct-API tests replaying every UI-gated action without the UI.

## Common False Positives

Client attributes that are cosmetic (server re-derives them).

## Related Skills

- client-side-authorization.md
- access-control-analysis.md
- parameter-tampering.md

## References

- OWASP Authorization Cheat Sheet
- CWE-602 (client-side enforcement of server-side security)

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
