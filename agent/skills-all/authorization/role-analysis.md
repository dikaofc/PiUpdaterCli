# Skill: Role Analysis

## Purpose

Audit role modeling: role derivation, hierarchy, default roles, and role-change semantics.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: role analysis, rbac, role hierarchy, default role.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find role definitions, defaults at registration, and role-assignment logic.
2. Check role derivation: from server DB, not client claims.
3. Check hierarchy: does granting a role implicitly grant others (and is that intended/enforced)?
4. Check default role: what privileges come built-in for new accounts?
5. Check role change: re-evaluated immediately, sessions updated, and audited?



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- The role model (definitions, defaults, checks) cited with a test of the default role's privileges.

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

Role claims from client, insecure defaults, or hierarchy not reflected in checks.

## Impact

Privilege escalation by role manipulation or insecure defaults.

## Remediation

Server-side roles, minimal default, explicit hierarchy documented and enforced centrally, immediate re-evaluation on change.

## Regression Test

Tests asserting a fresh account has exactly the minimal role and privilege changes take effect.

## Common False Positives

Roles that are purely informational (permissions enforced via separate flags).

## Related Skills

- access-control-analysis.md
- vertical-privilege-escalation.md
- mass-assignment.md

## References

- NIST RBAC
- OWASP Authorization Cheat Sheet
- CWE-269 (improper privilege management)

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
