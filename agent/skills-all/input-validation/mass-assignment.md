# Skill: Mass Assignment

## Purpose

Find auto-binding of request fields directly onto models, letting clients set fields they should not control (role, owner, status, isAdmin).

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: mass assignment, auto-binding, over-posting, model binding.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find automatic binding points: Django ModelForm, Rails strong parameters gaps, Spring @ModelAttribute, ASP.NET model binding, ORM fill/update, GraphQL mutations.
2. List model fields that are sensitive if writable: role, is_admin, owner_id, tenant_id, status, balance, verified, active.
3. Check every binding site for allowlist/denylist of writable fields.
4. Test by sending an extra field (e.g., {"is_admin": true}) to each create/update endpoint and observing persistence.
5. Check nested binding: arrays of objects, relations auto-created via nested attributes, file metadata binding.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A behavioral test where a client-set unauthorized field is persisted, with the binding code cited.

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

Build local fixtures with a test HTTP server or CLI harness that feeds controlled payloads (valid, boundary, malformed) and assert behavior in unit tests.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Automatic binding without a writable-fields allowlist, or an allowlist missing a sensitive field.

## Impact

Privilege escalation, account takeover, tenant cross-contamination, data tampering.

## Remediation

Use explicit DTOs/schemas or strong-parameters allowlists; never bind directly from the raw request.

## Regression Test

A test sending every sensitive field name in a create/update request asserting none are persisted.

## Common False Positives

Fields defined in the model that are not reachable via any binding path; ORM-level guards that block writes.

## Related Skills

- schema-validation.md
- parameter-tampering.md
- api-schema-validation.md
- role-analysis.md

## References

- OWASP API Security Top 10 — mass assignment
- CWE-915 (improperly controlled modification of dynamically-identified object)

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
