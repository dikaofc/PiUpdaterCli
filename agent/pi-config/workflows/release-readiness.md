# Workflow: Release Readiness

## Purpose

Gate a release on a defined set of security and correctness checks. Produces a
clear GO / GO-WITH-WAIVERS / NO-GO decision with evidence.

## Method

### 1. Change Inventory

- List commits/changes since the last release; classify risk: auth, payments,
  parsers, dependencies, infra, config changes are high-risk.

### 2. Security Review of Changes

- Run `security-review.md` over the change set.
- Re-run dependency audit (`dependency-audit.md`) for new/changed dependencies.
- Re-run configuration audit (`configuration-audit.md`) if config changed.

### 3. Checklist Gates

- `../checklists/pre-release.md` — every item must pass or be waived.
- Auth, authorization, API, database, secrets, logging, error-handling,
  performance checklists as applicable to the changes.

### 4. Testing Gates

- Full test suite green (unit + integration + e2e).
- Regression tests for every confirmed bug since last release.
- Negative/boundary tests for high-risk changes (`negative-testing.md`,
  `boundary-testing.md`).
- Any new confirmed HIGH/CRITICAL finding: fixed + regression test, or waived with
  explicit risk acceptance.

### 5. Remediation Status

- Open HIGH/CRITICAL: must be fixed or explicitly accepted by the owner.
- Open MEDIUM: scheduled with owners; may release with documented risk.
- Open LOW/INFORMATIONAL: tracked, non-blocking.

### 6. Decision

- **GO** — all gates pass.
- **GO-WITH-WAIVERS** — documented, owner-accepted waivers; list them.
- **NO-GO** — blocking findings unfixed or gates unmet; state exactly what must
  change to reach GO.

## Output

`../templates/audit-summary.md` in release form: change inventory, gate results,
waivers, decision, residual risk statement.

## Related

- `../checklists/pre-release.md`
- `../workflows/security-review.md`, `../workflows/dependency-audit.md`
- `../skills/testing/regression-testing.md`
