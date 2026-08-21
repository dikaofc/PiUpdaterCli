# Skill: Memory Leak Analysis

## Purpose

Detect memory leaks: retained objects, unbounded caches/collections, listener
leaks, closures, and timers preventing garbage collection.

## Scope

- Included: global collections, listener/timer retention, closure captures,
  unbounded caches.
- Excluded: CPU/disk exhaustion (other skills).
- Layers: runtime.

## Trigger Conditions

- Long-running processes with growing memory.
- Claims of "no leaks" to verify.

## Inputs

- source code
- profiling data (heaps)

## Investigation Method

1. Identify entry points: allocation-heavy paths.
2. Identify trust boundaries: N/A.
3. Track relevant data: object retention.
4. Identify validation: bounded collections.
5. Identify security-sensitive operations: N/A (availability).
6. Inspect authorization: N/A.
7. Inspect error handling: cleanup on error paths.
8. Inspect tests: leak tests.
9. Determine exploitability or correctness impact: exhaustion.
10. Validate the finding: local heap-growth tests.

## Evidence Requirements

- E1: retention sites.
- E2: unbounded growth path.
- E3: test demonstrating monotonic memory growth.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM–HIGH (availability).

## Safe Reproduction

- Local load tests measuring heap over iterations.

## Root Cause

- Unbounded collections; missing listener/timer cleanup.

## Impact

- OOM, service restarts, availability loss.

## Remediation

- Bound collections; explicit cleanup; weak references where apt.

## Regression Test

- Tests asserting bounded memory over N iterations.

## Common False Positives

- Framework-managed pools (verify).

## Related Skills

- `resource-exhaustion.md`
- `cache-analysis.md`
- `../errors/timeout-analysis.md`

## Review Checklist

- [ ] Entry point identified
- [ ] Trust boundary identified
- [ ] Data flow understood
- [ ] Validation checked
- [ ] Authorization checked
- [ ] Runtime behavior verified
- [ ] Evidence collected
- [ ] Severity assigned
- [ ] Root cause identified
- [ ] Remediation proposed
- [ ] Regression test proposed

## References

- Language GC/memory docs
- CWE-401
