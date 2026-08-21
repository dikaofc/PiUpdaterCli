---
description: Open the interactive file picker to select one or more files
argument-hint: [query]
---

Sel
<!-- ​​ built by @dikaacode (telegram) ​​ -->
ect files with the `cap` file picker.

1. No argument: run `cap pick` (interactive). The picker supports fuzzy filtering, tree navigation, and multi-select. User picks; the tool returns the selected paths.
2. With an argument: `cap pick --query "<query>" --json` — non-interactive search returning matching paths.
3. For narrower searches: `cap pick --query "<q>" --modified --type <ext> --json` (e.g. `--type .ts`) to find recently modified files of a type.
4. Confirm each selected file is valid with `cap show <file>` (reads a few lines) before reporting.

Output:
- **Selected files** — final list, one path per line.
- **Next-step hint** — one suggested command that fits the selection (e.g. `review`, `test`, `refactor`), only if it is clearly relevant.