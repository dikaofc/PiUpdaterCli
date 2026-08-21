# Skill: Lock Management

## Purpose

Audit locking: lock scope, deadlock potential, lock timeout/lease, and failure-release semantics.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: lock, mutex, deadlock, lease, distributed lock.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find locks: in-process mutexes, DB row locks, Redis distributed locks.
2. Check scope: lock covers the full critical section including the check?
3. Check deadlock potential: nested lock ordering, lock waits outside the lock.
4. Check leases/timeouts: lock released on holder crash (TTL) or held forever?
5. Check failure paths: exceptions release locks? retry loops respect order?



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test showing lock scope gap (check outside lock) or deadlock/hang, with the lock code cited.

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

Locks too narrow, no TTL, or nested-ordering hazards.

## Impact

Deadlock DoS, race windows, stuck jobs.

## Remediation

Enclose check+act in the lock, consistent lock ordering, leases with renew, try-with-resources/finally release.

## Regression Test

Concurrent tests asserting serialization and lock release on failure.

## Common False Positives

Locks only for performance (not correctness) with race-tolerant logic.

## Related Skills

- race-condition-analysis.md
- transaction-analysis.md
- distributed-system-analysis.md

## References

- CWE-833 (deadlock)
- CWE-362
- Redis Redlock docs

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
