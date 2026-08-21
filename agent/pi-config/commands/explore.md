---
description: Answer codebase questions with file+symbol evidence via the repository index
argument-hint: <query>
---

Ans
<!-- ​​ built by @dikaacode (telegram) ​​ -->
wer with evidence, not guesses. Every claim must cite a file and line or symbol.

1. If the index is stale: `cap index --refresh`, then:
2. `cap explore "<query>" --json` — file/symbol/dependency hits from the index.
3. `cap search "<query>"` — content grep for exact occurrences, optionally `--path <glob>` to narrow.
4. `cap show <file> --lines a-b` — read the top hits to answer with context, not just names.

Output format — findings with evidence:
- **Answer** — direct response to the question.
- **Evidence** — list of `file:line` entries, each with the symbol/context and its relevance.
- **Confidence** — high/medium/low; state explicitly which claims lack strong evidence.

If `cap explore`/`cap search` return nothing useful, say "no evidence found in the index" rather than inventing an answer.