# Skill: Reliability and Failure Analysis

## Purpose

Audit reliability: retries, timeouts, connection handling, and failure modes that create security incidents.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: reliability, retry, timeout, failover.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find retry logic: exponential backoff? Amplified side effects on retry?
2. Check timeouts: default connect/read timeouts absent (hangs)?
3. Check failover behavior: does a standby path have the same policy enforcement?
4. Check crash recovery: restart semantics, replay of in-flight transactions.
5. Check partial outages: circuit breakers preventing cascade.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A reliability map with a specific failure mode demonstrated (e.g., retry storm or infinite hang).

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

Use fault-injection tests (chaos-style, local) that simulate partial failures; assert graceful degradation in tests.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Missing timeouts/backoff or failure paths diverging from primary security controls.

## Impact

Retry-amplified side effects, hang-based DoS, failover path misconfig incidents.

## Remediation

Timeouts everywhere, exponential backoff with jitter, circuit breakers, parity of policy on failover.

## Regression Test

Fault-injection tests asserting bounded retries and correct failover policy.

## Common False Positives

Stateless services with retry-safe operations (idempotent).

## Related Skills

- duplicate-operation.md
- backpressure-handling.md
- circuit-breaker-analysis.md

## References

- CWE-404
- Chaos engineering practices

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
