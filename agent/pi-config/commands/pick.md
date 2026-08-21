---
description: Pick files via fuzzy/multi-select/preview, or search files non-interactively
argument-hint: [--query <q>] [--modified] [--type <ext>]
---

Fil
<!-- ​​ built by @dikaacode (telegram) ​​ -->
e selection helper. Two modes:

**Interactive** — run `cap pick`:
- Type to fuzzy-filter by path/name; Up/Down to navigate; preview pane shows file content for the highlighted entry.
- Tab or Space to multi-select; Enter to confirm.
- Report the confirmed paths verbatim.

**Non-interactive** — `cap pick --query "<q>" --json`, with optional filters:
- `--modified` — only modified (dirty) files.
- `--type <ext>` — only files with the extension (e.g. `.ts`, `.py`).
- Present matches as a numbered list of paths; if the user asked for a specific file, pick the closest match and confirm with `cap show <file>`.

Output: the selected file list, plus whether selection was interactive or query-based.