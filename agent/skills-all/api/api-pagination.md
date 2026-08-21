# Skill: API Pagination

## Purpose

Audit pagination for completeness, enumeration safety, ordering stability, and authorization consistency across pages.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: pagination, cursor, offset, enumeration.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find paginated list endpoints: offset/limit, cursor, page params.
2. Check limits: maximum page size enforced? (offset-based can be DoS-heavy), negative/zero/huge values handled safely?
3. Check ordering stability: unordered pagination can skip/duplicate records (correctness).
4. Check authorization on pagination: can a user iterate over others' records by advancing pages (enumerable data)?
5. Check cursor tampering: signed/validated or can arbitrary cursors jump scopes?



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test showing pagination can be used to enumerate beyond the caller's scope, or breaks with unstable ordering/limits.

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

Owner-filter applied per-page but not enforced as a query invariant, or pagination params unvalidated.

## Impact

Mass enumeration of other users' data, resource exhaustion via huge offsets.

## Remediation

Cursor-based pagination with server-derived cursors, enforce max limits, filter by owner in the query itself.

## Regression Test

Tests asserting cross-page scope stability and limit enforcement.

## Common False Positives

List endpoints already scoped by the authenticated user in the query; public list endpoints.

## Related Skills

- api-data-exposure.md
- bola-analysis.md
- boundary-validation.md

## References

- OWASP API Security Top 10
- CWE-639

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
