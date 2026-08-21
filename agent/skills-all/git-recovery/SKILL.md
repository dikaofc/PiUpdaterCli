---
name: git-recovery
description: Recover lost work in git — reflog, dangling commits, stash, orphan hunks, blob recovery. Use when work seems gone.
category: Shell & CLI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Git Recovery

## The golden rule
Git rarely destroys data — it moves references. Almost everything is recoverable within ~90 days (gc). Work happens in sequence:

1. **Stop**: don't run fetch/reset/checkout/clean while confused — each can bury the trail.
2. **`git status` + `git reflog`** — reflog shows every HEAD move (including the reset you just did). The "lost" state is usually a reflog entry from minutes ago.
3. Recover: `git reset --hard HEAD@{5}` (or `reflog` sha) — or `git cherry-pick <sha>` onto current branch if you only want that state's commits.

## Cases
- **Uncommitted work overwritten** (`checkout --`, `reset --hard`): `git fsck --lost-found`; `git stash apply` if stashed; else dangling blob rescue: `git fsck --lost-found` → `git show <blob-sha>` in `git/lost-found/other`.
- **Deleted branch** (`git branch -D`): branch was just a ref — `git reflog show <branch-name>` (reflog keeps per-branch even after delete) → `git branch <name> <sha>`; or `git fsck --unreachable` to find dangling commits.
- **Stash lost**: `git stash list` empty → `git fsck --unreachable --no-reflogs | grep commit`; stash commits have briefcase tree; `git stash apply <sha>`.
- **Wrong commit amends** (`commit --amend` after already pushed/another branch): reflog has the old sha — `git reflog show` → `git branch rescue <old>`.
- **Interactive rebase interrupted/botched**: `git rebase --abort` (back to pre-rebase state — safe); dropped commits re-appear via `git reflog` of ORIG_HEAD.
- **Dangling commits galore**: `git fsck --full --no-reflogs --unreachable` lists all; `git show --stat <sha>` to identify.

## Prevention
- Configure `reflogExpire` generous; use `stash -u` (untracked too) instead of discarding; never `clean -fdx` without `-n`.
- Commit early, commit often — recovery distance = commits you haven't made.

## Checklist
- [ ] Reflog checked before panic
- [ ] fsck --lost-found used for dangling blobs
- [ ] Nothing further written to repo until recovered
- [ ] Rescue branch created, verified, then original branch deleted