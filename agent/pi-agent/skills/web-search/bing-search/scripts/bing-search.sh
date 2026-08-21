#!/usr/bin/env bash
# Bing Search — Microsoft Bing Web Search API v7
# Source: https://learn.microsoft.com/bing/search-apis/bing-web-search/overview
set -euo pipefail

SCRIPT_NAME="bing-search.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} <query> [--count N] [--out <file>]
Search the web via the Bing Web Search API v7.

Environment:
  BING_API_KEY   required (Azure subscription key)

Options:
  --count N      number of results (default 10, max 50)
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

: "${BING_API_KEY:?BING_API_KEY not set. Get a key from the Azure portal.}"

RESP=$(curl -sS --max-time 30 \
  "https://api.bing.microsoft.com/v7.0/search?q=$(printf '%s' "$QUERY" | sed 's/ /%20/g')&count=${COUNT}&responseFilter=Webpages" \
  -H "Ocp-Apim-Subscription-Key: ${BING_API_KEY}" \
  -H "Accept: application/json")

if echo "$RESP" | jq -e '.error' >/dev/null 2>&1; then
  echo "Bing API error: $(echo "$RESP" | jq -r '.error.message')" >&2
  exit 1
fi

N=$(echo "$RESP" | jq '[.webPages.value[]?] | length')
if [ "$N" = "0" ] || [ -z "$N" ]; then
  echo "No results found for: $QUERY"
  exit 0
fi

OUTPUT=$(echo "$RESP" | jq -r '
  [.webPages.value[]? | {title, url, snippet, "displayUrl": .displayUrl}] |
  to_entries[] | "\(.key+1). \(.value.title)\n   \(.value.url)\n   \(.value.snippet // "")\n"')

if [ -n "$OUT" ]; then
  echo "$RESP" | jq '{query: "'"$QUERY"'", results: [.webPages.value[]? | {title, url, snippet}]}' > "$OUT"
  echo "Saved $N results to $OUT"
else
  echo "$OUTPUT"
fi
