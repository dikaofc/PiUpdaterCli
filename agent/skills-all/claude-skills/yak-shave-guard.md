---
name: yak-shave-guard
description: Prevent scope creep — a per-task roadmap with explicit hold-off on drive-by refactors and tangents.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: coding
  tags: [scope, focus, yak-shaving, workflow]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Yak-Shave Guard

## Objective
Keep a task on scope: define the roadmap (goal, allowed changes, boundaries) before
work starts, then intercept every impulse to do drive-by refactors, unrelated fixes,
or "just one more thing" detours. When a tangent appears, log it to a backlog
instead of doing it — the task completes, tangents get their own tasks.

## Preconditions
- The task is stated (user request or `cap task start <id>`), even if only as a sentence.
- Repository is indexed (`cap index --refresh`) so scoping can reference real symbols.

## Workflow
1. Run `cap status` and `cap repo` to snapshot the working tree — the baseline for "no unrelated changes".
2. Register the task: `cap task start <id>` with the stated goal.
3. Draft the roadmap: `cap plan "<goal>" --json`; from it extract explicit IN-SCOPE (files/symbols allowed) and OUT-OF-SCOPE (everything else), plus the test/rollback steps that define done.
4. State the boundaries as a guardrail list (readable one-liners): what counts as a necessary fix vs a tangent — a necessary fix is one the task's own tests fail on; everything else is a tangent.
5. During implementation, check every impulse against the guardrail: before any edit ask "does the failing test/requirement demand this?" If no, the edit is a tangent — do not touch, append it to the backlog list.
6. Track the working tree: run `cap diff --base <ref>` at milestones to catch files drifting outside the roadmap; investigate drift with `cap show <file> [--lines a-b]`.
7. If a tangent is discovered mid-task (already half-applied): stop, revert it with `cap rollback --task <id>` (or targeted revert), and add it to the backlog — half-applied tangents are the worst state.
8. When a real prerequisite is discovered (the task cannot finish without it): do not silently absorb it — record it as a BLOCKING-TANGENT, state the dependency, and ask the user before expanding scope.
9. On completion, close the task: `cap task done <id>`, run `cap memory add` for the backlog items, and present the backlog (not as done work, as deferred).
10. Final guard: `cap diff` must show only roadmap-covered files; `cap verify` passes.

## Verification
- [ ] `cap plan` produced a roadmap with explicit boundaries before edits.
- [ ] Every finished change traces to a roadmap item (or an approved exception).
- [ ] `cap diff` shows zero files invented outside scope.
- [ ] Backlog items are recorded (`cap memory add`), not silently dropped or absorbed.
- [ ] `cap verify` passes; `cap task done <id>` recorded.

## Failure Handling
- If a half-applied tangent is found: revert it immediately (`cap rollback --task <id>`), log it, and note that reverting was safer than completing it — do not finish a tangent "anyway".
- If the task genuinely blocks on an out-of-scope fix: pause the task (`cap task status`), surface the dependency with evidence (`cap explore`/`cap show`), and get an explicit scope decision rather than expanding silently.
- If the user explicitly asks for a tangent: widen the roadmap, restart `cap plan`, and commit to the new scope — guardrail is a tool, not a veto.

## Output Format
- Roadmap: goal | in-scope files/symbols | out-of-scope | done-definition (tests + verify).
- Guardrail decisions made during the task (edit → allowed or deferred, with reason).
- Backlog report: tangent items, one line each, with suggested own-task title.
- Final state: `cap diff` summary, `cap verify` result, task id closed.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap plan`, `cap diff`, `cap rollback`, `cap task`, `cap verify`.
- CONTRACT.md §5 Rollback rules for reverting tangents.