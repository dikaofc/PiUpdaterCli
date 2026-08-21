# Skill: Transaction Analysis

## Purpose

Audit transaction boundaries: atomicity, isolation levels, read-committed assumptions, and partial-failure handling.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: transaction, isolation, atomicity, commit rollback.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find transaction boundaries: where BEGIN/COMMIT/ROLLBACK wrap multi-step operations.
2. Check atomicity: can partial writes persist (missing rollback on error)?
3. Check isolation: level chosen (READ COMMITTED/REPEATABLE READ/SERIALIZABLE) vs concurrency assumptions.
4. Check long transactions: lock hold times, deadlock risk, retry behavior.
5. Check out-of-transaction side effects (emails, external calls inside/after the transaction).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A transaction map with isolation levels cited; a local test demonstrating partial-commit or anomaly (e.g., lost update).

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

Transactions too short (missing operations), wrong isolation for the invariant, or no rollback paths.

## Impact

Inconsistent data, lost updates, double-spend-adjacent errors, orphaned records.

## Remediation

Wrap invariants in transactions with correct isolation, retry deadlock victims, defer side effects until commit, use idempotent outbox patterns.

## Regression Test

Tests simulating failure mid-transaction asserting rollback and clean state.

## Common False Positives

Single-statement operations (implicitly atomic); intentionally eventual-consistent designs (documented).

## Related Skills

- transaction-integrity.md
- race-condition-database.md
- atomicity-analysis.md

## References

- PostgreSQL/MySQL isolation docs
- CWE-362 (race)

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
