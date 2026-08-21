# Skill: Worker Pool Analysis

## Purpose

Audit worker pools: sizing, task distribution, shared state between workers, and graceful shutdown.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: worker pool, concurrency, goroutine, thread pool.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find worker pools: HTTP handlers, job consumers, async task runners.
2. Check sizing: fixed vs unbounded; oversubscription risks.
3. Check task distribution: balanced, no head-of-line blocking.
4. Check shared state: workers mutating shared caches/queues safely?
5. Check shutdown: draining vs abrupt termination losing in-flight work.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test showing unbounded worker growth or shared-state corruption, with the pool config cited.

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

Unregulated spawning or unsafe shared state across workers.

## Impact

Resource exhaustion, race-condition side effects, lost work on shutdown.

## Remediation

Bounded pools, queue-based distribution, worker-safe state (atomics/immutability), graceful drain with context deadlines.

## Regression Test

Load tests asserting bounded concurrency and safe shutdown.

## Common False Positives

Pools managed by framework defaults (correctly bounded); single-threaded runtimes with async I/O.

## Related Skills

- backpressure-handling.md
- race-condition-analysis.md
- resource-exhaustion.md

## References

- CWE-770

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
