# Skill: Admin Function Protection

## Purpose

Audit admin/operator functions: strong authorization, audit trails, step-up auth, and network/IP restrictions where appropriate.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: admin protection, admin panel, step up, audit.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Inventory admin surfaces: panels, APIs, CLI tools, support backdoors.
2. Check authorization: role checks server-side on every admin action.
3. Check step-up: MFA/re-auth required for high-impact admin actions (mass delete, user impersonation, config change).
4. Check audit logging: admin actions logged with actor, action, before/after.
5. Check exposure: admin surfaces on separate networks/IP allowlists, not discoverable publicly.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- Admin-action matrix with authorization, step-up, and audit evidence per action.

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

Admin surfaces with weak checks, no step-up, or no audit.

## Impact

Insider/hijacked-admin mass damage, untraceable changes.

## Remediation

Role checks everywhere, step-up for destructive actions, tamper-evident audit logs, network separation.

## Regression Test

Tests asserting step-up and authorization on every admin action.

## Common False Positives

Admin-only tools never exposed (internal CLI); documented break-glass procedures audited.

## Related Skills

- bfla-analysis.md
- vertical-privilege-escalation.md
- mfa-analysis.md

## References

- OWASP Authorization Cheat Sheet
- CWE-862
- NIST AC (access control)

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
