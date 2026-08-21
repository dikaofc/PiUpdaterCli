---
name: agent-recovery
description: Recover when sub-agents fail, drift, orphan, or return unverified work — isolate, re-run, or roll back with evidence.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository; rollback via `cap rollback` or git.
metadata:
  category: productivity
  tags: [subagent, failure, orphan, rollback]
---

# Agent Recovery
<!-- built by @dikaacode (telegram) -->

## Objective
Handle the four ways a sub-agent can go wrong — failure, scope drift, orphaned/lost process, or unverified output — without corrupting the tree or hiding the incident. The outcome is a tree back to a known-good state and a debrief that prevents the same failure.

## Preconditions
- Baseline git state recorded (`cap status`) before the fan-out started.
- Per-agent scope logs (`cap diff`) exist or can be regenerated.
- `cap rollback` or git is available as the recovery path.

## Workflow
1. Diagnose the failure class first — failing agent, drifted agent, orphan (ran but never reported back), or unverified output — `cap status` + `cap diff --staged` to see what actually landed.
2. For an orphan: treat as the highest risk. Freeze its scope (note the files it owned), check `cap diff` for partial edits, and only then re-run or roll back. Never leave an orphan's partial edits merged in.
3. For a failure: reproduce the agent's error with the evidence it left (`cap show <file> --lines a-b`), fix the smallest cause, re-run the brief. If it fails twice, run the unit inline and document why.
4. For drift: diff what it touched (`cap diff`) vs. what its scope should have been; revert out-of-scope edits (`cap rollback --file <f>`), keep in-scope work, re-brief the gap.
5. For unverified output: run the stated verification (`cap verify` scope) before merging anything; a fast wrong answer is only valuable if discarded.
6. Restore the tree: roll back only the broken unit's edits, re-verify the whole tree, re-run `cap verify` and `cap risk`.
7. Debrief with `cap memory add`: failure mode, trigger, fix, and the guard that should have caught it earlier.

## Verification
- [ ] Failure class identified and stated before acting.
- [ ] Orphan/partial edits frozen and either completed or rolled back — never half-merged.
- [ ] Re-run passes verification, or the unit was run inline with the reason documented.
- [ ] Tree back to known-good: `cap verify` green, `cap diff` shows only intended changes, `cap risk` acceptable.
- [ ] Debrief recorded; guard identified for the next fan-out.

## Failure Handling
- If the tree is broken beyond quick repair, restore the baseline with `cap rollback` or git and report the failure honestly — never `git reset --hard` past an audit trail.
- If the same failure class recurs, treat it as a systemic problem: fix the fan-out design or brief quality, not just the instance.
- If an orphan cannot be confirmed dead, assume it owns its scope until proven otherwise; ask before merging competing work.

## Output Format
- Incident report: failure class, timeline, files touched, decisions (re-run / inline / rollback) with evidence.
- Recovery verification: baseline vs. final tree, `cap verify` result, `cap risk`, rollback note.
- Debrief and the guard that prevents recurrence.

## References
- CONTRACT.md §1 Tool Layer: `cap status`, `cap diff`, `cap rollback`, `cap verify`, `cap risk`, `cap memory`.
- docs/design-principles.md: evidence over speculation; no blind destructive actions.
- Skills: [[spawn-agent]], [[agent-fanout]], [[agent-fusion]].