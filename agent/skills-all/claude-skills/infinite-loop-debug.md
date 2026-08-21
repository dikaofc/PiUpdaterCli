---
name: infinite-loop-debug
description: Debug a hang or loop that never exits — enforce iteration bounds, add progress traces, and bisect the input to the loop's fixed point.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: debugging
  tags: [hang, infinite-loop, timeout, bisect]
---

# Infinite Loop Debug
<!-- built by @dikaacode (telegram) -->

## Objective
Resolve a hang or non-exiting loop into a single condition that fails to advance — a guard that never flips, a break that never fires, a worklist that never drains — confirmed by a bounded trace, then fixed and re-verified with a hard iteration limit as the regression guard.

## Preconditions
- The hanging process/path is specified (which command, workload, or test hangs).
- The loop site is reachable by inspection: `cap explore` on the entry function or `cap search` on loop keywords (`while`, `for`, `do`, `watch`, `poll`).
- Repository is indexed (`cap index --refresh`).

## Workflow
1. Run `cap status` and `cap repo`; reproduce the hang with a hard timeout so the session itself never blocks (timeout N seconds, record the observed cutoff behavior).
2. Find the loop: `cap search <while|for|do|setInterval|poll>` ranked by nesting depth; `cap explore` each loop's machinery (iterator, worklist, condition variables).
3. Identify the exit condition and trace every mutation of it: `cap show <file>` the loop body; list each statement that could flip the guard (index increment, list shift, counter decrement, state transition).
4. Check the two canonical stalls: (a) the guard never flips because the mutating statement is on a branch that is never taken; (b) the mutating statement flips a *copy* of the guard (shadowed variable, wrong primitive), so the live guard is static.
5. Add bounded instrumentation: a temporary progress trace (loop counter + guard value at each exit-check, hard-capped at N iterations) — temporary only, never committed (`cap diff` must not keep it), or use `cap test --target` with a test that runs the loop with a kill limit.
6. From the trace, bisect the *input*: halve the input (record size, list length, retry count) until the loop terminates; the boundary input set is where the guard stops advancing.
7. Read the trace values at the boundary: the exact iteration where the guard stops changing (value equal to previous iteration) is the stall point.
8. Fix: correct the mutation (advance on the right variable) or terminate by invariant; add a hard iteration budget as a permanent guard under the same input family. `cap diff` to scope, then `cap test`, `cap lint`, `cap typecheck`, `cap verify`.
9. Prove the regression guard: the boundary input now terminates within budget; the hang input terminates deterministically. `cap memory add` the stall pattern (guard never flips vs. guard flips a copy).

## Verification
- [ ] Hang reproduced under the hard timeout before any trace is added.
- [ ] Exit condition traced: every guard mutation site read and classified (advances / never-taken / flips a copy).
- [ ] Input bisect produced a terminating boundary input.
- [ ] Trace shows the exact iteration where the guard stops advancing.
- [ ] Post-fix: boundary and original inputs terminate; iteration-budget guard present.
- [ ] `cap verify` passes; `cap diff` shows no leftover instrumentation.

## Failure Handling
- Hang is in C/SQL/system code without runnable tests: use the timeout + `cap show` reading of the loop logic, and add a documented invariant comment instead of a test; state the limitation in the report.
- Trace never shows non-advancement (loop is infinite but correct-looking): instrument the *sides* — log input before the loop; the divergence is likely a re-entrant call that re-runs the same loop (recursion) rather than an iteration.
- Loop appears to advance but the process still hangs: the stall may be an I/O wait inside the body (network, lock, subprocess). `cap search <await|wait|lock|read>` inside the body and switch to the `network-debug` or `race-condition-hunt` skill.
- Budget guard makes a legitimately long loop fail: raise the budget to a ceiling proven by the longest terminating trace from step 6, with the rationale recorded.

## Output Format
Report:
- Loop site and exit condition (`file:line`).
- Stall classification: guard never flips, guard flips a copy, or I/O wait (handed off).
- Trace excerpt: iterations around the stall, showing non-advancing guard value.
- Input bisect result: terminating boundary and the hang input family.
- Fix and the iteration-budget guard; `cap verify` result.

## References
- CONTRACT.md §2 Skill Format: deterministic numbered steps, verification checklist.
- CONTRACT.md §7.3: never assume the first observed error is the cause — trace first.
- `debug` skill and `regression-hunter` (bisect mechanics reused here for input space).