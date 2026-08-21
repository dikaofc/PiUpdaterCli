#!/usr/bin/env bash
# Spaced Repetition — generate spaced-rep cards, schedules, Anki import/export
# Sources: https://en.wikipedia.org/wiki/Spaced_repetition https://faqs.ankiweb.net/
set -euo pipefail

SCRIPT_NAME="spaced-repetition.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} cards <qa.txt> [--out <file.tsv>]
       ${SCRIPT_NAME} schedule --new N [--review R]
       ${SCRIPT_NAME} anki-import <file.tsv> [--deck NAME] [--out <file.txt>]
       ${SCRIPT_NAME} anki-export <deck.txt> [--out <file.tsv>]
Generate spaced-repetition cards from Q/A text, plan review
schedules (SM-2 style), and convert between plain text and Anki
tab-separated format.

Options:
  --new N     new cards per day (default 20)
  --review R  review cards per day (default 100)
  --deck NAME Anki deck name (default 'Default')
  --out FILE  output file
  -h | --help show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARGS=()
NEW_N=20
REVIEW_N=100
DECK="Default"
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    cards|schedule|anki-import|anki-export) CMD="$1"; shift;;
    --new) NEW_N="$2"; shift 2;;
    --review) REVIEW_N="$2"; shift 2;;
    --deck) DECK="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARGS+=("$1"); shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }

emit() {
  if [ -n "$OUT" ]; then
    echo "$1" > "$OUT"
    echo "Saved to $OUT"
  else
    echo "$1"
  fi
}

case "$CMD" in
  cards)
    F="${ARGS[0]:?usage: cards <qa.txt>}"
    [ -f "$F" ] || { echo "not found: $F" >&2; exit 1; }
    # format: each card = question line(s) then answer line(s), separated by blank lines
    # or Q/A pairs: "Q: ..." / "A: ..."
    python3 - "$F" <<'PYEOF' | { if [ -n "$OUT" ]; then tee "$OUT" >/dev/null && echo "Saved to $OUT"; else cat; fi; }
import sys, re

path = sys.argv[1]
text = open(path, encoding="utf-8").read()
blocks = [b.strip() for b in re.split(r"\n\s*\n", text) if b.strip()]
cards = []
for b in blocks:
    lines = b.splitlines()
    q = None; a = None
    for ln in lines:
        if ln.lower().startswith("q:") and q is None:
            q = ln[2:].strip()
        elif ln.lower().startswith("a:") and a is None:
            a = ln[2:].strip()
    if q is None and a is None and len(lines) >= 2:
        q, a = lines[0], lines[-1]
    if q and a:
        cards.append((q, a))
print(f"# {len(cards)} cards")
for i, (q, a) in enumerate(cards, 1):
    print(f"{i}.\tQ: {q}\n\tA: {a}\n")
PYEOF
    ;;
  schedule)
    python3 - "$NEW_N" "$REVIEW_N" <<'PYEOF'
import sys

new_per_day = int(sys.argv[1])
review_cap = int(sys.argv[2])
# SM-2 simplified: intervals grow 1,2,4,8,16,32... days on success
intervals = [1, 2, 4, 8, 16, 32, 64, 128]
print("Spaced repetition schedule (SM-2 style)")
print(f"New cards/day: {new_per_day}   Review cap: {review_cap}")
print("-" * 56)
print(f"{'Day':<5}{'New':<8}{'Reviews':<10}{'Cumulative reviews':<20}")
cum = 0
for d in range(1, 31):
    reviews = 0
    for i, iv in enumerate(intervals):
        if d > 1 and (d - 1) % iv == 0 and iv <= 30:
            reviews += new_per_day
    reviews = min(reviews, review_cap)
    cum += reviews
    print(f"{d:<5}{new_per_day:<8}{reviews:<10}{cum:<20}")
PYEOF
    ;;
  anki-import)
    F="${ARGS[0]:?usage: anki-import <file.tsv>}"
    [ -f "$F" ] || { echo "not found: $F" >&2; exit 1; }
    python3 - "$F" "$DECK" <<'PYEOF'
import sys, csv

path, deck = sys.argv[1], sys.argv[2]
lines = []
with open(path, newline="", encoding="utf-8", errors="replace") as f:
    for row in csv.reader(f, delimiter="\t"):
        if len(row) >= 2 and row[0].strip():
            lines.append(f"{row[0]}\t{row[1]}")
header = f"#separator:tab\n#html:true\n#columns:Front;Back\n#deck:{deck}\n#tags:\n"
sys.stdout.write(header + "\n".join(lines) + "\n")
sys.stderr.write(f"imported {len(lines)} cards\n")
PYEOF
    ;;
  anki-export)
    F="${ARGS[0]:?usage: anki-export <deck.txt>}"
    [ -f "$F" ] || { echo "not found: $F" >&2; exit 1; }
    python3 - "$F" <<'PYEOF'
import sys, csv

path = sys.argv[1]
lines = [l.rstrip("\n") for l in open(path, encoding="utf-8")]
rows = []
i = 0
# skip header/comment lines
while i < len(lines):
    ln = lines[i]
    if not ln or ln.startswith("#") or ln.startswith("#separator"):
        i += 1
        continue
    if ln.startswith("#deck") or ln.startswith("#tags") or ln.startswith("#columns") or ln.startswith("#html"):
        i += 1
        continue
    if "\t" in ln:
        rows.append(ln.split("\t", 1))
    i += 1
out = csv.writer(sys.stdout, delimiter="\t", lineterminator="\n")
for r in rows:
    out.writerow(r)
sys.stderr.write(f"exported {len(rows)} cards\n")
PYEOF
    ;;
esac