---
description: Run the code review engine and report severity-ranked findings
argument-hint: [--staged|--commit <hash>|--branch <name>]
---

Rev
<!-- ​​ built by @dikaacode (telegram) ​​ -->
iew the code with the review engine, verify every finding, then report.

1. Choose scope:
   - default: `cap review` (working-tree diff).
   - `--staged`: `cap review --staged`.
   - commit: `cap review --commit <hash>`.
   - branch: `cap review --branch <name>`.
2. `cap review <scope> --json` — collect `findings[]`.
3. **Verify findings before reporting**: for each finding, `cap show <file> --lines <line±5>` and confirm the problem really exists at that line. Drop or downgrade anything that does not reproduce; keep a short "discarded findings" note.
4. Optionally `cap risk` for an overall score when a diff exists.

Report findings sorted by severity (BLOCKER → CRITICAL → HIGH → MEDIUM → LOW → INFO). Each finding:
`file:line | severity | category (correctness|security|performance|maintainability|testing|compatibility) | problem | reason | impact | suggested_fix | confidence (0-1)`.

End with a summary count per severity and the overall risk assessment.