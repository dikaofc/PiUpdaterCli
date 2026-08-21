#!/usr/bin/env bash
# Google Search — Programmable Search Engine JSON API
# Source: https://developers.google.com/custom-search/v1/
set -euo pipefail

SCRIPT_NAME="google-search.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} <query> [--count N] [--out <file>]
Search Google via the Programmable Search Engine JSON API.

Environment:
  GOOGLE_API_KEY   required (Google Cloud API key)
  GOOGLE_CX        required (search engine ID)

Options:
  --count N      number of results (default 10, max 10)
  --out FILE     write JSON results to FILE
  -h | --help    show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

QUERY=""
COUNT=10
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    --count) COUNT="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) QUERY="${QUERY:+$QUERY }$1"; shift;;
  esac
done

: "${GOOGLE_API_KEY:?GOOGLE_API_KEY not set}"
: "${GOOGLE_CX:?GOOGLE_CX not set}"

RESP=$(curl -sS --max-time 30 \
  "https://www.googleapis.com/customsearch/v1?key=${GOOGLE_API_KEY}&cx=${GOOGLE_CX}&num=${COUNT}&q=$(printf '%s' "$QUERY" | sed 's/ /%20/g')")

if echo "$RESP" | jq -e '.error' >/dev/null 2>&1; then
  echo "Google API error: $(echo "$RESP" | jq -r '.error.message')" >&2
  exit 1
fi

N=$(echo "$RESP" | jq '[.items[]?] | length')
if [ "$N" = "0" ] || [ -z "$N" ]; then
  echo "No results found for: $QUERY"
  exit 0
fi

if [ -n "$OUT" ]; then
  echo "$RESP" | jq '{query: "'"$QUERY"'", results: [.items[]? | {title, link, snippet}]}' > "$OUT"
  echo "Saved $N results to $OUT"
else
  echo "$RESP" | jq -r '[.items[]? | {title, link, snippet}] | to_entries[] | "\(.key+1). \(.value.title)\n   \(.value.link)\n   \(.value.snippet // "")\n"'
fi
