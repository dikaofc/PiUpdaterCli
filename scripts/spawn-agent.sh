#!/bin/sh
#​@dikaacode​
# spawn-agent — portable sub-agent spawner via tmux + an agentic CLI (pi or claude).
# Any CLI (pi, Claude Code, oc/hy3-*) can delegate a task to an isolated agent
# without native sub-agent support: open a fresh tmux window, launch the target
# CLI with the task as prompt, capture its output file, report completion.
# Usage: bin/spawn-agent.sh <cli> <task|brief-file> [results-file] [--model <m>]
# Watermark: <!-- built by @dikaacode (telegram) -->
set -eu
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CLI="${1:?usage: spawn-agent.sh <cli|pi|claude> <task> [outfile] [--model m]}"
TASK="${2:?missing task or brief file}"
OUT="${3:-/tmp/agent-out.md}"
shift 2 2>/dev/null || true
MODEL=""
[ "${1:-}" = "--model" ] && { MODEL="${2:?}"; shift 2; }

session="agent-$(date +%s)"
workdir="${PWD:-$ROOT}"

command -v tmux >/dev/null 2>&1 || { echo "error: tmux not found" >&2; exit 1; }

brief=/tmp/agent-brief-$session.md
if [ -f "$TASK" ]; then cp "$TASK" "$brief"; else printf '%s\n' "$TASK" > "$brief"; fi
printf '\n\n---\nReport your final output to: %s\n' "$OUT" >> "$brief"

tmux new-session -d -s "$session" -c "$workdir"
# NOTE: pass an absolute-workdir cd prefix first. tmux panes can inherit a cwd
# that was already removed (sandbox/launcher), which makes pi/claude crash with
# `ENOENT: process.cwd failed ... uv_cwd`.
case "$CLI" in
  pi|claude)
    if [ -n "$MODEL" ]; then
      tmux send-keys -t "$session" "cd '$workdir' && $CLI --model '$MODEL' -p \"$(cat "$brief")\" 2>&1 | tee '$OUT'" Enter
    else
      tmux send-keys -t "$session" "cd '$workdir' && $CLI -p \"$(cat "$brief")\" 2>&1 | tee '$OUT'" Enter
    fi
    ;;
  *)
    tmux send-keys -t "$session" "cd '$workdir' && $CLI \"$(cat "$brief")\" 2>&1 | tee '$OUT'" Enter
    ;;
esac

echo "$session $OUT" > "$OUT.session"
echo "spawned agent: session=$session cli=$CLI out=$OUT"
echo "watch: tmux attach -t $session   |   done when: grep -q '^DONE' $OUT"
echo "kill:  tmux kill-session -t $session"
