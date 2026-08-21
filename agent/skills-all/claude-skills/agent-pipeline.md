---
name: agent-pipeline
description: Run a multi-phase pipeline of real sub-agents (coder, reviewer, debugger, tester) mapped to the task, gate each phase, and merge only verified output.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18), an indexed repository, and a host agent that can launch Claude Code sub-agents (Agent/Task tool).
metadata:
  category: productivity
  tags: [subagent, pipeline, code-review, coder, fix]
---

# Agent Pipeline
<!-- built by @dikaacode (telegram) -->

## Objective
Reproduce full multi-role sub-agent orchestration: fan out work to real specialist agents (`.claude/agents/`), gate the pipeline between phases, and merge only what passed verification — the same shape as a host running code, review, fix, verify, push as separate agents.

## Preconditions
- Repository indexed (`cap index --refresh`); runtime and baseline git state recorded (`cap repo`, `cap status`).
- The specialist agents exist or are spawnable: `coder` (writes/fixes), `reviewer` (reviews diffs), `debugger` (reproduces and fixes failures), `tester` (writes/runs tests), `security-reviewer`, `performance-reviewer` (optional), `explorer` (read-only mapping).
- A plan with named phases exists (`cap plan`) so each phase has a clear entry criterion and a "done" gate.

## Role map
Use the right specialist for the job — never run one agent type for everything:
- **Mapping / fact-gathering** → `explorer` (read-only, cheap, parallel-safe).
- **Writing or fixing code** → `coder` (one per disjoint file scope).
- **Code review of a diff** → `reviewer` (standalone; sees the diff, not the coder's intent).
- **Failing tests or a reproduced bug** → `debugger` (reproduce → root cause → smallest fix → re-run).
- **Test authoring / suite run** → `tester` (targeted → related → full).
- **Security or performance pass** → `security-reviewer` / `performance-reviewer` on the merged diff.

## Workflow
1. Run `cap plan <task>` to split the task into phases and name the agent type each phase needs. Record the phase order and gate criteria.
2. Launch phase 1 (exploration/mapping): one `explorer` brief (`cap repo`, `cap explore`) to return the surface map. Read its report before launching writers — never brief writers on a guessed map.
3. Fan out phase 2 (implementation): one `coder` per disjoint file scope (see `agent-fanout`). Collect `cap diff` per coder; any overlapping edits are a conflict — resolve before proceeding.
4. Gate: run `cap verify` (lint, typecheck, test, build) on the merged phase-2 tree before starting review. A broken tree entering review wastes the reviewer.
5. Phase 3 (review): launch one `reviewer` per merged diff (or one over the full diff if small). It must report findings with evidence (`cap show`/`cap search` lines), never vibes.
6. Phase 4 (fix): hand the reviewer's confirmed findings back to `coder`/`debugger` as re-briefs (see `agent-briefing`). Keep the drawn from: fix finding → re-verify that file → back to review until findings are empty.
7. Phase 5 (security + performance) on the final diff, and `tester` for the full suite run if the suite is the gate.
8. Final gate: `cap verify` green, `cap diff` vs base shows only intended changes, `cap risk` acceptable. Then record the outcome (`cap memory add`) and report.

## Verification
- [ ] Every phase mapped to a real agent type; no phase run by the wrong specialist.
- [ ] No two agents edited the same file at the same time; conflicts resolved with evidence.
- [ ] Review phase ran on a tree that already passed `cap verify` (or the skip is justified).
- [ ] Every review finding either fixed and re-verified or explicitly declined with a reason.
- [ ] Final gates pass: `cap verify`, `cap diff` intended-only, `cap risk` acceptable.
- [ ] Phase report shows entry criteria met per phase; nothing merged unverified.

## Failure Handling
- If review finds issues the coder must redo: send the finding back as a scoped re-brief, never re-run the whole coder with the same prompt (it will reproduce the same result).
- If the tree is broken transitively: bisect by agent (`cap diff` per agent), rerun the failing unit serially, re-verify.
- If a phase's gate fails repeatedly, stop the pipeline at that phase, roll back the unit (`cap rollback`), and report the blocker honestly — do not skip the gate.
- Never let a reviewer and coder run on the same file concurrently; review reads, coder writes — sequence them.

## Output Format
- Pipeline ledger: phase, agent type, owner, gate result, artifacts.
- Per-phase gate evidence: `cap verify` / `cap diff` / `cap risk` per phase, not just final.
- Review findings count (found → fixed → declined) with evidence refs.
- Final merged diff summary, verification results, rollback note.

## References
- CONTRACT.md §1 Tool Layer (`cap plan`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`, `cap memory`) and §3 Agent Output Schema.
- docs/agent-development.md (Role / Allowed Tools / Output Schema of each specialist).
- Companion skills: [[spawn-agent]], [[agent-fanout]], [[agent-briefing]], [[agent-fusion]], [[agent-recovery]].