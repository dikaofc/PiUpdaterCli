# Skill: Permission Inheritance

## Purpose

Audit inheritance models (role hierarchies, group memberships, org trees, project access) for over-granting and path-confusion.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: permission inheritance, group membership, hierarchy.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Map the inheritance model: roles→permissions, users→groups, child org→parent org, project→template.
2. Check propagation: granting at one level propagates to expected scopes only.
3. Check revocation: does revoking at a node actually remove inherited access?
4. Check cycles/duplicate paths: the same permission granted via multiple paths.
5. Test locally: grant at parent, access at child; revoke at parent, verify denial.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A tree with propagation rules cited and behavioral grant/revoke tests.

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

Inheritance implemented ad-hoc (recomputed inconsistently) or revocation not propagated.

## Impact

Over-granted access after org changes, data leakage to wrong scopes.

## Remediation

Single source of truth for inheritance (DB relations or policy engine), materialize with a consistent query, propagate revocation.

## Regression Test

Grant/revoke propagation tests across the tree.

## Common False Positives

Explicit (non-inherited) grants behaving correctly by design.

## Related Skills

- access-control-analysis.md
- role-analysis.md
- cloud-iam-analysis.md

## References

- NIST RBAC (inheritance)
- CWE-269

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
