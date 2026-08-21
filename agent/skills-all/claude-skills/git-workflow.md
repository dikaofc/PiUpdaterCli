---
name: git-workflow
description: Establish branch, PR, and review flow that keeps history clean and reversible.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [git, workflow, branching]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Git Workflow

## Objective
Define a branching and merge model with small, reviewable PRs and a safe history.

## Preconditions
- `cap status` run to note current git state and default branch.
- Existing branch/PR conventions found via `cap explore <.github|contributing|branch>`.

## Workflow
1. Run `cap status` and history sense to learn the current branching model.
2. Pick a model (trunk-based or short-lived feature branches) and define branch naming.
3. Define PR size limit, required checks (from ci-cd), and review approval rules.
4. Require atomic commits with conventional messages; squash or rebase on merge per policy.
5. Add a revert/rollback convention (`cap rollback` or `git revert`) for bad merges.
6. Record the workflow with `cap memory add`.

## Verification
- [ ] Branch naming and PR checklist documented.
- [ ] Required checks wired in CI.
- [ ] Commits are atomic and message-convention compliant.
- [ ] Revert path is known and tested once.

## Failure Handling
- If history is messy, document a one-time cleanup and a going-forward rule.
- If forced pushes are risky, forbid them on shared branches.

## Output Format
Workflow doc: model, naming, PR checklist, merge policy, and revert procedure.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
