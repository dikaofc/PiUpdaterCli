---
name: file-organizer
description: Restructure directories safely using git mv for every move, with a dry-run plan and a full rollback path.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and a git repository; moves run through `cap rollback` for recovery.
metadata:
  category: coding
  tags: [filesystem, git, organize, restructure]
---

# File Organizer
<!-- ​​ built by @dikaacode (telegram) ​​ -->

## Objective
Restructure directories (move, rename, regroup files) in a git repository with a deterministic plan, `git mv` for every move so history is preserved, and a rollback path that restores the previous layout if verification fails.

## Preconditions
- Git repo confirmed with `cap repo`; moves use `git mv` so the old layout is recoverable from history.
- Working tree clean or user-approved dirty state; targets and final layout agreed before first move.
- No uncommitted changes to files being moved (or they are committed first).

## Workflow
1. Run `cap repo` and `cap status` to confirm git repo and working-tree state; commit or stash pending changes if the tree is dirty.
2. Map the current layout: `cap search` / `cap explore` to enumerate files and their importers; build a full inventory (path, type, who imports it).
3. Design the target layout; trace every reference (imports, configs, scripts, docs) with `cap explore <symbol>` / `cap search <old-path>` so no reference is left dangling.
4. Produce a dry-run plan: ordered list of `git mv` commands with old/new paths. Show it and get user confirmation.
5. Execute moves one directory at a time with `git mv`; stop on first error.
6. After each batch, update references found in step 3 (relative/absolute imports, config paths) and record every edit with `cap diff`.
7. Re-run the reference scan: `cap search` for any remaining old-path token; every hit must be resolved or explicitly tolerated.
8. Run `cap verify` (tests/types/lint as applicable) to prove the restructure broke nothing.

## Verification
- [ ] Git repo confirmed; working tree clean before moves.
- [ ] Full pre-move inventory recorded (all files and their importers).
- [ ] Every move executed with `git mv` (no plain `mv`).
- [ ] Dry-run plan shown and confirmed before execution.
- [ ] After each batch, references updated and `cap diff` reviewed.
- [ ] Final scan: zero old-path tokens remain (unless explicitly tolerated).
- [ ] `cap verify` passes after restructure.

## Failure Handling
- If a move fails mid-way: stop immediately; the partial state is recoverable because every move is `git mv` — revert with `git mv <new> <old>` inverse pairs from the plan, or `cap rollback --task <id>`.
- If references are left dangling after a batch: fix them before the next batch; never proceed with broken imports.
- If `cap verify` fails after the restructure: roll back the offending batch, re-check references, and re-verify before proceeding.
- If a user declines a planned move: drop it and re-plan the remaining moves; do not reorder silently.

## Output Format
Final report:
- Pre-move inventory summary (files, importers).
- Applied moves: old path -> new path, per batch.
- Reference updates applied (files edited).
- Verification results (`cap diff`, `cap verify`).
- Rollback instructions: inverse `git mv` pairs or `cap rollback --task <id>`.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap search`, `cap explore`, `cap diff`, `cap verify`, `cap rollback`.