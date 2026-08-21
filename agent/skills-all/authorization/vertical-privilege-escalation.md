# Skill: Vertical Privilege Escalation

## Purpose

Find vertical escalation: regular users performing privileged (admin/moderator/owner) actions.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: vertical privesc, privilege escalation, admin access.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Map privileged functions: admin CRUD, user management, config, moderation, billing.
2. Check the role check at each; test as a regular user.
3. Check "is_admin" style client fields, role-flip endpoints, and hidden privileged routes.
4. Check versioned/deprecated privileged endpoints with missing checks.
5. Check privileged operations reachable through unprivileged APIs (proxy functions).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A behavioral test as a lower-privilege user reaching a privileged function, with the missing check cited.

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

Privileged functions guarded only by UI visibility or absent server checks.

## Impact

Full admin takeover, mass modification, data breach.

## Remediation

Server-side role/permission enforcement on every privileged path, deny-by-default, audit logs.

## Regression Test

Role-matrix tests covering (regular role × privileged action).

## Common False Positives

Admin actions guarded by gateway/Identity-aware proxies; role-switch endpoints with server-side validation.

## Related Skills

- bfla-analysis.md
- admin-function-protection.md
- role-analysis.md

## References

- OWASP Authorization Cheat Sheet
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
