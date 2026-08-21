---
name: agent-fanout
description: Fan out deterministic batches of independent work to named sub-agents, with disjoint scopes and a bounded pool.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18), an indexed repository, and a host agent capable of launching sub-agents (Claude Code Task tool).
metadata:
  category: productivity
  tags: [subagent, fanout, parallel, batch]
---

# Agent Fanout
<!-- built by @dikaacode (telegram) -->

## Objective
Split a large, uniform batch of independent work into deterministic units and run them across a bounded pool of sub-agents in parallel, so wall-clock shrinks without losing scope discipline or reviewability.

## Preconditions
- Repository indexed (`cap index --refresh`); runtime mapped with `cap repo`.
- Work units are enumerable up front (a list of files, skills, or targets) and genuinely independent (no shared mutable state).
- A named agent exists for each unit type (see `.claude/agents/`: `coder`, `tester`, `reviewer`, `explorer`, `debugger`, ...) or the host spawns general-purpose agents.
- A concurrency cap is agreed (default 4–6).

## Workflow
1. Run `cap repo` and `cap explore` to produce the full unit list; enumerate units explicitly (never a "and so on").
2. Group units by the agent type that best fits each (read-only review → `reviewer`/`explorer`; edits → `coder`; tests → `tester`).
3. Verify units are disjoint: `cap search` for overlapping file ownership; merge or re-split anything that touches the same file path.
4. Assign each unit a one-file brief (see `agent-briefing` skill) naming: goal, input refs (`cap show <file> --lines a-b`), constraints, deliverable shape.
5. Launch agents under the concurrency cap; give each a bounded token/time budget and a single success criterion.
6. Collect outputs and `cap diff` per agent immediately, so ownership violations are caught while the agent context is still fresh.
7. Run `cap verify` across the merged result; on failure, bisect by agent and re-run only the failing unit serially.
8. Record the fan-out plan, per-unit outcomes, and the concurrency setting that worked with `cap memory add`.

## Verification
- [ ] Every unit enumerated and assigned to exactly one agent; none dropped (count check: units spawned == units reported).
- [ ] No two agents edited the same file (`cap diff` per agent shows disjoint paths).
- [ ] Bounded pool respected; no unit ran unbounded in time or tokens.
- [ ] Merged `cap verify` green (or only pre-existing documented failures).
- [ ] Fan-out report records units, owners, status, and rollback note.

## Failure Handling
- If two agents touched the same file: re-split ownership, re-run the conflicting unit serially, and tighten scoping for the next batch.
- If an agent returns nothing or drifts from scope: re-brief with a narrower scope and a concrete expected output; if it fails twice, run the unit inline and document why.
- If the merged result breaks verification: bisect by agent, isolate the failing unit, fix it, re-run full `cap verify`.
- Never merge unverified sub-agent output; evidence of verification is mandatory before the merge is reported done.

## Output Format
- Fan-out inventory: unit count, agent types used, concurrency cap, budgets.
- Per-unit status table: unit, owner agent, shipped files, verification result.
- Merged `cap diff` summary and `cap verify` result.
- `cap risk` score, deviations from plan, rollback note.

## References
- CONTRACT.md §1 Tool Layer: `cap repo`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap memory`.
- docs/agent-development.md §Role/Scope/Output Schema.
- Skill: [[spawn-agent]], [[agent-briefing]], [[agent-fusion]].