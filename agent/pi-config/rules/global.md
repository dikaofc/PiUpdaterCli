---
scope: global
glob: **/*
---

# Global rules

<!-- ​​built by @dikaacode (telegram)​​ -->

Every change must obey these rules regardless of file type.

## Verification

- Run verification after code changes: `cap verify` (lint, typecheck, tests, build when applicable).
- Do not commit secrets, tokens, or credentials.
- Do not bypass the approval mode: review-only mode force-denies writes.

## Context economy

- Prefer targeted reads (`cap show <file>` with line range, `cap explore`, `cap search`) over full-file dumps.
- Keep memory entries small and durable: one fact per entry, `cap memory add`.

## Change safety

- Register tasks with `cap task start <id>` before long edits.
- On failure, recover with `cap rollback --task <id>` — never `git reset --hard`.