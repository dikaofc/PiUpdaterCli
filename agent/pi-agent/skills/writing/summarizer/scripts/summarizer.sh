#!/usr/bin/env bash
# Summarizer — summarize long docs to N bullet points with key takeaways
# Source: https://en.wikipedia.org/wiki/Automatic_summarization
set -euo pipefail

SCRIPT_NAME="summarizer.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} <file> [--points N] [--max-line N]
       ${SCRIPT_NAME} <file> --topics                 # extract topic words
       ${SCRIPT_NAME} stdin                           # read from stdin
Summarize documents by extracting top sentences with a frequency-based
extractive method (python3 stdlib) plus keyword/topic extraction.

Options:
  --points N    number of bullet points (default 6)
  --max-line N  max characters per bullet (default 140)
  --topics      print top topic words instead of bullets
  -h | --help   show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

POINTS=6
MAX_LINE=140
TOPICS=0
INPUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    --points) POINTS="$2"; shift 2;;
    --max-line) MAX_LINE="$2"; shift 2;;
    --topics) TOPICS=1; shift;;
    stdin) INPUT="-"; shift;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) INPUT="$1"; shift;;
  esac
done
[ -z "$INPUT" ] && { usage; exit 1; }

if [ "$INPUT" = "-" ]; then
  SUM_TEXT=$(cat)
else
  [ -f "$INPUT" ] || { echo "not found: $INPUT" >&2; exit 1; }
  SUM_TEXT=$(cat "$INPUT")
fi

SUM_TEXT="$SUM_TEXT" SUM_POINTS="$POINTS" SUM_MAXLINE="$MAX_LINE" SUM_TOPICS="$TOPICS" python3 - <<'PYEOF'
import os, re, sys
from collections import Counter

text = os.environ.get("SUM_TEXT", "")
points = int(os.environ.get("SUM_POINTS", "6"))
max_line = int(os.environ.get("SUM_MAXLINE", "140"))
topics_only = os.environ.get("SUM_TOPICS", "0") == "1"

STOP = set("""the a an and or but if then else for nor of to in on at by with from as is are was were be been being
it its this that these those i you he she we they them his her their there here what which who whom whose can could
will would shall should may might must do does did have has had not no yes so such only own same too very s t don
about into over after before between under again further once also because until while more most less other some any
all both each few neither one two three per up down out off above below during without against through during""".split())

words = re.findall(r"[a-zA-Z']+", text.lower())
word_counts = Counter(w for w in words if w not in STOP and len(w) > 2)
total = sum(word_counts.values())

# split into sentences
sentences = re.split(r"(?<=[.!?])\s+|\n+", text)
sentences = [s.strip() for s in sentences if len(s.strip()) > 20]

def score(s):
    return sum(word_counts.get(w, 0) / total for w in re.findall(r"[a-zA-Z']+", s.lower()) if w not in STOP)

ranked = sorted(sentences, key=lambda s: (score(s), len(s)), reverse=True)[:points]

if topics_only:
    print("Top topic words:")
    for w, c in word_counts.most_common(15):
        print(f"  {w}: {c}")
else:
    print(f"Summary ({len(ranked)} points, extracted from {len(sentences)} candidate sentences):")
    for i, s in enumerate(ranked, 1):
        s = re.sub(r"\s+", " ", s).strip()
        if len(s) > max_line:
            s = s[:max_line].rsplit(" ", 1)[0] + "…"
        print(f"  {i}. {s}")
PYEOF