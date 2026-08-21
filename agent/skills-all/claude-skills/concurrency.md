---
name: concurrency
description: Use the right concurrency primitive — mutex, channel, pool, or actor — for shared state.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [concurrency, threads, async]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Concurrency Patterns

## Objective
Make concurrent code correct (no races/deadlocks) and bounded in resource use.

## Preconditions
- `cap repo` run; language concurrency model identified (`cap explore <thread|async|goroutine|worker>`).

## Workflow
1. Run `cap search` for shared mutable state and unsynchronized access.
2. Prefer message-passing/immutable over shared-mutable where the language allows.
3. Bound parallelism with pools/queues; never spawn unbounded tasks.
4. Protect residual shared state with the minimal correct lock; avoid holding locks across I/O.
5. Add a stress/concurrency test (race detector where available) and run it.
6. Record the chosen primitives with `cap memory add`.

## Verification
- [ ] Race detector clean (or equivalent review).
- [ ] No unbounded task/thread creation.
- [ ] Locks never held across I/O.
- [ ] Concurrency test included and green.

## Failure Handling
- If deadlock appears, order locks or use try-lock with timeout.
- If throughput drops, measure before adding more parallelism.

## Output Format
Concurrency plan: primitives per shared resource, bounds, locking rules, and test result.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
