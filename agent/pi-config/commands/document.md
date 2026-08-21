---
description: Generate or update documentation grounded in the current codebase
argument-hint: [target: file|module|API|README]
---

Doc
<!-- ​​ built by @dikaacode (telegram) ​​ -->
umentation must match the code. This command may write files.

1. **Gather**: `cap repo` (structure), `cap explore "<target>"` / `cap search` (symbols and usages), `cap show <file> [--lines a-b]` (exact behavior), `cap headers <file>` (core file metadata).
2. **Determining the target**: if an argument is given (file, module, API, README), document that scope; otherwise propose the highest-value gap found.
3. **Write** the doc file(s) — README, module docs, or API reference — keeping each claim backed by `file:line` citations. Include examples only if verified against the code.
4. **Verify**: if the doc references symbols, `cap explore` them to confirm names/locations; re-read the doc for accuracy. Add a "Last verified" note.

Output:
- **Docs written/updated** — paths + one-line purpose each.
- **Coverage** — what each doc covers.
- **Gaps** — items intentionally not documented and why.