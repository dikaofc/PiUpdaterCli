# Skill: Backpressure Handling

## Purpose

Audit queue/kafka/stream consumers and batch processing for backpressure: unbounded in-memory queues and consumer lag.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: backpressure, consumer lag, unbounded queue, batch.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find ingestion paths: HTTP request queues, message consumers, batch readers, stream processing.
2. Check buffering: unbounded in-memory queues, unlimited worker pools, no concurrency caps.
3. Check consumer lag: monitoring, max lag, dead-letter thresholds.
4. Check batch sizes and timeouts: oversized batches tying memory, slow consumers blocking.
5. Check failure loops: poison messages retried forever and blocking the queue.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local load test showing unbounded growth or lack of backpressure signaling, with the queueing code cited.

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

Missing concurrency limits and no lag/retry governance.

## Impact

Memory exhaustion, service outage, message loss.

## Remediation

Bounded queues with rejection/backoff, worker caps, lag alerts, poison-message quarantine, circuit breakers.

## Regression Test

Load tests asserting bounded memory and lag thresholds under sustained input.

## Common False Positives

Platform-managed queues with configured throttling; intentionally drop-on-overload designs documented.

## Related Skills

- resource-exhaustion.md
- api-rate-limiting.md
- batch-processing-analysis.md

## References

- CWE-770
- Kafka consumer configs

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
