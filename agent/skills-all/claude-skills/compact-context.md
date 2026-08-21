---
name: compact-context
description: Compact a nearly-full context without losing requirements, constraints, changed files, test failures, or decisions.
license: MIT
compatibility: POSIX shell, Python 3 cap CLI
metadata:
  category: productivity
  tags: [context, compaction, resumable, token-saver]
---

# C
<!-- ​​ built by @dikaacode (telegram) ​​ -->
ompact Context

When the context window is nearly full, produce a lossless-enough summary of
the current task so work can continue after compaction or restart
(PRD §51, §50). The summary preserves exactly what must not be lost.

## Objective

Generate `context-summary.md` capturing: requirements, constraints, changed
files, test failures, important decisions, open issues, next steps — then
request compaction using that summary.

## Preconditions

- Task state exists (`cap task start <id>` was run) or the working tree has
  enough signal to reconstruct state (git diff, review findings).
- Trigger: context warning (≥80%) or upcoming compaction/restart.

## Workflow

1. **Capture task state** — `cap task status <id>` and `cap task list`
   (completed steps, pending steps, files changed, tests status).
   If no task id: create one from current intent.
2. **Capture changes** — `cap diff` → changed files + touched symbols;
   `git status --porcelain` for the raw picture.
3. **Capture findings** — `cap review` (if any diff) → keep BLOCKER/CRITICAL/
   HIGH findings verbatim with file:line; summarize the rest.
4. **Capture memory** — `cap memory list --scope project` for durable facts
   that the next context must not rediscover.
5. **Write the summary** to `.claude/state/context-summary.md` with the fixed
   sections below, quoting file paths exactly (they must survive verbatim).
6. **Verify the summary** against the checklist (below); fix gaps before
   compaction.
7. **Hand off** — tell the host: "context nearly full; summary written to
   `.claude/state/context-summary.md`; continue from `## Next Steps`".

## Verbatim Sections (keep exactly)

```markdown
# Context Summary — <task id>

## Requirements
- (user goals, acceptance criteria — QUOTED exactly)

## Constraints
- (permission level, approval mode, budget, repo rules that apply)

## Changed Files
- `src/auth/session.ts`  (touched symbols: validateSession, refreshToken)
- ... (exact paths; from `cap diff` + `cap task status`)

## Test Failures
- `tests/auth.test.ts::refresh` — assertion failed (message)
- ...

## Important Decisions
- (why a file was chosen / an approach rejected — the next context must not
   reconsider a settled decision without new evidence)

## Open Issues
- (blockers, questions for the user)

## Next Steps
1. (first pending step from `cap task status`)
2. ...

## Findings (BLOCKER/CRITICAL/HIGH only)
- [HIGH] src/auth/session.ts:84 expired session can remain valid
```

## Verification

- [ ] Requirements section contains the user's own words, not a paraphrase.
- [ ] Changed files are exact paths (cross-checked with `cap diff`).
- [ ] Test failures quoted with runner output.
- [ ] Decisions recorded — settled choices are not reopened later.
- [ ] Next steps taken from `cap task status` pending list.
- [ ] No secrets or credentials pasted into the summary.

## Failure Handling

- Missing task state: reconstruct from `cap diff` + `git status` and mark the
  reconstruction as such ("reconstructed, not from task state").
- Compaction already happened: treat the existing summary as authoritative
  and only append deltas.
- If the summary is too large to be useful: keep only Requirements,
  Changed Files, Test Failures, Decisions, Next Steps — drop verbose Findings
  bodies (keep the one-line severity list).

## Output Format

Path to the written summary + short status:
`.claude/state/context-summary.md (N lines) — ready for compaction`

## References

- `skills/token-saver/SKILL.md`
- `cap task status`, `cap diff`, `cap review`, `cap memory list`
- PRD §50 (resumable), §51 (context compaction)