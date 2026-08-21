#!/usr/bin/env bash
# Wikipedia Search — MediaWiki REST API search & article fetch
# Source: https://en.wikipedia.org/api/rest_v1/ https://www.mediawiki.org/wiki/API:Main_page
set -euo pipefail

SCRIPT_NAME="wikipedia-search.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} <query> [--count N] [--lang XX] [--out <file>]
       ${SCRIPT_NAME} fetch <title> [--lang XX] [--out <file>]
Search Wikipedia or fetch an article summary.

Options:
  --count N      number of search results (default 10)
  --lang XX      language code (default en)
  --out FILE     write JSON to FILE
  -h | --help    show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

MODE="search"
QUERY=""
COUNT=10
LANG="en"
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    fetch) MODE="fetch"; shift;;
    --count) COUNT="$2"; shift 2;;
    --lang) LANG="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) QUERY="${QUERY:+$QUERY }$1"; shift;;
  esac
done

if [ "$MODE" = "search" ]; then
  RESP=$(curl -sS --max-time 30 \
    "https://${LANG}.wikipedia.org/w/api.php?action=query&list=search&srsearch=$(printf '%s' "$QUERY" | sed 's/ /%20/g')&srlimit=${COUNT}&format=json&origin=*")
  N=$(echo "$RESP" | jq '[.query.search[]?] | length')
  if [ "$N" = "0" ] || [ -z "$N" ]; then
    echo "No articles found for: $QUERY"
    exit 0
  fi
  if [ -n "$OUT" ]; then
    echo "$RESP" | jq '{query: "'"$QUERY"'", results: [.query.search[]? | {title, snippet}]}' > "$OUT"
    echo "Saved $N results to $OUT"
  else
    echo "$RESP" | jq -r '[.query.search[]? | {title, snippet}] | to_entries[] | "\(.key+1). \(.value.title)\n   \(.value.snippet // "" | gsub("<[^>]*>"; ""))\n"'
  fi
else
  TITLE=$(printf '%s' "$QUERY" | sed 's/ /_/g')
  RESP=$(curl -sS --max-time 30 \
    "https://${LANG}.wikipedia.org/api/rest_v1/page/summary/${TITLE}" \
    -H "Accept: application/json")
  if echo "$RESP" | jq -e '.type == "https://mediawiki.org/wiki/HyperSwitch/errors/not_found"' >/dev/null 2>&1; then
    echo "Article not found: $QUERY" >&2
    exit 1
  fi
  if [ -n "$OUT" ]; then
    echo "$RESP" | jq '{title, description, extract, url: .content_urls.desktop.page}' > "$OUT"
    echo "Saved article summary to $OUT"
  else
    echo "$RESP" | jq -r '"\(.title // "?") — \(.description // "")\n\n\(.extract // "")\n\nURL: \(.content_urls.desktop.page)"'
  fi
fi
