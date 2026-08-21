# Skill: Race Condition Analysis

## Purpose

Hunt for TOCTOU and interleaving races: check-then-act, shared mutable state, and non-atomic updates.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: race condition, toctou, check then act, interleaving.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find check-then-act sequences: existence checks, balance checks, permission checks before state changes.
2. Find shared mutable state: in-memory counters, singletons, cache-then-write.
3. Test locally with concurrent requests/threads (Promise.all, goroutines) against each candidate.
4. Check non-atomic updates: read-modify-write on shared values without locks/atomics.
5. Check expand-race windows: slow I/O between check and act increases exploitability.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A reproducible concurrent test showing interleaving-induced incorrect state, with the code lines cited.

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

Non-atomic operations on shared state with no locking or DB-backed enforcement.

## Impact

Double spend/claim, limits bypass, inconsistent state, privilege mis-grant.

## Remediation

Atomic operations (UPDATE...WHERE, CAS, locks, mutex), single-writer ownership, idempotency keys.

## Regression Test

Stress tests running N concurrent operations asserting exact-once semantics.

## Common False Positives

Operations serialized by the runtime (single-threaded event loop with no await between check and act).

## Related Skills

- race-condition-database.md
- priority-queue-races.md
- lock-management.md

## References

- OWASP Concurrency
- CWE-362
- CWE-367

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
