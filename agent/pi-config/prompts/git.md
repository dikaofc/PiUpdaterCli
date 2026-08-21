---
description: Git-aware inspection, diff review, and structured commit proposal
argument-hint: [message]
---

Rev
<!-- ​​ built by @dikaacode (telegram) ​​ -->
iew before you commit; propose with `cap`, commit with `cap`.

1. **Inspect**:
   - `cap status` — working tree and branch.
   - `cap diff` — uncommitted changes + impact analysis (symbols touched, risk).
   - `cap diff --staged` — if there is staged content.
   - `cap audit --limit 10` — recent history for context.
2. **Review the diff before committing**: summarize files changed, symbols/impact, and any `cap review` findings on the diff (verify findings with `cap show`). If BLOCKER/CRITICAL findings exist, say so before proposing a commit.
3. **Propose**: `cap commit --message "<m>" --dry-run` — show the structured proposal (files, summary, risk) and confirm with the user.
4. **Commit**: `cap commit --message "<m>"`.
5. **Verify**: `cap status` — clean tree; confirm the commit recorded in `cap audit`.

Use the argument as the commit message if given; otherwise propose one from the diff summary.

Output: diff summary, proposal (dry-run), commit result, final status.