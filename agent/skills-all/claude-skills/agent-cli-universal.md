---
name: agent-cli-universal
description: Universal agent discipline for ANY agent CLI (Claude Code, oc/hy3-free, TUVANS, open-source CLIs) — inspect-before-edit, verify-by-evidence, minimal-diff, honest failure — using only universal tools (bash, read, write, edit, git) with cap as an optional upgrade layer.
license: MIT
compatibility: Works on any agent CLI with bash/file access and git. The `cap` CLI is OPTIONAL; when present it upgrades the same workflow, never required.
metadata:
  category: productivity
  tags: [agent-discipline, universal, tool-agnostic]
---

<!-- built by @dikaacode (telegram) -->

# Agent CLI Universal

## Objective
Make ANY agent CLI follow the same working discipline regardless of its toolset: inspect before edit, verify by evidence, ship minimal diffs, and report failure honestly. The workflow runs on universal tools (bash/sh, read, write, edit, git) and treats `cap` strictly as an optional capability layer when available.

## Preconditions
- Shell and file access exist (`bash`, `read`, `write`, `edit` or direct equivalents).
- A git repository is present or initializable (`git status` works, or `git init` first).
- No assumption that `cap` exists. Probe before use: `command -v cap`.
- Agent CLI has no sub-agent tool needed for this skill; it is single-agent discipline shared across CLIs.

## Workflow
1. **Inspect before edit**: map the surface with `git status`, `git ls-files`, `sed -n 'a,bp' <file>` / read with line numbers, `grep -rn` for symbols. Never edit a file not first read or shown.
2. **Plan the minimal diff**: state files to touch and lines to change before writing. One behavior per edit; no renames or reformats bundled in.
3. **Edit**: use write/edit only for the planned hunks. Re-read the diff immediately: `git diff` (staged or unstaged) to confirm only intended changes.
4. **Verify by evidence**: run the project's own checks — `npm test`, `npm run lint`, `tsc --noEmit`, or the CLI's test command. Base all PASS claims on captured tool output, never assumption.
5. **Report honestly**: summarize with the agent-cli-report skill: objective, files+lines changed, evidence, risks, rollback note, deviations.
6. **Cap upgrade (optional)**: only if `command -v cap` succeeds, substitute the equivalent cap command per the table below; the workflow steps remain identical.

| `cap` tool (if available) | Universal fallback |
| --- | --- |
| `cap show <f>` | `sed -n 'a,bp' <f>` or read + line numbers |
| `cap search <pat>` | `grep -rn <pat> .` |
| `cap explore <sym>` | `grep -rn <sym> src/` + targeted reads |
| `cap status` | `git status --short` |
| `cap diff` | `git diff` |
| `cap verify` | `npm test && npm run lint && tsc --noEmit` (or the project's own pipeline) |
| `cap memory add` | append one fact per line to `.claude-state` (and later `.gitignore` it) |
| `cap risk` | manual: list untested paths and severity in the report |
| `cap rollback` | `git checkout -- <file>` (only with user consent) |

## Verification
- [ ] Every file edited was inspected first (evidence: read/show/sed output in transcript).
- [ ] `git diff` shows only planned hunks; no unrelated changes staged.
- [ ] Every PASS claim has captured tool output behind it; no assumption-based claims.
- [ ] Works with cap and without cap verified — the universal path was used unless `command -v cap` succeeded.
- [ ] Failure states reported exactly as observed, never dressed as success.

## Failure Handling
- If a check fails: record the exact error output, fix the smallest cause, re-run that check only; do not silently continue.
- If `cap` is absent: proceed with universal fallbacks without mentioning missing features as blockers.
- If verification tools are absent (no test runner): state "NOT VERIFIED - tool unavailable" explicitly in the report; never claim an untested pass.
- If an edit goes wrong: revert only that hunk via `git diff`/`git checkout`, re-inspect, re-apply.

## Output Format
A handoff report per the agent-cli-report skill: objective, changed files with line ranges, verification evidence, risks, rollback note, deviation, and environment facts (which tools were actually present).

## References
- CONTRACT.md §1 Tool Layer and §2 Skill Format.
- Agent notes: agent-cli-bootstrap (toolset probing), agent-cli-report (report format).
- Companion skills: [[agent-cli-bootstrap]], [[agent-cli-report]].