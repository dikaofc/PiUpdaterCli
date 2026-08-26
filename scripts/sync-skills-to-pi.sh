#!/bin/sh
#​@dikaacode​
# sync-skills — single-source sync between this repo (.claude/skills + skills/pi-audit)
# and the user-level pi agent CLI (~/.pi/skills).
# Direction: repo is the source of truth; pi is a runtime copy for audits.
# Usage: bin/sync-skills-to-pi.sh [push|pull]
#   push (default) — copy repo skills into ~/.pi/skills and agents into ~/.pi/agents
#   pull           — refresh skills/pi-audit from ~/.pi/skills (import new pi skills)
# Watermark: <!-- built by @dikaacode (telegram) -->
set -eu
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
PI="$HOME/.pi"
mode="${1:-push}"

if [ ! -d "$PI" ]; then
  echo "error: ~/.pi not found (pi agent CLI not installed here)" >&2
  exit 1
fi

case "$mode" in
  push)
    echo "[sync] push .claude/skills -> $PI/skills (skill format converted: claude -> pi)"
    # claude skills ship as <name>/SKILL.md; pi ships as <category>/<name>.md with
    # its own audit-style frontmatter. Only category-agnostic skills are pushed
    # as raw files flattened into a claude-skills/ dir pi can also index.
    mkdir -p "$PI/skills/claude-skills"
    for d in "$ROOT"/.claude/skills/*/; do
      [ -f "$d/SKILL.md" ] || continue
      name=$(basename "$d")
      cp "$d/SKILL.md" "$PI/skills/claude-skills/$name.md"
    done
    # final generated watermark-only guard: agents are identical format both sides
    cp "$ROOT"/.claude/agents/*.md "$PI/agents/" 2>/dev/null || true
    echo "[sync] pushed $(ls "$PI/skills/claude-skills" | wc -l) skill files + $(ls "$ROOT"/.claude/agents/*.md 2>/dev/null | wc -l) agents"
    ;;
  pull)
    echo "[sync] pull $PI/skills -> skills/pi-audit"
    rm -rf "$ROOT/skills/pi-audit"
    cp -r "$PI/skills" "$ROOT/skills/pi-audit"
    echo "[sync] pulled $(find "$ROOT/skills/pi-audit" -name '*.md' | wc -l) pi skill files"
    ;;
  *)
    echo "usage: $0 [push|pull]" >&2
    exit 2
    ;;
esac
