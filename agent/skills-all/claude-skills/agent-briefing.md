---
name: agent-briefing
description: Write self-contained sub-agent briefs that work without conversational context — goal, inputs, constraints, deliverable.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository so briefs can cite file:line refs.
metadata:
  category: productivity
  tags: [subagent, briefing, prompt, delegation]
---

# Agent Briefing
<!-- built by @dikaacode (telegram) -->

## Objective
Compose a sub-agent brief so complete that a fresh agent (with none of the host's conversational history) can execute it correctly on the first attempt, without asking for clarification.

## Preconditions
- The task is understood well enough to decompose (run `cap repo` / `cap explore` first, or at minimum the target surface is known).
- `cap index --refresh` has been run so briefs can cite exact `file:line` references that stay valid.

## Workflow
1. Write the goal as one imperative sentence: what to do, not how the host feels about it. Do not say "understand this and..." — say "Fix X in `<file>`".
2. Give the background the agent needs, but only what exists on disk: cite `cap show <file> --lines a-b` ranges and `cap explore <symbol>` results instead of narrating history.
3. State the constraints as hard rules: what not to touch (out of scope files), style rules, verification gates (`cap lint`, `cap typecheck`, `cap test --target <file>`).
4. Specify the deliverable shape exactly: the report fields, the success criterion, and the "done" evidence (observed tool output, not claims).
5. Tell the agent where its work starts (which files exist, which are fixtures) so it does not re-explore the whole repo.
6. State what the host will do next (verify, merge, discard) so the agent optimizes for the right handoff.
7. After receiving the result, check it against the brief's success criterion; if it fails, re-brief the gap, not the whole task.

## Verification
- [ ] Brief names a concrete deliverable and an observable success criterion.
- [ ] Every referenced file/symbol exists at the cited `file:line` (verified with `cap explore` / `cap search`).
- [ ] Out-of-scope surface explicitly listed; no ambiguity about what must NOT change.
- [ ] Single re-brief re-uses the same brief plus a targeted gap note, not a rewrite from scratch.

## Failure Handling
- If the agent asks for clarification that the brief should have covered, treat that as a brief defect: fill the gap and note it for the next brief.
- If the agent's output passes no success criterion, verify whether the brief or the execution is wrong; if the brief was ambiguous, fix the brief.
- If a brief is longer than the task deserves, cut background prose; a long brief that wastes the agent's focus is a failed brief.

## Output Format
A brief template with five blocks: Goal, Background (file:line refs), Constraints, Deliverable, Handoff. Paired with a one-line verdict against the brief's success criterion after execution.

## References
- CONTRACT.md §2 Skill Format, §3 Agent Output Schema.
- docs/agent-development.md.
- Skills: [[spawn-agent]], [[agent-fanout]].