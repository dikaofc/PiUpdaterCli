#!/usr/bin/env bash
# SearXNG Meta Search — search across many engines via a SearXNG instance
# Source: https://docs.searxng.org/
set -euo pipefail

SCRIPT_NAME="searxng.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} <query> [--engine google|github|...] [--count N] [--out <file>]
Meta-search via a SearXNG instance (JSON format). No API key.

Environment:
  SEARXNG_URL   instance base URL (default https://searx.be)

Options:
  --engine NAME   restrict to one engine
  --count N       number of results (default 10)
  --out FILE      write JSON results to FILE
  -h | --help     show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

QUERY=""
ENGINE=""
COUNT=10
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    --engine) ENGINE="$2"; shift 2;;
    --count) COUNT="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) QUERY="${QUERY:+$QUERY }$1"; shift;;
  esac
done

BASE="${SEARXNG_URL:-https://searx.be}"
URL="${BASE}/search?q=$(printf '%s' "$QUERY" | sed 's/ /%20/g')&format=json"
[ -n "$ENGINE" ] && URL="${URL}&engines=${ENGINE}"

RESP=$(curl -sS --max-time 30 -A "Mozilla/5.0 (X11; Linux x86_64)" "$URL")

if echo "$RESP" | jq -e '.error' >/dev/null 2>&1; then
  echo "SearXNG error: $(echo "$RESP" | jq -r '.error // "unknown"')" >&2
  exit 1
fi

N=$(echo "$RESP" | jq '[.results[]?] | length')
if [ "$N" = "0" ] || [ -z "$N" ]; then
  echo "No results found for: $QUERY (instance: $BASE)"
  exit 0
fi

if [ -n "$OUT" ]; then
  echo "$RESP" | jq '{query: "'"$QUERY"'", results: [.results[]? | {title, url, content, engine}]}' > "$OUT"
  echo "Saved $N results to $OUT"
else
  echo "$RESP" | jq -r '[.results[]? | {title, url, content, engine}] | to_entries[] | "\(.key+1). \(.value.title)\n   \(.value.url)\n   \(.value.content // "")\n   [\(.value.engine)]\n"'
fi
