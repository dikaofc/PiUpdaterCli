# Skill: Transaction Integrity

## Purpose

Audit invariants enforced by transactions: uniqueness, balance checks, state transitions, and referential integrity.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: transaction integrity, invariant, uniqueness, constraints.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. List critical invariants: unique keys, non-negative balances, state machine legality, referential integrity, sum-of-parts consistency.
2. Check enforcement: DB constraints vs app-level checks (race-prone).
3. Check constraint timing: validated within the same transaction as the write?
4. Check bulk operations preserving invariants (batch updates, migrations).
5. Test locally with concurrent writers hitting the invariant.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local concurrent test breaking an invariant enforced only at app level, with the constraint code/DDL cited.

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

Invariants enforced in application code instead of database constraints.

## Impact

Duplicate records, negative balances, illegal states, data corruption.

## Remediation

Move invariants into DB constraints (UNIQUE, CHECK, FOREIGN KEY), validate state transitions transactionally, retry on conflicts.

## Regression Test

Concurrent tests asserting constraint violations are rejected at the DB level.

## Common False Positives

Soft-constraints with documented compensation flows; validators applied before unique writes with proper conflict handling.

## Related Skills

- transaction-analysis.md
- race-condition-database.md
- priority-queue-races.md

## References

- SQL CHECK/UNIQUE semantics
- CWE-362

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
