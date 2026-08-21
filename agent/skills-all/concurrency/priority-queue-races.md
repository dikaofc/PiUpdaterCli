# Skill: Priority Queue Races

## Purpose

Audit queue/job systems for races: claim-then-process, at-least-once vs at-most-once, and duplicate processing.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: priority queue, job race, claim, dedup.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Map queue consumers: claim semantics, visibility timeouts, retry/backoff, dead-letter paths.
2. Check claim atomicity: does claiming a job prevent parallel consumers picking the same item?
3. Check dedup: processed jobs keyed uniquely (idempotent handlers)?
4. Check visibility timeout vs processing time: slow jobs re-delivered and processed twice.
5. Check ordering assumptions: priority reordering during contention.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local double-consumer test showing duplicate processing or a claim race, with the consumer code cited.

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

Claim not atomic or idempotency missing in job handlers.

## Impact

Duplicate side effects (charges, emails, credits), job loss or reordering.

## Remediation

Atomic claim (Redis GETDEL/conditional), de-dupe keys in handlers, bounded retries, idempotent workers.

## Regression Test

Parallel-consumer tests asserting single processing per job.

## Common False Positives

At-least-once designs with idempotent handlers (correct); pure read/notification jobs where duplicates are benign.

## Related Skills

- duplicate-operation.md
- race-condition-analysis.md
- backpressure-handling.md

## References

- RabbitMQ/Celery/Bull docs
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
