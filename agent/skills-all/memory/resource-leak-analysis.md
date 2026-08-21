# Skill: Resource Leak Analysis

## Purpose

Find resource leaks: file handles, DB connections, sockets, and memory retention (caches) in error paths.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: resource leak, connection leak, cache retention, memory leak.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find resource acquisition: files, streams, connections, clients, locks.
2. Check release on every path: success AND error/exception paths close resources.
3. Check connection pools: are connections returned on errors? Max sizes sane?
4. Check caches/singletons: unbounded growth, missing eviction?
5. Observe locally: repeated failing requests increasing handle/memory usage.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local repeated-failure run showing handle/memory growth, with the resource code cited.

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

Use sanitizers (ASan/Valgrind), load tests against local services, and bounded resource limits to reproduce exhaustion.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Resources released only on happy paths or unbounded caches.

## Impact

Slow DoS (FD exhaustion, connection pool starvation, memory growth).

## Remediation

Use try-with-resources/finally, pool configs with proper return, bounded caches with eviction.

## Regression Test

Load tests with failure injection asserting stable handles/memory.

## Common False Positives

One-shot processes (short-lived lambdas); caches with documented TTL and eviction.

## Related Skills

- memory-safety-analysis.md
- backpressure-handling.md
- connection-pool-analysis.md

## References

- CWE-401 (missing release)
- CWE-404 (improper resource shutdown)

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
