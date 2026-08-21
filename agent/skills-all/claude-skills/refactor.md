---
name: refactor
description: Refactor code to improve structure while preserving behavior, backed by regression tests.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository with a runnable test suite.
metadata:
  category: coding
  tags: [refactor, maintainability, regression]
---

# R
<!-- ​​ built by @dikaacode (telegram) ​​ -->
efactor

## Objective
Improve the internal structure of existing code (readability, naming, module boundaries,
duplication removal) with **behavior preservation as the primary goal** and cosmetic
improvements strictly secondary. Every refactor must be proven safe by regression tests
that pass before and after the change.

## Preconditions
- Repository is indexed (`cap index --refresh`) and `cap status` reports a healthy ecosystem.
- A baseline test run exists: the suite passes (or its known failures are documented) **before** any change.
- The refactor scope is defined (single module, function, or concern); no mixed feature work.
- Git state is recorded so the change can be reverted.

## Workflow
1. Run `cap status` and `cap repo` to confirm the environment and detect the test runner and build system.
2. Run `cap test` (full suite) to capture the baseline. Record pass/fail counts. This is the behavior contract.
3. Run `cap index --refresh`, then `cap explore <module|symbol>` and `cap search <usages>` to map every usage of the code being refactored, including callers and tests.
4. Read the target files completely with `cap show <file>` (with line numbers) before touching them.
5. Run `cap plan <refactor task>` and use the plan to enumerate the smallest mechanical steps (rename, extract, inline, move). Each step must preserve observable behavior.
6. Apply one step at a time with minimal patches. After each step, re-run the targeted tests (`cap test --target <file>`).
7. After all steps, run `cap diff` and inspect the impact analysis: the diff should be structural, not behavioral (no logic reordering that changes outcomes).
8. Run `cap rules check <file>` on changed files.
9. Run the full regression suite (`cap test`). Results must match the baseline (same pass/fail set, no new failures).
10. Run `cap verify` (lint, typecheck, build) and `cap risk` to confirm the refactor did not raise risk.
11. Record the outcome and any new structural constraints with `cap memory add`.

## Verification
- [ ] Full test suite result before refactor == full suite result after (no new failures, no silent skips).
- [ ] Targeted tests pass after every intermediate step.
- [ ] `cap diff` shows structural changes only; no behavior-affecting logic changes.
- [ ] No unrelated files or features were modified.
- [ ] `cap lint` and `cap typecheck` pass; build succeeds.
- [ ] Public API/behavior changes (if any) are intentional, documented, and were agreed before starting.

## Failure Handling
- If a step breaks tests: stop, revert that single step, and re-apply it in smaller pieces. Never "fix" the test to fit the refactor unless the test encoded wrong behavior (prove this first).
- If behavior drifted (diff shows logic change): `cap rollback` to the last green state and redo with smaller steps.
- If the scope balloons: freeze the diff, revert non-essential edits, and re-plan.

## Output Format
Final report:
- Refactor goal and scope.
- Baseline test results vs. post-refactor results (numbers).
- Steps taken (each with `cap diff` evidence).
- Behavior-preservation confirmation and any intentional behavior changes.
- Verification results and `cap risk` score.
- Rollback instructions.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap test`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
