---
name: explore
description: Answer questions about a repository with file and symbol evidence, using the index and content search.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: exploration
  tags: [explore, search, evidence]
---

# E
<!-- ​​ built by @dikaacode (telegram) ​​ -->
xplore

## Objective
Answer a question about the repository — where things live, how they connect, what a
symbol does, who calls what — by producing **file + symbol + line evidence** from the
index and content search, never from memory or guesswork. Exploration output is
evidence; the final answer only contains claims the evidence supports.

## Preconditions
- Repository is indexed (`cap index --refresh`).
- The question is concrete enough to translate into search queries (a feature, symbol, file, or relationship).
- `cap status` reports a healthy tool layer.

## Workflow
1. Run `cap status` to confirm the environment, then `cap index --refresh` so the index is current.
2. Translate the question into one or more queries and run `cap explore <query>` for files, symbols, and dependencies (use `--json` for machine-readable hits when precision matters).
3. For content-level questions, run `cap search <query>` (optionally `--path <glob>` to scope to a directory or file type); note `file:line` matches.
4. For each hit that looks relevant, read the exact region with `cap show <file> --lines a-b` to confirm the content and extract the precise evidence.
5. Follow symbols: from a definition found via `cap explore <symbol>`, enumerate references with `cap explore` (references) and `cap search <symbol>` to map callers and dependents.
6. If the question involves a specific diff or change, check `cap diff` to relate findings to recent modifications.
7. Cross-check findings: if two queries disagree or a claim relies on one match, verify by reading the surrounding code (`cap show`) before asserting it.
8. If the question spans several files, build a dependency/relationship list (`cap explore` references) to demonstrate how the pieces connect.
9. Compose the answer: each claim carries its evidence (file, symbol, line); group by theme (location / relationship / behavior).
10. If the question invites a recommendation (e.g., which file to change), ground it in the evidence and name the open options explicitly.

## Verification
- [ ] Every claim in the answer has file + symbol/line evidence (`cap show` output).
- [ ] The question is answered directly; no unrelated exploration is reported as the answer.
- [ ] Searches used appropriate queries and scoping (`--path`) to avoid false coverage claims.
- [ ] Ambiguities (same name, multiple matches) are resolved by reading context, not assumed away.
- [ ] Relationship answers are backed by reference/usage evidence, not by name similarity.
- [ ] Recommendations (if any) are labeled as such and grounded in evidence.

## Failure Handling
- If a query returns nothing: broaden the query, try synonyms or partial identifiers, and adjust scope; do not conclude "not in repo" until several reasonable queries return empty.
- If the answer depends on runtime behavior the code cannot show: state that the finding is static evidence only.
- If the question cannot be answered from the repo at all: say so with the queries tried, rather than filling in gaps from general knowledge.
- If the index looks stale: re-run `cap index --refresh` before drawing conclusions.
- If a query returns mostly irrelevant hits: refine with `--path` scoping or more specific symbols before concluding anything.

## Output Format
Final report:
- Direct answer to the question (first).
- Evidence list: each item as `file:line — symbol — what it shows` (from `cap explore`/`cap search`/`cap show`).
- Relationships found (callers, dependents, data flow).
- Anything not found, and the queries tried.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap status`.
