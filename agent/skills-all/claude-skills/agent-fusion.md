---
name: agent-fusion
description: Merge results from multiple sub-agents — dedup, conflict detection, and cross-verification — before the host signs off.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository; sub-agent scope logs via `cap diff`.
metadata:
  category: productivity
  tags: [subagent, merge, aggregation, review]
---

# Agent Fusion
<!-- built by @dikaacode (telegram) -->

## Objective
Combine the outputs of several sub-agents into one coherent, verified result: detect duplicate or conflicting work, reconcile findings, and produce a single report the host can sign off without re-reading every agent transcript.

## Preconditions
- Every sub-agent reported a deliverable plus its scope indication (`cap diff` output, file list, or finding set).
- `cap index --refresh` run so merged references resolve.
- A clear notion of what "consistent" means for this task (one right answer vs. a combined set).

## Workflow
1. Collect all agent outputs; run `cap diff` per agent to map exactly which files each touched.
2. Dedup: drop identical or superseded findings/deliverables, keeping the one with the best evidence (verify with `cap search` / `cap show`).
3. Detect conflict: any two agents editing the same file, or findings that contradict, are conflicts — list them before merging anything.
4. Resolve each conflict explicitly: pick the winner with reasoning, or re-run one agent to redo the disputed unit serially.
5. Cross-verify: run `cap verify` (lint, typecheck, test, build) on the merged tree; run `cap diff` against the merge base to confirm only intended cumulative changes.
6. Classify residual risk with `cap risk`; record the outcome and any cross-agent insights with `cap memory add`.

## Verification
- [ ] Per-agent scope maps are disjoint post-resolution (no overlapping file edits remain).
- [ ] Duplicate findings/deliverables deduped; every kept item has evidence (`cap search`/`cap show` hit).
- [ ] Conflicts detected and resolved with an explicit reason, not silence.
- [ ] Merged `cap verify` green; `cap diff` vs base shows only intended changes.
- [ ] `cap risk` acceptable and understood.

## Failure Handling
- If dedup is ambiguous, keep the higher-confidence item (verified with tool output) and note the rejected duplicate.
- If conflicts cannot be resolved statically, re-run the disputed agents serially and merge the corrected output — do not blend contradictory results by hand.
- If merged verification fails, bisect by agent (`cap diff` per agent), fix the failing unit, and re-run full `cap verify`.
- Never present an unverified or conflicted merge as final; resolution must be explicit in the report.

## Output Format
- Merge log: per-agent scope, deduped items (kept / rejected with reason), conflicts (detected / resolved / escalated).
- Merged tree verification: `cap verify` result, `cap diff` vs base, `cap risk` score.
- Final single report and rollback note.

## References
- CONTRACT.md §1 Tool Layer: `cap diff`, `cap verify`, `cap risk`, `cap memory`.
- docs/agent-development.md, docs/review-engine.md (confidence classification).
- Skills: [[spawn-agent]], [[agent-fanout]].