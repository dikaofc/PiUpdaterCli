#!/usr/bin/env bash
# Learning Path — build curriculum paths from goals and prerequisites
# Source: https://en.wikipedia.org/wiki/Curriculum
set -euo pipefail

SCRIPT_NAME="learning-path.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} plan --goal "<goal>" [--level beginner|intermediate|advanced]
       ${SCRIPT_NAME} topics <topic>...              # order topics by dependency
       ${SCRIPT_NAME} schedule --goal "<goal>" --hours N --weeks N
Build a learning curriculum from a goal and level, order topics
by prerequisite, and generate a weekly study schedule.

Options:
  --goal G     learning goal (required for plan/schedule)
  --level L    beginner | intermediate | advanced (default beginner)
  --hours N    hours per week (default 5)
  --weeks N    weeks (default 8)
  -h | --help  show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
GOAL=""
LEVEL="beginner"
HOURS=5
WEEKS=8
TOPICS=()
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    plan|topics|schedule) CMD="$1"; shift;;
    --goal) GOAL="$2"; shift 2;;
    --level) LEVEL="$2"; shift 2;;
    --hours) HOURS="$2"; shift 2;;
    --weeks) WEEKS="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) TOPICS+=("$1"); shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }

case "$CMD" in
  topics)
    [ ${#TOPICS[@]} -lt 1 ] && { echo "usage: learning-path.sh topics <topic>..." >&2; exit 2; }
    python3 - "${TOPICS[@]}" <<'PYEOF'
import sys

topics = sys.argv[1:]
# Simple prerequisite graph for common topics; unknown topics get no prereqs
PREREQS = {
    "python": [], "bash": [], "git": [],
    "sql": [], "html": [], "css": [],
    "javascript": ["html", "css"],
    "typescript": ["javascript"],
    "react": ["javascript", "html", "css"],
    "node": ["javascript"],
    "python-web": ["python", "html"],
    "flask": ["python", "python-web"],
    "django": ["python", "python-web"],
    "data-analysis": ["python", "sql"],
    "pandas": ["python", "data-analysis"],
    "machine-learning": ["python", "data-analysis"],
    "pytorch": ["python", "machine-learning"],
    "docker": ["bash", "linux"],
    "kubernetes": ["docker"],
    "linux": ["bash"],
    "networking": ["linux"],
    "security": ["linux", "networking"],
    "aws": ["linux", "networking"],
    "cloud": ["linux", "networking"],
}
result, visiting = [], set()

def visit(t):
    if t in result:
        return
    if t in visiting:
        print(f"warning: circular dependency involving {t}", file=sys.stderr)
        return
    visiting.add(t)
    for p in PREREQS.get(t, []):
        visit(p)
    visiting.discard(t)
    result.append(t)

for t in topics:
    visit(t)
print("Ordered path (prerequisites first):")
for i, t in enumerate(result, 1):
    print(f"  {i}. {t}")
PYEOF
    ;;
  plan)
    [ -z "$GOAL" ] && { echo "missing --goal" >&2; exit 2; }
    python3 - "$GOAL" "$LEVEL" <<'PYEOF'
import sys

goal, level = sys.argv[1], sys.argv[2]
# Heuristic curriculum builder: phases + sample topics by level
FOUNDATIONS = {
    "beginner": ["fundamentals & terminology", "hands-on guided exercises", "small projects"],
    "intermediate": ["core concepts in depth", "best practices", "medium projects"],
    "advanced": ["advanced theory", "performance & architecture", "portfolio project"],
}
print(f"Learning path: {goal}  ({level})")
print("=" * 50)
phases = [
    ("Phase 1 — Foundations", FOUNDATIONS[level]),
    ("Phase 2 — Core skills", ["topic 1: what, why, when", "topic 2: common patterns", "topic 3: tooling setup"]),
    ("Phase 3 — Practice", ["build 2-3 small projects", "solve exercises daily", "review others' work"]),
    ("Phase 4 — Consolidation", ["teach it to someone", "write documentation", "final project + reflection"]),
]
for title, items in phases:
    print(f"\n{title}")
    for it in items:
        print(f"  - {it}")
print("\nTips: 25-50 min focused sessions; one concept per session; spaced review.")
PYEOF
    ;;
  schedule)
    [ -z "$GOAL" ] && { echo "missing --goal" >&2; exit 2; }
    python3 - "$GOAL" "$HOURS" "$WEEKS" "$LEVEL" <<'PYEOF'
import sys

goal, hours, weeks, level = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), sys.argv[4]
total = hours * weeks
print(f"Schedule: {goal} — {hours}h/week x {weeks} weeks = {total}h total ({level})")
print("-" * 50)
for w in range(1, weeks + 1):
    if w == 1:
        focus = "foundations; set up environment"
    elif w <= weeks // 3:
        focus = "core concepts + guided practice"
    elif w <= weeks * 2 // 3:
        focus = "building projects, applying concepts"
    elif w == weeks:
        focus = "final project, review, teach-back"
    else:
        focus = "advanced topics + polish"
    print(f"Week {w:>2}: {focus}  (~{hours}h)")
print(f"\nSuggested sessions: 3-4 per week, {hours // 4 or 1}+h each.")
PYEOF
    ;;
esac