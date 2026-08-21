---
name: memory-leak-hunt
description: Chase memory growth to a released-nowhere resource — handle, file, connection, listener, interval — and prove the fix by stable plateau.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: debugging
  tags: [memory, leak, resource, handle]
---

# Memory Leak Hunt
<!-- built by @dikaacode (telegram) -->

## Objective
Convert "memory keeps growing" into a named resource that is acquired repeatedly and never released — an open handle, file descriptor, DB connection, event listener, or timer — then prove release happens by a flat memory plateau in a bounded repeat-run.

## Preconditions
- A leak symptom is reported or suspected (RSS growth over time, FD exhaustion, handle warnings).
- The application runs or can run in this environment (`cap repo`).
- Repository is indexed (`cap index --refresh`).
- A repeatable workload exists or can be scripted (loop over the suspected operation).

## Workflow
1. Run `cap status` and `cap repo`; confirm which process and workload exhibit the growth.
2. Search the acquisition sites: `cap search <open|create|connect|listen|watch|setInterval|subscribe>` for every acquire call; for each, `cap explore` the release site (close, dispose, destroy, clearInterval, unsubscribe) inside the same scope.
3. For each acquire/release pair, read both ends with `cap show <file>`: leak candidates are pairs where (a) the release sits on an early-return path that skips it, (b) release is conditional on never-thrown success, (c) acquire happens per-iteration but release is per-object and objects outlive the loop.
4. Baseline memory: run the repeatable workload for a bounded N iterations and sample RSS at iteration boundaries (`cap test --target <perf-loops>` if a harness exists; otherwise a scripted run). Record baseline numbers.
5. Check the exception paths: `cap search <throw|return>` between acquire and release — a leak that only triggers on error needs an error-inject repro, not a happy-path run.
6. Prove each candidate: instrument the managed resource count (FD count, listener count, connection pool size) across the loop; a monotonic increase in the count, not raw RSS, is the fingerprint.
7. Fix the smallest candidate: move release to a `finally`/`defer`/trap scope or add a bounded pool. Run `cap diff` to scope, then `cap test`, `cap lint`, `cap typecheck`, `cap verify`.
8. Re-run the same bounded workload post-fix: the count must plateau at a stable value. Run twice to confirm the plateau is reproducible.
9. `cap memory add` the leak pattern and its symptom fingerprint (rising count vs. rising RSS).

## Verification
- [ ] Every acquire has a traced release path; pairs with skipped/conditional release are named.
- [ ] Pre-fix: resource count rises monotonically across the loop (numbers recorded).
- [ ] Post-fix: count plateaus across the same loop (two consecutive runs).
- [ ] Error-path releases verified, not only happy-path (`cap search` covers `throw`/early `return`).
- [ ] Fix scoped by `cap diff`; `cap verify` passes.

## Failure Handling
- No single count rises but RSS does: the leak is fragmentation or a cache with unbounded growth — `cap search <cache|memo|Map>` for entries never evicted, and size the cache policy instead of hunting handles.
- Leak only under load: increase N until the count slope is measurable; if N must exceed the environment budget, report the projected slope and stop — do not run unbounded.
- Acquire/release pair lives in a dependency: `cap plugins` to list it; reproduce with a minimal script against the dependency and report upstream, including the workaround at the call boundary.
- Verification fails after the fix: use `cap rollback --task <id>` to the pre-fix tree, re-inspect the pair, and retry — never force a plateau by capping the workload silently.

## Output Format
Report:
- Symptom fingerprint: what rose (RSS, FD count, listeners, pool) and the numbers.
- Candidate pairs: acquire site, release site, the path that skips release (`file:line`).
- Proof: pre-fix slope vs. post-fix plateau, both from the identical bounded workload.
- Fix: minimal change with `cap diff` scope.
- Verification: `cap verify` result and the pattern saved to memory.

## References
- CONTRACT.md §2 Skill Format, §1 Tool Layer (`cap search`, `cap show`, `cap diff`, `cap verify`).
- CONTRACT.md §7.3: reproduce and trace before asserting root cause.
- `performance-trace` skill for the baseline-vs-sample discipline shared here.