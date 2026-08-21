---
name: spawn-agent-tmux
description: Spawn a real sub-agent on any agent CLI via tmux windows + `pi`/`claude` CLI — no native sub-agent support required.
license: MIT
compatibility: Requires `tmux` and one agentic CLI (`pi` or `claude`) on PATH. `cap` optional; the universal shim (`bin/shims/cap`) covers the shared tool subset.
metadata:
  category: productivity
  tags: [subagent, tmux, spawn, pi, claude, portable]
---

# Spawn Agent via Tmux
<!-- built by @dikaacode (telegram) -->

## Objective
Launch a true sub-agent from any agent CLI (pi, Claude Code, oc/hy3-*, anything with a prompt flag) by opening an isolated tmux window that runs the target CLI with a self-contained brief, streams output to a file, and reports completion — so fan-out works even where the running CLI has no native Task/sub-agent tool.

## Preconditions
- `tmux` installed (`command -v tmux`).
- At least one agentic CLI with a `-p`/`--prompt` mode on PATH: `pi -p '...'` or `claude -p '...'`.
- Repository indexed (`cap index --refresh`, or the universal fallback `grep -rn`) and a brief exists (see `agent-briefing`).
- Output file path is agreed and writable (default `/tmp/agent-out.md`).

## Workflow
1. Probe the host: `command -v tmux pi claude cap` — record what exists (see `agent-cli-bootstrap`); choose the CLI with `-p` support (`pi` preferred if present).
2. Write the brief with `agent-briefing` rules: goal, `file:line` refs (`cap show <f> --lines a-b` or `sed -n 'a,bp' <f>`), constraints, deliverable shape, and the line "Report your final output to: <OUT>".
3. Spawn the agent: `bin/spawn-agent.sh <cli> <brief> <OUT> [--model <m>]` — it creates a fresh tmux session named `agent-<ts>`, runs the CLI with the brief in `-p` mode, and tees stdout to `<OUT>`.
4. Poll `cap status` / `git status` while the agent works, or inspect `<OUT>`; a `DONE` marker line (appended by the brief) closes the loop.
5. Read the agent's report (`cap show <OUT>` or `cat <OUT>`); verify its claims against the repo with `cap search` / `git diff` before trusting them.
6. For parallel work (see `agent-fanout`): spawn one tmux session per unit (distinct OUT files), collect, then merge per `agent-fusion`.
7. Clean up: `tmux kill-session -t <session>` after output is harvested; record the fan-out with `cap memory add` (or the `.claude-cap/memory.json` fallback).

## Verification
- [ ] `tmux ls` shows the spawned session; the CLI process is attached to it (`tmux list-panes -t <session>`).
- [ ] `<OUT>` contains the agent's report and a `DONE` marker (or an explicit FAILED marker).
- [ ] The agent's claims verified against repo state (`cap search`/`git diff`) — never merged unverified.
- [ ] All sessions cleaned up after harvest.
- [ ] `cap verify` (or the script's universal fallback) passes on any merged result.

## Failure Handling
- If `pi -p` or `claude -p` is missing, fall back to any CLI with a prompt flag; if none exists, report "no spawn-capable CLI" instead of faking it.
- If the session dies without output, `tmux kill-session` it and re-spawn; inspect the pane log for the CLI error first.
- If a spawned agent drifts or fails, treat it per `agent-recovery`: isolate, re-run inline, or roll back — never merge unverified output.
- If tmux is unavailable, degrade to `nohup <cli> -p "$brief" > "$OUT" 2>&1 &` and state the limitation.

## Output Format
- Spawn log: session name, CLI+model used, brief path, OUT path, status (running / done / failed).
- Per-agent report echo (from `<OUT>`), with verification hits (`cap search`/`git diff`) noted next to each claim.
- Cleanup note; merged-result `cap verify` result and rollback path.

## References
- bin/spawn-agent.sh — the tmux spawner.
- bin/shims/cap — universal tool shim so skills work CLI-agnostic.
- Companion skills: [[spawn-agent]], [[agent-briefing]], [[agent-fanout]], [[agent-fusion]], [[agent-recovery]].
- CONTRACT.md §1 Tool Layer (optional `cap`), §3 Agent Output Schema.