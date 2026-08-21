# Skill: Async State Analysis

## Purpose

Analyze async state handling: shared state across async tasks, races in
event-loop/actor models, cancellation, and unbounded async work.

## Scope

- Included: shared state in async code, await-order races, cancellation
  handling, unbounded task spawning.
- Excluded: thread-model races (`race-condition.md`).
- Layers: async code.

## Trigger Conditions

- async/await, coroutines, promises, actors with shared state.
- Fire-and-forget tasks.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: async operations.
2. Identify trust boundaries: N/A.
3. Track relevant data: shared state access.
4. Identify validation: synchronization in async context.
5. Identify security-sensitive operations: state changes.
6. Inspect authorization: N/A.
7. Inspect error handling: cancellation leaks.
8. Inspect tests: async race tests.
9. Determine exploitability or correctness impact: races/leaks.
10. Validate the finding: async tests with interleavings.

## Evidence Requirements

- E1: async code.
- E2: race/leak pattern.
- E3: test demonstrating the defect.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM–HIGH depending on state.

## Safe Reproduction

- Local async tests with controlled interleavings (barriers).

## Root Cause

- Shared mutable state without async-safe synchronization; ignored
  cancellation.

## Impact

- Data races, lost updates, resource leaks.

## Remediation

- Immutable/isolated state; async-safe locks; cancellation propagation;
  bounded concurrency.

## Regression Test

- Async tests asserting state consistency and cancellation cleanup.

## Common False Positives

- Single-task flows (verify concurrency).

## Related Skills

- `concurrent-state.md`
- `race-condition.md`
- `../performance/resource-exhaustion.md`

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

- Async programming docs (per language/framework)
- CWE-362
