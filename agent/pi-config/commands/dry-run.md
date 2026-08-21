---
description: Analyze and plan only — zero writes, no edits, no commits, no rollbacks
argument-hint: <task or question>
---

Rea
<!-- ​​ built by @dikaacode (telegram) ​​ -->
d-only mode. Hard rule: **do not write, edit, commit, or roll back anything.**

Allowed (all read-only):
- `cap status` — current state.
- `cap index --refresh` — keep the search index current (metadata only, touches no sources).
- `cap explore <query>` / `cap search <query>` — locate files and symbols.
- `cap show <file> [--lines a-b]` — inspect contents.
- `cap diff` — see uncommitted/impacted changes.
- `cap review` — findings on the current state.
- `cap risk` — risk score.
- `cap plan "<task>"` — proposed implementation plan.

Forbidden in this command: the edit/write tools, `cap commit`, `cap rollback`, `cap plugins install`.

Output format:
- **Analysis** — what exists today (evidence from cap tools).
- **Proposed plan** — goal, would-touch files (file:line), steps, tests, risk, rollback.
- **Dry-run result** — explicit statement: "No files were changed; this was a read-only dry run."