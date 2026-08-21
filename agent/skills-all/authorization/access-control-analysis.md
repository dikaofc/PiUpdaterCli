# Skill: Access Control Analysis

## Purpose

Systematically map roles, permissions, and access rules and verify server-side enforcement on every protected action.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: access control, authorization, permissions.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Build the access model: roles, permissions, resource owners, tenants, and the rules connecting them.
2. Find where authorization is enforced (middleware, decorators, service checks) and audit each protected action.
3. Test locally each (role, action, resource) triple: expected allow/deny.
4. Check the principal derivation: roles/tenants from server data, not client claims.
5. Check default behavior: deny by default for unknown combinations?



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- An access matrix (role × action × resource) with enforcement lines and behavioral allow/deny results.

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

Authorization scattered/inconsistent or defaulting to allow.

## Impact

Privilege escalation, unauthorized data access, admin actions by regular users.

## Remediation

Centralized policy (RBAC/ABAC library or middleware), deny-by-default, server-side principal attributes.

## Regression Test

Matrix tests covering every role×action×resource triple.

## Common False Positives

Checks inherited from a base class/middleware verified across routes; resources intentionally public.

## Related Skills

- role-analysis.md
- server-side-authorization.md
- vertical-privilege-escalation.md
- horizontal-privilege-escalation.md

## References

- OWASP Authorization Cheat Sheet
- NIST RBAC (INCITS 359)
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
