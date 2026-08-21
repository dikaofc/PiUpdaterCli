---
name: git-cleanup
description: Clean up stale branches and history safely, with a full audit trail and a rollback path for every destructive step.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and a git repository; all destructive steps run through `cap rollback`.
metadata:
  category: coding
  tags: [git, branches, history, cleanup]
---

# Git Cleanup
<!-- ​​ built by @dikaacode (telegram) ​​ -->

## Objective
Remove stale local/remote branches and unwanted history (merges, junk commits) from a git repository without losing work: each destructive action is recorded in an audit trail, can be restored on demand, and is applied only after the user confirms the plan.

## Preconditions
- Repository state known: run `cap repo` first to confirm this is a git repo and to get remotes and the default branch.
- Working tree is clean or changes are stashed/committed before any cleanup.
- The list of candidate branches/commits to remove is agreed with the user before execution.

## Workflow
1. Run `cap repo` to confirm git repo type, remotes, and default branch (protection anchor).
2. Run `cap status` and `cap diff` to verify the working tree; if dirty, ask the user to commit or stash before continuing.
3. Gather facts: enumerate local branches (`git branch`), remote branches (`git branch -r`), merged branches (`git branch --merged <default>`), and unreachable objects (`git fsck --unreachable`). Use `cap explore` / `cap search` only if cleanup targets are related to code symbols.
4. Build the deletion plan: for each candidate branch record name, last commit hash, last commit date, and merge status. Exclude protected branches (default branch, release/*, anything in the protection list).
5. Show the plan and get explicit user confirmation before any destructive command.
6. Delete confirmed branches one by one with `git branch -d` (safe) first; only use `-D` when the user confirms the branch is intentionally unrecoverable. Record every deletion in a cleanup log (file or `cap memory add`): name, sha, date, reason.
7. Optionally prune remote refs (`git remote prune origin`) and stale tags after confirmation; record the same audit details.
8. If history rewriting is requested (rebase/squash), run `cap risk` on the plan first, then execute and record before/after tips.
9. Run `cap diff` to confirm the working tree is unaffected, and `cap verify` to confirm nothing broke after cleanup.
10. Write the audit trail: branches deleted, commits removed, restorable refs created, and the exact `cap rollback` command per item.

## Verification
- [ ] `cap repo` confirmed git repo and default branch before any deletion.
- [ ] Working tree was clean (or user accepted dirty state) before cleanup.
- [ ] Every deleted branch had a recorded sha and was restorable via the audit trail.
- [ ] No protected branch was deleted.
- [ ] `cap diff` shows zero unintended working-tree changes after cleanup.
- [ ] `cap verify` passes after cleanup.
- [ ] Audit trail written to the report with per-item rollback commands.

## Failure Handling
- If a protected branch is accidentally targeted: abort immediately, never delete it, and escalate to the user.
- If a branch deletion was wrong: restore with `git branch <name> <recorded-sha>` from the audit trail, then re-run `cap status`.
- If the working tree became dirty during cleanup: stop, diagnose with `cap show`, and restore with `cap rollback --task <id>` before anything else.
- If a history rewrite diverges expected tips: stop, do not push, and use the recorded before-tip refs to recover.

## Output Format
Final report:
- Repo facts: default branch, remotes, protected branches.
- Cleanup plan: candidates with sha/date/merge status, and which were approved.
- Actions taken: every deletion with sha, date, reason, and its restore command.
- Refuses: branches kept and why (protected, unmerged, user declined).
- Working-tree impact: `cap diff` result and `cap verify` outcome.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap diff`, `cap risk`, `cap verify`, `cap rollback`, `cap memory add`.