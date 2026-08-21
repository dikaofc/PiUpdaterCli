---
name: crash-reproducer
description: Turn a crash report or stack trace into a minimal, one-command reproducer with exact state and a single input step.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: debugging
  tags: [crash, reproducer, stack-trace, minimal]
---

# Crash Reproducer
<!-- built by @dikaacode (telegram) -->

## Objective
Convert a crash report or stack trace into the smallest deterministic reproduction: the exact pre-crash state, a minimal fixture, and a single triggering step. The reproducer runs reliably under `cap test` and serves as the regression test for the fix.

## Preconditions
- The crash report/stack trace is available (issue text, error log, or captured output).
- The code version that crashed is identifiable (`cap repo`).
- Repository is indexed (`cap index --refresh`).

## Workflow
1. Run `cap status` and `cap repo` to confirm environment and current revision; record it so the reproducer targets the right code state.
2. Locate the crash site: parse the stack trace and open each frame with `cap show <file>` (line range mode: `cap show <file> --lines`). Identify the crashing statement and its inputs.
3. Trace the inputs upstream: `cap explore <symbol>` and `cap search <caller>` to find where the crashing values originate — corrupt state, empty collection, missing field.
4. Inspect the crash handler context: `cap show <file>` the error boundary, catch block, or unwinding code that logged the trace.
5. Reduce: remove one indirection at a time (config, middleware, retry wrapper) and re-run the repro; the leftover that still crashes is the irreducible core. Keep deleting until removal stops the crash.
6. Build the fixture: the minimal state (one record, one file, one env var) that the reducer cannot delete. Record it with exact values.
7. Write the reproducer as one runnable case in the existing test conventions (`cap rules check`), with a single trigger step that asserts the original exception type/message. Use `cap pick --query <repro>` for the file.
8. Confirm determinism: run `cap test --target <repro-file>` three times; the crash must occur every time. If it does not, the fixture/state is incomplete or nondeterministic — go back to step 6.
9. Run `cap lint`, `cap typecheck`, then `cap verify` on the reproducer change; `cap diff` must show only the reproducer and fixture additions.

## Verification
- [ ] Reproducer triggers the exact original exception (same type/message) from the trace.
- [ ] Repro runs on a pristine checkout of the crash revision, not only the current tree.
- [ ] Crash occurs 3/3 runs — deterministic.
- [ ] Fixture is minimal: deleting any part stops the crash.
- [ ] `cap lint`, `cap typecheck`, `cap verify` pass with the reproducer in place.

## Failure Handling
- Reproducer does not crash: the report's revision, input, or config differs from the current tree. Diff `cap log` history and the fixture; do not guess — bisect which of state/input/version the repro is missing.
- Crash requires a live external service: stub it with a fixture; if the stub changes behavior, report the dependency as part of the invariant.
- Fix lands before the reproducer is done: still land the reproducer; a reproducer that fails against the fixed code is a valid regression test.

## Output Format
Report:
- Crash site (file:line) and the failing statement.
- Result of input tracing: the corrupt/absent value chain (producer → crasher).
- Reduction log: what was deleted, what stayed.
- Minimal fixture (exact values) and the single trigger step.
- Reproducer file path plus the 3/3 determinism runs and `cap verify` result.
- Any external dependency stubbed and its equivalence caveat.

## References
- CONTRACT.md §2 Skill Format: deterministic steps, verification checklist.
- CONTRACT.md §7.3 Documented PRD: never assume the first error is the root cause — reproduce before fixing.
- Existing `debug` skill for the reproduction-first workflow this skill narrows down.