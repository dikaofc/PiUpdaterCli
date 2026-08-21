---
name: backup-restore
description: Back up files or directories before risky operations and restore them on demand with checksum-verified integrity.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18); backup and restore integrate with `cap rollback` for recovery.
metadata:
  category: coding
  tags: [backup, restore, safety]
---

# Backup / Restore
<!-- ​​ built by @dikaacode (telegram) ​​ -->

## Objective
Create timestamped, checksum-verified backups of files or directories before any risky operation, and restore them deterministically on request — either to the original location or to a recovery path — so no state is lost.

## Preconditions
- Targets for backup are known; paths exist (`cap show`/`cap search` confirms).
- Backup destination is writable and excluded from the repo's ignored noise if inside the tree.
- Restore semantics agreed: restore-in-place vs restore-to-recovery-path.

## Workflow
1. Run `cap status` and `cap repo` to record baseline state (branch, uncommitted changes) before the risky operation.
2. Inventory targets: `cap search`/`cap show` to list exact files/dirs; record size and current sha256 of each.
3. Decide backup location: outside the working tree or in a git-ignored path (`.backups/`); record the full destination.
4. Create timestamped backup (e.g. `backup-2026-08-20T1030/`) preserving relative structure; compute and store checksums for every file (tree-sha256 or per-file).
5. Record intent: `cap memory add` a compact note (targets, backup path, timestamp, checksums) and keep a per-run manifest file inside the backup dir.
6. Execute the risky operation (user-driven or paired with another skill); after it, run `cap status`/`cap diff` to confirm the delta matches expectations.
7. On restore request:
   - Verify the backup's checksums against the manifest first; refuse a corrupt backup.
   - Restore files to their origin paths (or the agreed recovery path) using the stored layout.
   - Re-verify restored files against the manifest checksums.
8. Run `cap verify` after restore-in-place to prove the project still works; report the exact commands used so the user can repeat them.

## Verification
- [ ] Baseline state recorded before backup (`cap status`, `cap repo`).
- [ ] Each backed-up target has a checksum in the manifest before the operation.
- [ ] Backup dir exists with manifest and matching checksums (re-verified before restore).
- [ ] Restore refused or flagged if checksums mismatch.
- [ ] After restore: files match manifest checksums; `cap verify` passes for in-place restores.
- [ ] Manifest and `cap memory add` note contain the restore commands.

## Failure Handling
- If the backup fails mid-copy: delete the partial backup dir, retry from clean, and never proceed with the risky operation without a verified backup.
- If checksums mismatch at restore time: stop, do not overwrite current files, and report the mismatch with evidence.
- If the risky operation already destroyed originals and the backup is the only copy: restore to a recovery path first, verify, then place into originals.
- If `cap verify` fails after restore: keep the restored files, diagnose with `cap show`, and never run a second restore over an unverified state.

## Output Format
Final report:
- Backup manifest summary: targets, sizes, checksums, timestamped path.
- Operation executed (what was risky) and its `cap status`/`cap diff` delta.
- Restore performed (if any): method, checksum re-verification results, `cap verify` outcome.
- Exact backup/restore commands for reproducibility.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap rollback`, `cap memory add`.