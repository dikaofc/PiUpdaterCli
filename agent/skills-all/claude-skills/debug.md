---
name: debug
description: Debug failures systematically by reproducing, tracing, hypothesizing, patching, and verifying — never assuming the first error is the root cause.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository; a failing test, error log, or reproducible input.
metadata:
  category: debugging
  tags: [debug, root-cause, tracing]
---

# D
<!-- ​​ built by @dikaacode (telegram) ​​ -->
ebug

## Objective
Find the true root cause of a failure and fix it with the smallest correct patch,
using an evidence-driven loop: reproduce → trace → hypothesize → patch → verify.
The first error message is a clue, not a conclusion.

## Preconditions
- A concrete failure exists: failing test, error output, crash log, or reproducible input.
- Repository is indexed (`cap index --refresh`) and `cap status` is healthy.
- The failing test/command can be re-run in isolation (`cap test --target <file>`).
- Baseline behavior is known well enough to detect regressions.

## Workflow
1. **Reproduce**: run the failing path in isolation. Use `cap test --target <file>` (or the exact failing command) and capture the full error output. Record the exact input, error, and stack trace.
2. **Trace**: locate the failing code with `cap search <error-string|symbol>` and `cap explore <symbol>`; read the surrounding region with `cap show <file> --lines a-b`. Follow the data flow from where the error originates, not just where it surfaces.
3. **Hypothesize**: form a small, ranked set of hypotheses (max ~3) for the root cause. Rank by how well each matches the evidence. Do not stop at the first plausible error.
4. **Test hypotheses**: for the top hypothesis, confirm by examining the relevant code path, inputs, and callers (`cap explore` references, `cap search` for call sites). Adjust or discard hypotheses that contradict evidence.
5. **Patch**: apply the minimal fix for the confirmed root cause. Do not stack workarounds on top of unknown causes, and do not patch symptoms.
6. **Verify**: re-run the targeted test (`cap test --target <file>`), then related tests in the same module, then the full suite (`cap test`). Run `cap verify` and `cap diff` to confirm the change is minimal.
7. **Check recency**: if the failure appeared recently, run `cap diff` against recent commits/branches to see whether a recent change introduced the faulty behavior; this often shortens the trace.
8. **Learn**: record the root cause and the fix with `cap memory add` (one lesson, one line summary first).

## Verification
- [ ] Failure reproduced consistently before patching.
- [ ] Root cause identified with direct evidence (code path + input traced end-to-end).
- [ ] Patch is minimal and addresses the root cause, not a symptom.
- [ ] Targeted test passes; related tests pass; full suite passes.
- [ ] No new failures introduced (`cap test`, `cap verify`).
- [ ] `cap risk` score acceptable for the change.
- [ ] Recency check (`cap diff`) performed when the failure was introduced recently.

## Failure Handling
- If the fix does not hold: revert it, re-examine the evidence, and revisit the remaining hypotheses. Do not accumulate speculative fixes.
- If the failure cannot be reproduced: gather more information (input data, environment, logs) and state the blocker explicitly instead of guessing.
- If multiple root causes are intertwined: fix them one at a time, verifying after each.
- If the failing test itself is wrong: prove it with evidence before modifying the test, and say so in the report.

## Output Format
Final report:
- Symptom (exact error/behavior, with reproduction steps).
- Root cause (with file:line evidence and the traced data flow).
- Hypotheses considered and why they were rejected.
- Fix applied (minimal diff description).
- Verification results (targeted, related, full suite).
- Any unresolved questions or follow-up work.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap test`, `cap search`, `cap explore`, `cap show`, `cap verify`, `cap diff`, `cap memory`.
