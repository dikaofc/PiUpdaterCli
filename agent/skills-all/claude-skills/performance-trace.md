---
name: performance-trace
description: Trace latency degradations by profiling hot paths, comparing baseline vs sample, and bisecting commits — evidence first, never guesswork.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: debugging
  tags: [performance, latency, profiling, bisect]
---

# Performance Trace
<!-- built by @dikaacode (telegram) -->

## Objective
Identify where a latency regression came from by measuring hot paths, comparing a baseline against the slow sample, and bisecting commits to locate the introducing change. The outcome is a ranked list of suspect code regions with measured evidence, never a guessed bottleneck.

## Preconditions
- Repository is indexed (`cap index --refresh`) and the runnable entry point is known (`cap repo`).
- A reproducible slow scenario exists (input, command, or test that exhibits the latency).
- A baseline exists or can be produced (previous release, tag, or commit with known-good timing).
- Profiling tools for the project's language are available (or `time`/`cap test --target` fallbacks).

## Workflow
1. Run `cap status` to confirm environment and record git state; note the current commit.
2. Run `cap repo` to detect language, test runner, and build tooling so the profiler choice is grounded.
3. Reproduce the slow path: run the scenario and record wall time (`time` or the project benchmark runner). Run twice to confirm the measurement is stable.
4. Produce a baseline: checkout or identify the last known-good state (`cap search "release"`, `git log` via `cap status`), run the same scenario, and record its time. If no baseline exists, compare hot functions against each other instead.
5. Profile the slow run: `cap explore <symbol>` to find hot-path entry points, then run the project's profiler (or instrument with bounded timing prints) to rank functions by exclusive time.
6. Bisect commits: run `cap plan` on a bisect strategy, then test candidate commits (checked out via git) with the same scenario until the introducing commit is found.
7. Read the introducing diff with `cap show <file> --lines a-b` to identify the exact change (algorithm, I/O, lock, allocation).
8. Verify the hypothesis with a minimal patch and re-measure: the fix must close the latency gap against the same baseline.
9. Run `cap diff` to confirm only intended changes, `cap verify` for lint/typecheck/tests, then `cap risk`.
10. Record durable conclusions with `cap memory add`.

## Verification
- [ ] Slow scenario reproduced with stable timing (two runs within tolerance).
- [ ] Baseline measured and compared against the regression.
- [ ] Suspect functions ranked by measured time, not intuition.
- [ ] Introducing commit identified by bisect (or explicitly stated as unknown).
- [ ] Minimal fix verified: timing gap closed or justified as unavoidable.
- [ ] `cap verify` passes; `cap diff` shows only intended changes.

## Failure Handling
- If timing is unstable (noise > 10%), fix the measurement first — isolate the machine, increase iterations — never bisect on noisy samples.
- If bisect is impossible (no clean baseline), fall back to profiling ranking and state the limitation explicitly.
- If the profile shows no hot function (flat profile), suspect systemic issues: GC, event-loop stalls, network, or scheduler — check each with evidence.
- If no `cap` tool is available for a step, run the language-native tool and report which it was.

## Output Format
- Scenario used, baseline vs regression timing (measured numbers).
- Profiling summary: top functions by exclusive time.
- Bisect result: introducing commit + diff reference, or stated unknown.
- Root cause and the minimal patch that closes the gap.
- Verification results (`cap verify`, `cap diff`, `cap risk`).

## References
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap plan`, `cap explore`, `cap show`, `cap diff`, `cap verify`, `cap risk`.
- docs/design-principles.md: evidence over speculation.