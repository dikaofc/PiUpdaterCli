---
description: Refactor preserving behavior, verify no regression, keep the diff minimal
argument-hint: <what to refactor>
---

Beh
<!-- ​​ built by @dikaacode (telegram) ​​ -->
avior preservation is the contract. Never change semantics while refactoring.

1. **Baseline**: `cap test`, `cap lint`, `cap typecheck` — record the green state. Snapshot `cap diff` (nothing pending, or note what is).
2. **Analyze**: `cap explore "<target>"` / `cap search "<target>"` to enumerate every reference of the refactored symbols so nothing is missed.
3. **Refactor in small steps**: change one cohesive piece at a time; after each step run a targeted `cap test --target <file>`.
4. **Regression check**: full `cap test` again, then `cap lint`, `cap typecheck`.
5. **Quality**: `cap review` on the resulting diff (verify findings with `cap show`), then `cap risk`.

Output:
- **What changed** (files + nature of the refactor)
- **Behavior preservation** — confirmation the public behavior is unchanged (same tests green)
- **Regression status** — full test/lint/typecheck results before → after
- **Review/risk** — `cap review` findings summary and `cap risk` score

If any step regresses, revert that step (via `cap rollback --task <id>` if recorded) and report, do not paper over the failure.