---
description: Explain a file, symbol, or concept with line-level evidence
argument-hint: <file or symbol or concept>
---

Exp
<!-- ​​ built by @dikaacode (telegram) ​​ -->
lain with citations, never from memory.

1. **Locate**: `cap explore "<query>"` — resolves file/symbol/dependency hits. If the argument is a file path, `cap show <file>` directly (use `--lines a-b` for large files).
2. **Context**: `cap search "<symbol>"` for usages and callers; `cap explore` for related symbols.
3. **Synthesize** a plain-language explanation covering: what it is, what it does, why it exists, how it is used, and notable gotchas.

Every claim must cite `file:line` (or a symbol with its defining file:line). If evidence is thin, mark confidence low and say which part is inferred.

Output:
- **Explanation** — prose, structured by the points above.
- **Evidence** — the file:line citations used.
- **Confidence** — high/medium/low.