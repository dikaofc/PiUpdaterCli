---
name: explain
description: Explain a piece of code with precise references and line numbers so the reader can verify every claim.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: exploration
  tags: [explain, comprehension, on-boarding]
---

# E
<!-- ​​ built by @dikaacode (telegram) ​​ -->
xplain

## Objective
Explain what a function, module, or code path does, how it works, and why it is written
that way — using the actual code with **line-numbered references** so the reader can
open the cited lines and confirm every claim. No claim goes without a reference, and
no reference goes without a line number.

## Preconditions
- Repository is indexed (`cap index --refresh`).
- The target code location is identified (file, or file + symbol).
- The explanation scope is agreed (a function, a file, a flow).

## Workflow
1. Run `cap status` and `cap index --refresh` to ensure the environment and index are current.
2. Locate the target: `cap explore <symbol>` to find the definition and its file, or `cap show <file>` to read a whole file with line numbers.
3. Read the target region carefully with `cap show <file> --lines a-b`; note the purpose of each block and the line range that implements it.
4. Map dependencies: `cap explore <symbol>` for the symbols the code calls, and read their definitions; `cap search <usage>` to find who calls the target and under what conditions.
5. Trace the execution flow through the code (inputs → transformations → outputs/effects), anchoring each step in specific line numbers.
6. If the target is part of a change, check `cap diff` (or `--commit <h>` / `--branch <b>`) to explain why recent edits shaped the current form.
7. Note assumptions the code makes (invariants, input contracts, environment requirements) and flag any suspicious or dead branches found during the trace.
8. If the explanation must cover a flow across files, stitch the steps together in call order and label the boundary between files at each transition.
9. Compose the explanation: start with a one-sentence summary, then a walkthrough where every claim cites `file:line`.
10. State the depth taken: which callees were summarized vs. walked through in full, so the reader knows the coverage.

## Verification
- [ ] Every cited line number was confirmed with `cap show <file> --lines ...` (no invented line numbers).
- [ ] Definitions and callers cited from `cap explore`/`cap search` exist as stated.
- [ ] The walkthrough matches the code order and control flow.
- [ ] Assumptions/uncertainties are labeled, not asserted as facts.
- [ ] Cross-file transitions are shown with the file/line of the call site.
- [ ] Summarized callees are marked as summaries, not presented as full walks.

## Failure Handling
- If part of the target is unclear: read its callees (`cap explore`) and tests (`cap search`) before giving up; if still unclear, mark that part as unknown and say what would resolve it.
- If line numbers drift (file edited during explanation): re-run `cap show` and refresh the citation.
- If the code's purpose conflicts with its name/comments: say so explicitly with evidence, rather than harmonizing the description.
- If the code has no tests and observable behavior is uncertain: say so and recommend a test instead of asserting behavior.
- If the code is recursive or self-referential: explain base case + recursion with one concrete example trace.

## Output Format
Final report:
- One-sentence summary of what the code does.
- Walkthrough with numbered steps, each citing `file:line`.
- Dependencies and callers (with references).
- Assumptions, edge cases, and any open questions.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap show`, `cap explore`, `cap search`, `cap diff`, `cap status`, `cap index`.
