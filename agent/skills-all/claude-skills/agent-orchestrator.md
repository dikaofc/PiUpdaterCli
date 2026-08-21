---
name: agent-orchestrator
description: Orchestrate pi subagents — fan out parallel read-only audits across targets with isolated logs, auto model fallback, and aggregated results.
license: MIT
compatibility: Requires `bin/pi-agent` on PATH (or `./bin/pi-agent`), bash, node, jq, and the `pi` CLI (`oc/hy3-free` fallback model needs no key). `cap` optional.
metadata:
  category: productivity
  tags: [subagent, pi, orchestrator, fanout, parallel, audit]
---

# Agent Orchestrator
<!-- built by @dikaacode (telegram) -->

## Objective
Spawn real pi subagents in parallel (one per target), isolated from each other and from the host, each restricted to read-only tools, with every run logged to `~/.pi/agent-runs/<run-id>/` and a single aggregated report at the end. Replaces the fragile manual tmux approach (cwd/`/tmp` permission crashes, no isolation, no aggregation).

## Preconditions
- `bin/pi-agent` is on PATH (or invoke `./bin/pi-agent`) and executable.
- Required tools present: `bash`, `node`, `jq`, `python3`, and the `pi` CLI (`command -v pi`).
- A model that works in this env: default is `oc/hy3-free` (local ollama, no API key); set `PI_MODEL` to override. Agent defs whose model is unavailable auto-fallback to this default.
- Repository or target files exist; targets should be absolute paths (the run executes `cd` there).

## Workflow
1. Check tools: `command -v pi node jq python3` — a missing core tool is a hard stop (report it, do not proceed).
2. List usable agent defs: `pi-agent agents` — confirms which `.pi/agents/*.md` can be referenced (or `cap agents` when present).
3. Pick the agent and targets: `pi-agent run <agent> <target> [more...]`.
   - One target  → single subagent: `pi-agent run reviewer app/src/main.js`.
   - Multiple     → parallel fan-out, one isolated agent per target:
     `pi-agent run reviewer app/a.js app/b.js lib/c.js`.
   - Same prompt across many files/tags → `pi-agent fan <agent> <t1> <t2> ...` (same as `run` with several targets).
4. Scope read-only by default (`read,grep,find,ls`); add edit/write only when the task genuinely needs mutation: `--tools read,grep,find,ls,edit,write` (or `--edit`).
5. Wait for completion: the tool waits on all spawned PIDs and prints each log under `== RESULTS ==`. Watch a live run with `tail -f <out>/<agent>-<target>.log`.
6. Verify the agents' claims against the repo before trusting them (`cap search` / `grep -rn` / `git diff`). Never merge unverified sub-bagent output.
7. Record the run with `cap memory add` (or `.claude-cap/memory.json`), note the run-id and aggregated outcome.

## Verification
- [ ] Tools probed and reported (`pi`, `node`, `jq`, `python3` present).
- [ ] Each target launched as its own pid (`*.pid` files) and logged to the run dir.
- [ ] Every agent returned either a report or an explicit error (`EXIT=`, API/auth/rate errors are stated, not hidden).
- [ ] Claims cross-checked against source (`cap search`/`git diff`) before acceptance.
- [ ] Run dir cleaned when done, or its path reported so it can be inspected.

## Failure Handling
- **Model auth failure** (`401`, `No API key`, `Model not found`): `pi-agent` auto-falls back to `oc/hy3-free`; if that also fails with `429`, the free tier is rate-limited — reschedule, don't retry-loop.
- **Rate limit (`429`/`FreeUsageLimitError`)**: stop spawning, note the limit, and re-run later; never mask with unbounded retries.
- **/tmp or cwd crash**: pi-agent already writes under `$HOME/.pi/agent-runs/` and runs `cd` to the target dir; if a pane still fails, re-run with `--out <writable-dir>`.
- **Orphaned agent**: `ps` for the spawned `cli.js` pid (`ps -p $(cat *.pid)`), kill it, and treat its partial output as unverified.
- If an agent produces no output: check its `.log` for the real error before re-spawning; re-brief with a narrower target (see `agent-briefing`).

## Output Format
- Run header: run-id, agent, model used (incl. fallback note), tools.
- Per-target result block: log path, exit status, error type if any, and the agent's report payload.
- Aggregated summary: how many succeeded/failed, rate-limit or auth notes, and the overall verdict (verified/needs-fix/unverified-with-reasons).

## References
- bin/pi-agent — the orchestrator script.
- Companion skills: [[spawn-agent-tmux]], [[agent-cli-universal]], [[agent-fanout]], [[agent-fusion]], [[agent-recovery]], [[agent-briefing]].
- CONTRACT.md §1 Tool Layer (optional `cap`), §3 Agent Output Schema.