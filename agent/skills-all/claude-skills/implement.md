---
name: implement
description: Implement a feature or fix using inspect-before-edit, a written plan, minimal patches, and full verification.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository (.claude/ initialized with cap init).
metadata:
  category: coding
  tags: [implement, feature, fix, coding]
---

# I
<!-- ​​ built by @dikaacode (telegram) ​​ -->
mplement

## Objective
Ship a new feature or bug fix as a minimal, well-scoped set of edits that is verified
by the project's own toolchain (lint, typecheck, tests, build) and leaves the
repository in a known, rollback-able state.

## Preconditions
- Repository is initialized with the `cap` tool layer: `.claude/` exists or `cap init` has been run.
- The task is understood: either provided by the user or produced by `cap plan <task>`.
- Baseline git state is clean or the working tree is intentionally dirty; note it before editing.
- The repository index is current (`cap index --refresh`).

## Workflow
1. Run `cap status` to confirm ecosystem health (plugins, permissions, rules, memory, git state) and record the starting git state.
2. Run `cap repo` to detect the repository structure: language, build system, test runner, entry points.
3. Run `cap index --refresh` so all later searches operate on a fresh index.
4. Run `cap plan <task>` to produce a plan with goal, target files, steps, tests, risk, and rollback path. Keep this plan as the scope contract.
5. **Inspect before edit**: for every file the plan touches, read it first with `cap show <file>` (use `--lines a-b` for the relevant region). Use `cap explore <symbol>` to find definitions and usages, and `cap search <pattern>` to find callers and tests that constrain the change.
6. Use `cap pick --query <q>` to confirm the exact file set to edit; only edit files that are in the plan or whose need to change is proven by inspection.
7. Apply the smallest patches that satisfy the plan (minimal diff). Do not refactor unrelated code, add abstractions for hypothetical futures, or reformat files.
8. Run `cap diff` to review the full change set and its impact analysis (symbols touched, risk). Verify the diff contains only intended changes.
9. Run `cap rules check <file>` on each edited file to confirm the change complies with applicable project rules.
10. Run `cap verify` to execute the verification pipeline (lint, typecheck, test, build). If any tool fails, fix and re-run before proceeding.
11. Run `cap risk` to get the change risk score; if it is high, justify or reduce it by narrowing the diff.
12. Run `cap memory add` to record durable decisions (chosen approach, constraints discovered) scoped to the project or task.

## Verification
- [ ] Every edited file was read (`cap show`) before modification (inspect-before-edit holds).
- [ ] The diff (`cap diff`) contains only files and changes justified by the plan or by evidence.
- [ ] `cap lint` passes with no new issues.
- [ ] `cap typecheck` passes (where applicable).
- [ ] Targeted tests pass; full suite passes (`cap test`).
- [ ] Build succeeds (`cap verify` reports build OK where the project builds).
- [ ] `cap risk` score is acceptable and understood.
- [ ] Rollback path exists: the change is recoverable via git or `cap rollback`.

## Failure Handling
- If verification fails: inspect the failure output, fix the smallest cause, and re-run `cap verify`. Never ignore a failing check to "save time".
- If the plan proves wrong (files missing, approach infeasible): re-run `cap plan` with the new information rather than improvising outside the scope.
- If the diff grows beyond the task: revert unrelated edits before continuing.
- If the change is broken beyond quick repair: restore the baseline with `cap rollback` (or git) and report the failure honestly.

## Output Format
Final report:
- Objective restated (one line).
- Files changed (with `cap diff` summary: symbols touched, +/- counts).
- Verification results per tool (lint / typecheck / test / build).
- Risk score from `cap risk` and any mitigations.
- Rollback note (how to undo).
- Any deviations from the plan and why.

## References
- CONTRACT.md §2 Skill Format (section order and required sections).
- CONTRACT.md §1 Tool Layer: `cap plan`, `cap diff`, `cap verify`, `cap test`, `cap risk`, `cap rollback`.
