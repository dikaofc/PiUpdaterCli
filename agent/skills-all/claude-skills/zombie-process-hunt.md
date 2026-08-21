---
name: zombie-process-hunt
description: Find orphaned or leaked background processes and jobs, trace their ancestry, and define a safe cleanup path with evidence.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: debugging
  tags: [process, zombie, orphan, leak]
---

# Zombie Process Hunt
<!-- built by @dikaacode (telegram) -->

## Objective
Detect orphaned, zombie, or leaked background processes (and equally, leaked jobs/handles) before they corrupt state or exhaust resources. The outcome is a list of suspect processes with ancestry evidence, owner attribution, and a safe cleanup path — never a blind `pkill`.

## Preconditions
- Repository is indexed (`cap index --refresh`) and the app's start/background-job entry points are known (`cap repo`, `cap explore`).
- Process listing is available (`ps`/`pgrep` or the platform equivalent); on restricted platforms, job/handle tracking inside the app is used instead.
- Baseline of expected processes is known or inferable from the app's lifecycle code.

## Workflow
1. Run `cap status` to confirm environment and record git state.
2. Run `cap repo` and `cap explore <start-command>` / `cap search "spawn|fork|child_process|setInterval|listener"` to map where the app creates child processes or background jobs.
3. List current processes: `ps -ef` (or equivalent) filtered to the app's binary/scripts. Record PID, PPID, start time, and command line.
4. Detect zombies (`ps` shows `Z` state) and orphans (PPID 1 or a parent that exited). Cross-check against the map from step 2.
5. Attribute each suspect: `cap search` the code path that spawns it, and `cap show <file> --lines a-b` to confirm whether a cleanup path (kill, unref, clearInterval, listener removal) exists.
6. Check leaked in-app jobs: intervals, listeners, and file handles held open past their lifecycle — verify with `cap explore <symbol>` and the code path in step 5.
7. Classify each find: confirmed leak (no cleanup path), probable (cleanup exists but conditional), or benign (expected lifetime).
8. Propose a minimal fix per confirmed leak: add the missing cleanup at the correct scope, with a bounded retry/grace policy.
9. Run `cap diff` to confirm only intended changes, `cap verify` (lint, typecheck, test), then `cap risk`.
10. Record durable conclusions with `cap memory add`, including any process-count norms for future runs.

## Verification
- [ ] Suspect processes listed with PID/PPID/state — zombie and orphan states identified by evidence.
- [ ] Each suspect attributed to a code path; cleanup path existence checked in code.
- [ ] Classification (confirmed/probable/benign) stated per finding.
- [ ] Fixes (if any) add cleanup at the correct scope; no blanket kills.
- [ ] `cap verify` passes; `cap diff` shows only intended changes.

## Failure Handling
- If a process is genuinely ambiguous (shared PID namespaces, containerized): do not kill it; report the ambiguity and ask before acting.
- If the leak is systemic (every run leaks): fix the root lifecycle bug, not each instance.
- If process listing is unavailable on the platform: fall back to in-app job/handle audit and state the limitation explicitly.
- Never kill a process that predates the session baseline without user confirmation.

## Output Format
- Process table: PID, PPID, state, command, attributed code path.
- Findings classified (confirmed/probable/benign) with evidence references.
- Fixes applied or proposed, per finding.
- Verification results (`cap verify`, `cap diff`) and rollback note.

## References
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`.
- docs/design-principles.md: evidence over speculation; no blind destructive actions.