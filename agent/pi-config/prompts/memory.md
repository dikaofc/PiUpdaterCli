---
description: Add, get, list, or delete cap memory entries
argument-hint: [add <key> <text>|get <key>|list [--scope project|session|task]|del <key>]
---

Man
<!-- ​​ built by @dikaacode (telegram) ​​ -->
age persistent memory through the cap memory store.

1. **list** (default): `cap memory list [--scope project|session|task]` — show entries as a structured list.
2. **get <key>**: `cap memory get <key>` — retrieve a single entry.
3. **add <key> <text>**: `cap memory add <key> "<text>" [--scope project|session|task]` — store a durable lesson/decision (one lesson per entry, one-line summary first).
4. **del <key>**: `cap memory del <key>` — remove an entry.

Guidelines:
- Prefer `--scope project` for decisions and conventions that outlive the session; `--scope task` for task-local facts.
- When adding, prefer updating an existing key over creating a duplicate.
- Never store secrets or credentials.

Output: the requested entry/entries (key, scope, text) or the add/del confirmation with the resulting list.