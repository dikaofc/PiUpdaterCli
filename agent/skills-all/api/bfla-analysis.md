# Skill: Broken Function Level Authorization (BFLA)

## Purpose

Hunt for BFLA: regular users invoking administrative or privileged functions.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: bfla, function level authorization, privilege escalation.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Identify privileged functions: user management, role changes, config, moderation, billing, refunds, admin CRUD.
2. Check the authorization check at each: explicit role/permission vs presence-only vs none.
3. Test locally as a regular user: invoke each privileged endpoint and observe access.
4. Check alternate access paths: different methods (POST vs PUT), versioned stubs, internal handlers exposed by routing.
5. Verify checks run on every branch (early returns, helper-only checks).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A behavioral test as a lower-privilege principal succeeding on a privileged function, with the handler's (lack of) check cited.

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

Use a local API with seeded mock data and a scratch test user/tenant; assert with integration tests, not against production.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Role checks absent, applied only in UI, or bypassable via alternate paths.

## Impact

Privilege escalation, admin takeover, mass data modification.

## Remediation

Centralized permission enforcement (middleware by role/permission), deny by default, server-side checks on every privileged path.

## Regression Test

Role-matrix tests: every (role, privileged-endpoint) pair asserting expected allow/deny.

## Common False Positives

Endpoints requiring admin tokens enforced by a gateway; non-privileged equivalents (theme/admin UI is not an API function).

## Related Skills

- vertical-privilege-escalation.md
- admin-function-protection.md
- role-analysis.md

## References

- OWASP API Security Top 10 API5
- CWE-862
- CWE-863

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
