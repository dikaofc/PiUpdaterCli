---
name: race-condition-hunt
description: Find data races and TOCTOU bugs by tracing lock ordering, async interleaves, and shared mutable state — evidence first, never speculation.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: debugging
  tags: [race, toctou, concurrency, lock]
---

# Race Condition Hunt
<!-- built by @dikaacode (telegram) -->

## Objective
Locate the exact interleaving behind a nondeterministic failure: identify which shared mutable state is accessed unsafely, by which concurrent paths, and in which lock/atomicity order. Deliver the interleaving as evidence (a failing stress repro, a lock trace) plus the smallest safe fix.

## Preconditions
- The nondeterministic symptom is described (intermittent failure, corrupted value, deadlock).
- Codebase is indexed (`cap index --refresh`).
- The suspected concurrency paths are identifiable by entry points (`cap explore`).

## Workflow
1. Run `cap status`, `cap repo`, then `cap index --refresh`; confirm the failure reproduces at all before hunting.
2. Search the shared-state surface: `cap search <mutable-symbol>` for each attribute/global/collection written in more than one place; `cap explore` the writers and readers of each.
3. Classify each access: read-only, read-modify-write, check-then-act. A check-then-act pair whose state can change between the steps is a TOCTOU candidate — record the pair verbatim (`cap show <file>`).
4. Map lock/atomicity order per access: which lock (or atomic, or single-threaded queue) guards which state, and in what nesting order. `cap explore` lock acquisition sites.
5. Check async interleaves (JS/TS only): `cap search <await>` around the shared state, and whether state is read after an `await` without re-validation; event-loop interleaves between `await` and next line.
6. Rank candidates by (a) contention window size, (b) write frequency, (c) symptom match. Take the top candidate only.
7. Prove it: write a stress repro that loops the two interleaving paths enough times to flip the race (record window size and observed frequency), or add temporary instrumentation (never committed; `cap diff` must not keep it).
8. Only after evidence: propose the minimal fix — same lock for all paths, atomic compare-and-swap, or single-owner mutation. Run `cap diff` to scope the change, then `cap test`, `cap lint`, `cap typecheck`, `cap verify`.
9. Run the stress repro against the fixed code: it must no longer flip. `cap memory add` the interleaving pattern so later hunts start from it.

## Verification
- [ ] Shared mutable state inventory complete: every multi-writer symbol is classified.
- [ ] At least one check-then-act / interleave pair proven by a flipped-race repro, not by reading alone.
- [ ] Lock ordering conflict (if any) demonstrated: two paths acquire the same locks in opposite order.
- [ ] Fix is scoped by `cap diff`: only the racy path changed.
- [ ] Stress repro passes N consecutive runs post-fix; pre-fix it failed within the reported window.
- [ ] `cap verify` passes.

## Failure Handling
- Repro will not flip: widen the window with instrumentation, or lower confidence — distinguish "race cannot be proven here" from "race proven absent". Report honestly.
- Fix uses locks but the project is single-threaded async: the interleave is event-loop-level; fix by serializing the `await`ed section or re-validating state, not by locking.
- Deadlock appears while adding the fix: revert with `cap rollback --task <id>`, re-check lock nesting order (step 4) before retrying.
- The race is in a dependency, not project code: `cap plugins` to list the dependency surface; work around at the call site and report upstream.

## Output Format
Report:
- Inventory: shared symbols, writers, readers, access class per symbol.
- Evidence: the proven interleaving, repro/flip frequency, or the lock trace.
- Root cause: exact lines (`file:line`) of the unsynchronized window.
- Fix: minimal change, scoped via `cap diff`.
- Post-fix stress count vs. pre-fix flip rate; `cap verify` result; pattern added to memory.

## References
- CONTRACT.md §2 Skill Format, §1 Tool Layer (`cap explore`, `cap search`, `cap show`, `cap diff`).
- CONTRACT.md §7.3: reproduce and trace before assuming the first error is root cause.
- `debug` skill for the reproduce-then-fix discipline this skill specializes.