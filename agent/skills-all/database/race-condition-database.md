# Skill: Database Race Conditions

## Purpose

Find DB-level races: check-then-act patterns, upsert races, and lost updates without proper locking/constraints.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: database race, check then act, upsert, lost update.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find check-then-act: SELECT-then-INSERT/UPDATE deciding existence, balance, or quota.
2. Check concurrency control: unique constraints, row locks (SELECT FOR UPDATE), optimistic versioning, serializable.
3. Test locally with concurrent requests (Promise.all / threads) against the exact operation.
4. Check upsert semantics: ON CONFLICT / MERGE / INSERT IGNORE used to avoid races?
5. Check re-entrant workflows: double submission via retries creating duplicates.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local concurrent test producing lost update or double-insert, with the query lines cited.

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

Concurrent operations guarded only by application checks without DB-level enforcement.

## Impact

Double spend, quota bypass, duplicate records, balance corruption.

## Remediation

DB constraints + upserts, SELECT FOR UPDATE or atomic UPDATE ... WHERE, optimistic locks, idempotency keys.

## Regression Test

Parallel test suites hitting each race-prone path expecting exact-once outcomes.

## Common False Positives

Operations effectively serialized by unique keys in practice; single-writer systems.

## Related Skills

- race-condition.md
- transaction-integrity.md
- duplicate-request-analysis.md

## References

- OWASP Concurrency
- CWE-362
- CWE-367 (TOCTOU)

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
