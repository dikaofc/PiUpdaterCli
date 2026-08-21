# Skill: Batch Processing Analysis

## Purpose

Audit batch jobs (cron, workers, ETL): partial failure, idempotency at scale, and resource bounds.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: batch processing, cron job, etl, partial failure.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Map batch jobs: schedules, triggers, data volumes, and outputs.
2. Check partial failure: does a mid-batch error roll back only the failing unit? Retry semantics?
3. Check idempotency at scale: re-running a partially-failed batch duplicates rows?
4. Check resource bounds: memory/time limits per batch, deadlocks or lock contention with online traffic.
5. Check access control: batch tools require auth and audit.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A batch run trace showing partial-failure handling or duplicate rows on re-run, with the job code cited.

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

Reproduce races in a local environment with barrier-based tests (Promise.all, threads) and controlled timing; never against live production.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Batch jobs written as one unit without unit-level idempotency/failure isolation.

## Impact

Data corruption, duplicate records, resource exhaustion during runs.

## Remediation

Unit-of-work granularity with idempotent upserts, resume-from-checkpoint, resource caps, monitoring.

## Regression Test

Re-run tests asserting no duplicates and correct partial-failure recovery.

## Common False Positives

Batches with transactional boundaries per item; jobs only touching non-sensitive aggregates.

## Related Skills

- transaction-analysis.md
- backpressure-handling.md
- dependency-analysis.md

## References

- CWE-362
- ETL best practices

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
