---
name: spawn-agent
description: Orchestrate parallel sub-agents — when to fan out, how to scope tasks, aggregate results, and verify before merging.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18), an indexed repository, and a host agent capable of launching sub-agents.
metadata:
  category: productivity
  tags: [subagent, orchestration, parallel]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Spawn Agent

## Objective
Delegate independent work to parallel sub-agents so large batches finish faster, without losing correctness, ownership, or reviewability.

## Preconditions
- Repository indexed (`cap index --refresh`) and `cap repo` run so sub-agents inherit the right environment.
- The task splits into independent units with no shared mutable files (or well-defined ownership per unit).
- The host agent can launch and collect sub-agent results (Claude Code sub-agents / Task tool).

## Workflow
1. Run `cap repo` and `cap explore` to map the surface; confirm the units are truly independent (no cross-edits to the same file).
2. Define one self-contained brief per sub-agent: goal, input files (`cap show <file> --lines a-b`), constraints, and the exact deliverable shape.
3. Assign disjoint scopes (e.g. by directory or by skill name) so agents never touch the same file simultaneously.
4. Launch the sub-agents in parallel; cap each with a bounded token/time budget and a single clear success criterion.
5. Collect outputs; run `cap diff` per agent to confirm each changed only its owned scope.
6. Run `cap verify` (lint, typecheck, test, build) across the merged result; fix and re-run on failure.
7. Record the fan-out plan and outcomes with `cap memory add`.

## Verification
- [ ] Each sub-agent scope is disjoint (no overlapping file edits).
- [ ] Every sub-agent output passes its own stated criterion.
- [ ] `cap diff` shows only intended, scoped changes per agent.
- [ ] `cap verify` green on the merged result; `cap risk` acceptable.
- [ ] No orphaned/empty deliverables left behind.

## Failure Handling
- If two agents edited the same file, re-split ownership and re-run the conflicting unit serially.
- If an agent produced no output or drifted, re-brief with a narrower scope and a concrete example.
- If merged result breaks verification, bisect by agent: isolate the failing unit, fix, re-verify.
- Never merge unverified sub-agent output; a fast wrong answer beats a slow wrong one only if discarded.

## Output Format
Fan-out report: units (scope + owner agent), per-unit status, merged `cap diff` summary, `cap verify` result, `cap risk` score, and rollback note.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap repo`, `cap index`, `cap explore`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap memory`.
- docs/skill-development.md.
- Companion skills: [[agent-fanout]], [[agent-briefing]], [[agent-fusion]], [[agent-recovery]].
