---
description: Show or edit cap configuration (.claude/settings.json)
argument-hint: [key=value]
---

Ins
<!-- ​​ built by @dikaacode (telegram) ​​ -->
pect configuration first; edit only the requested keys. This command may write `.claude/settings.json`.

1. **Show (default)**: read `.claude/settings.json` and report:
   - `cap.approvalMode` (`manual | smart | autonomous | review-only`, default `smart`) and what it means.
   - Any permission overrides, plugin config, or tool settings present.
   - `cap permissions` — the effective matrix this config produces.
2. **Edit (key=value)**: apply only the requested key (e.g. `cap.approvalMode=autonomous`). Keep the file valid JSON. If a value is outside its allowed set, reject it and say why.
3. **Verify after edit**: `cap status` and `cap permissions` — confirm the config took effect; state the new approval-mode behavior.

Output:
- **Current config** — the JSON (or relevant keys).
- **Changes applied** — before → after per key.
- **Verification** — health check + effective permission matrix result after the change.