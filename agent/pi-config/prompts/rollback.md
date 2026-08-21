---
description: Roll back changes from the audit trail for a task or file
argument-hint: [--task <id>|--file <path>]
---

Rol
<!-- ​​ built by @dikaacode (telegram) ​​ -->
lback is destructive — choose the target precisely and confirm before executing.

1. **Select the target**:
   - With `--task <id>`: `cap rollback --task <id>`.
   - With `--file <path>`: `cap rollback --file <path>`.
   - No argument: `cap audit --limit 20` to list recent events/tasks, present them, and ask the user which task/file to roll back.
2. **Confirm**: show what will be restored (task events, files affected, commit/timestamp). Ask for explicit confirmation before executing an irreversible rollback.
3. **Execute**: `cap rollback --task <id>` or `cap rollback --file <path>`.
4. **Verify**: `cap status` and `cap diff` — confirm the working tree is in the expected restored state. Re-run `cap test` targeted if the change touched code.

Output:
- **Target chosen** (task/file + scope)
- **Restored state** — confirmation from `cap status`/`cap diff`
- **Verification** — test result if applicable
- If the rollback target is empty or unknown, report that nothing was rolled back.