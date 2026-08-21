---
description: Inspect-before-edit implementation — minimal diff, verify, then report
argument-hint: <task description>
---

Imp
<!-- ​​ built by @dikaacode (telegram) ​​ -->
lement with discipline: inspect → plan → edit minimal → verify → report.

1. **Inspect before edit (mandatory)**: `cap show <target file>` (and `--lines` ranges as needed), `cap explore "<task symbols>"`, `cap status`/`cap diff` for current state. Never edit a file you have not read.
2. **Plan**: if the task is non-trivial, `cap plan "<task>" --json`; otherwise a two-line plan (goal + files) is enough.
3. **Edit**: apply the minimal diff — only the lines the task requires. No drive-by refactors, no new abstractions.
4. **Verify**:
   - `cap verify` (lint/typecheck/test/build pipeline), or at minimum `cap test --target <file>` then full `cap test`.
   - `cap review` on the diff (verify each finding with `cap show`; fix or justify).
   - `cap risk` for a final score.
5. **Report** in this exact format:
   - **Implemented** — one sentence on what was built.
   - **Changes** — per file: summary of edits.
   - **Verification** — tool outputs per step (tests/lint/typecheck/build passed or failed with evidence).
   - **Review** — findings addressed or dismissed (with reason).
   - **Risk** — `cap risk` score + top driver.

Only report success when verification is green or the remaining failure is documented with evidence.