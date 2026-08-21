---
name: agent-cli-report
description: Standard final-report format for ANY agent CLI — objective, changed files with line ranges, verification evidence, risks, rollback note, deviations — identical shape across CLIs; unverified work is reported as "NOT VERIFIED", never as a fake PASS.
license: MIT
compatibility: CLI-agnostic — pure markdown report template; works on any agent CLI with bash/file access. `cap` is optional and only referenced when present.
metadata:
  category: documentation
  tags: [reporting, evidence, tool-agnostic]
---

<!-- built by @dikaacode (telegram) -->

# Agent CLI Report

## Objective
Produce a final report with the SAME shape on every agent CLI: objective, changed files + line ranges, verification evidence, risks, rollback note, deviations. Claims are backed by captured tool output, and absence of verification is declared explicitly as "NOT VERIFIED" — never disguised as a pass.

## Preconditions
- At least one change made or attempted in the session (even a failed attempt produces a report).
- Command outputs used as evidence were captured during the session, not recalled from memory.
- Verification status is known: verified, failed, or tool unavailable.

## Workflow
1. **Objective**: restate the task in one or two lines exactly as understood.
2. **Changes**: list each touched file with the concrete line range or hunk, e.g. `src/foo.js:12-19`; use `git diff` (or `cap diff`) to confirm the exact hunks. No file listed without a diff behind it.
3. **Verification evidence**: paste the verification command and its real output; characterize the outcome as PASS / FAIL / NOT VERIFIED, with the reason.
4. **Risks**: list what is untested or uncertain — untested paths, touched-but-unverified edges — each with severity; risk is an honest inventory, not a marketing section.
5. **Rollback note**: give the exact undo for every change: `git checkout -- <file>` step list, or a named `cap rollback --task <id>` when cap is available.
6. **Deviations**: mark anything that differs from the original task or plan and why; do not hide scope drift.
7. Assemble under the fixed template (below); one report per task, never a log dump.

## Verification
- [ ] Every claimed PASS is backed by a captured command output in the report.
- [ ] If verification tools are absent, the label reads exactly "NOT VERIFIED - tool unavailable", never a silent or implied pass.
- [ ] Changed files are accompanied by diffs or line ranges; risks and rollback are non-empty.
- [ ] Report renders as the same 6-section template on any CLI.

## Failure Handling
- If a verification tool is missing or errors: label that section FAIL or NOT VERIFIED with the observed error, and never claim green.
- If no diff can be produced (non-git session): record the changed files manually and note that rollback is manual.
- If the task failed: report the failure with evidence in Changes/Verification and leave the Rollback note first-class — the report is also a handoff for recovery.

## Output Format
```
# Report

## Objective
<one-two lines>

## Changes
- <file>:<range> — <what changed>
- <file>:<range> — <depended-on evidence>

## Verification
- <command> → <captured output, trimmed> → PASS | FAIL | NOT VERIFIED - tool unavailable

## Risks
- <untested path/edge> (severity: <low|med|high>)
- ...

## Rollback
- `git checkout -- <file>` | `cap rollback --task <id>`

## Deviations
- <from plan> — <why>
```

## References
- CONTRACT.md §2 Skill Format.
- Agent notes: agent-cli-universal (discipline), agent-cli-bootstrap (tool layer).
- Companion skills: [[agent-cli-universal]], [[agent-cli-bootstrap]].