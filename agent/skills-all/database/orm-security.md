# Skill: ORM Security

## Purpose

Audit ORM usage for common pitfalls: raw query fallbacks, lazy-loading surprises, mass assignment via models, and N+1 amplification.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: orm, raw query, mass assignment orm, lazy loading.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Inventory ORM usage: models, eager/lazy loading, migrations, raw query APIs used where.
2. Check raw fallbacks: native queries with interpolation next to "safe" ORM calls.
3. Check model binding: request data mapped directly into model fields (mass assignment).
4. Check N+1 and eager-loading blindness (performance/DoS) around lists.
5. Check relationship traversal authorization: can relationships expose cross-user data (e.g., includes in GraphQL/ORM eager loads)?



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- ORM call sites cited, focusing on raw fallbacks, direct bindings, and cross-relationship loads.

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

Reproduce query/transaction behavior against a local test database with transaction rollbacks; use synthetic data.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

ORM conveniences (auto-binding, eager loads, raw escapes) used without corresponding controls.

## Impact

SQLi via raw fallbacks, mass assignment privilege escalation, performance DoS, cross-tenant data via relationships.

## Remediation

Ban raw SQL or centralize it, strict model DTOs, explicit eager-loading with authorization filters, N+1 checks.

## Regression Test

Tests asserting payloads through ORM paths are parameterized and extra fields unbound.

## Common False Positives

ORM defaults configured to parameterize and reject unknown fields; raw APIs unused in reachable paths.

## Related Skills

- query-safety.md
- sql-injection.md
- mass-assignment.md
- data-validation.md

## References

- ORM docs (SQLAlchemy/ActiveRecord/Hibernate/EF)
- CWE-89
- CWE-915

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
