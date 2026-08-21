---
name: git-workflows
description: Use git correctly — commits, branches, rebase workflow, history hygiene, bisect, reset safety.
category: Shell & CLI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Git Workflows

## Commits
- Small atomic commits: one logical change each, message imperative summary ≤ 70 chars + body why-not-what. Refer to ticket.
- `git add` specific files, review `git status` + `git diff --cached` before commit; never `git add -A` blindly (secrets/binaries sneak in).
- Never commit generated artifacts, caches, .env, keys (`.gitignore` first; `git check-ignore` verify).

## Branching & history
- Feature branch from `main`/`develop`, rebase onto updated base before PR (`git pull --rebase`); keep branch PR-sized.
- Interactive rebase to **squash/reword your own unpushed commits** to logical chunks — never rebase published history (force-push harms teammates).
- Merge commits vs linear: linear (rebase) keeps bisect-log clean; `--first-parent` merges fine — pick per repo and stay consistent.

## Safety around destructive ops
- `git reset` types: `--soft` (keep changes staged), `--mixed` (keep worktree, unstage — default), `--hard` (discards) — **verify `git status`/`git stash list` before hard**; recover with `git reflog`.
- `git checkout -- .` / `restore` discards — prefixed `git stash -u` when unsure.
- `git clean -fdx` — never without `-n` preview; ignores are precise.
- `git push --force` → `--force-with-lease` (only overwrite if remote unchanged — protects teammates).

## Debugging with git
- `git bisect start → bad → good → run <test>` — the regression finder; scriptable.
- `git log -S 'deletedFunction' -- file` finds when a string appeared/disappeared (`-G` regex); `git blame -w` line history.
- Reflog = undo log (`git reflog` → `reset --hard <sha>` restores anything local).

## Checklist
- [ ] Staged diff reviewed before commit
- [ ] No secrets/artifacts in commits (verify with `git log -p` scan)
- [ ] Rebase own work, never published history
- [ ] Destructive ops previewed (`status`, `-n`, `--force-with-lease`)