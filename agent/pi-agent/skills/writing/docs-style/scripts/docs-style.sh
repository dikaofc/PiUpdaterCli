#!/usr/bin/env bash
# Docs Style — enforce style guide, check links and spelling
# Sources: https://developers.google.com/style https://www.plainlanguage.gov/
set -euo pipefail

SCRIPT_NAME="docs-style.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} lint <file.md>            # style + spelling + link checks
       ${SCRIPT_NAME} spell <file.md> [--words <list>]
       ${SCRIPT_NAME} links <file.md> [--check]
       ${SCRIPT_NAME} tone <file.md>
Style-check markdown docs: passive voice, weak words, long sentences,
spelling (hunspell or aspell if present), and broken links.

Options:
  --words LIST  comma-separated whitelist for spell check
  --check       verify external links via HTTP
  -h | --help   show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARG=""
WORDS=""
CHECK=0
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    lint|spell|links|tone) CMD="$1"; shift;;
    --words) WORDS="$2"; shift 2;;
    --check) CHECK=1; shift;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARG="$1"; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
[ -f "$ARG" ] || { echo "not found: $ARG" >&2; exit 1; }

case "$CMD" in
  tone|lint)
    echo "Style check: $ARG"
    ISSUES=0
    # passive voice
    echo "  passive voice constructions:"
    grep -niE '\b(was|were|is|are|been|being) (not )?[a-z]+ed\b' "$ARG" | grep -vE '^\s*[0-9]*:\s*(#|$)|\|\|' | head -8 | sed 's/^/    /' || true
    # weak words
    echo "  weak words (very, really, quite, basically, just):"
    grep -niE '\b(very|really|quite|basically|actually|just)\b' "$ARG" | head -6 | sed 's/^/    /' || true
    # long sentences (> 40 words)
    echo "  sentences over 40 words:"
    python3 - "$ARG" <<'PYEOF'
import re, sys
text = open(sys.argv[1], encoding="utf-8").read().replace("\n", " ")
for i, s in enumerate(re.split(r"(?<=[.?!])\s+", text), 1):
    words = len(s.split())
    if words > 40:
        print(f"    sentence {i}: {words} words — {s[:90].strip()}...")
PYEOF
    # heading style
    echo "  headings ending with ':' or with periods:"
    grep -nE '^#{1,6} .+[.:]$' "$ARG" | head -5 | sed 's/^/    /' || true
    ;&
  spell)
    echo "Spell check: $ARG"
    WORDS_LIST="${WORDS:-}"
    if command -v hunspell >/dev/null 2>&1; then
      # extract plain words, check with en dict
      python3 - "$ARG" "$WORDS_LIST" <<'PYEOF' | hunspell -l 2>/dev/null | sort -u | head -30 | sed 's/^/    /' || echo "    (no unknown words)"
import re, sys, html
text = open(sys.argv[1], encoding="utf-8").read()
text = re.sub(r"```.*?```", " ", text, flags=re.S)
words = re.findall(r"[A-Za-z]+", text)
wl = set(sys.argv[2].split(",")) if sys.argv[2] else set()
for w in words:
    if len(w) < 3 or w.lower() in wl:
        continue
    print(w)
PYEOF
    elif command -v aspell >/dev/null 2>&1; then
      echo "    (aspell)" 
      sed -e 's/```.*//' "$ARG" | aspell list -l en 2>/dev/null | sort -u | head -30 | sed 's/^/    /'
    else
      echo "    no spell checker (hunspell/aspell) — install one: pkg install hunspell"
    fi
    ;;
  links)
    echo "Links in $ARG:"
    grep -oE '\]\([^)]+\)' "$ARG" | sed 's/](//; s/)$//' | nl -w2 -s'. '
    if [ "$CHECK" = "1" ]; then
      echo ""
      echo "Checking:"
      for u in $(grep -oE '\]\((https?://[^)]+)+\)' "$ARG" | sed 's/](//; s/)$//'); do
        CODE=$(curl -sS -o /dev/null -w "%{http_code}" -L --max-time 15 -A "Mozilla/5.0" "$u" 2>/dev/null || echo ERR)
        [ "$CODE" = "200" ] || [ "$CODE" = "301" ] || [ "$CODE" = "302" ] && echo "  OK  ($CODE) $u" || echo "  FAIL ($CODE) $u"
      done
    fi
    ;;
esac