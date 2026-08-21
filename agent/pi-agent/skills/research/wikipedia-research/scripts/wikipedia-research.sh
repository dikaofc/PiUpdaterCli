#!/usr/bin/env bash
# Wikipedia Research — search, fetch, cross-link articles and categories
# Source: https://en.wikipedia.org/api/rest_v1/
set -euo pipefail

SCRIPT_NAME="wikipedia-research.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} <title> [--lang XX] [--out <file>]
       ${SCRIPT_NAME} categories <title> [--lang XX]
       ${SCRIPT_NAME} links <title> [--count N] [--lang XX]
       ${SCRIPT_NAME} search <query> [--count N] [--lang XX]
Fetch article summaries, categories, and cross-links.

Options:
  --count N      number of links/search results (default 20)
  --lang XX      language code (default en)
  --out FILE     write JSON to FILE
  -h | --help    show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

MODE="fetch"
QUERY=""
COUNT=20
LANG="en"
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    categories) MODE="categories"; shift;;
    links) MODE="links"; shift;;
    search) MODE="search"; shift;;
    --count) COUNT="$2"; shift 2;;
    --lang) LANG="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) QUERY="${QUERY:+$QUERY }$1"; shift;;
  esac
done

TITLE=$(printf '%s' "$QUERY" | sed 's/ /_/g')

case "$MODE" in
  search)
    RESP=$(curl -sS --max-time 30 "https://${LANG}.wikipedia.org/w/api.php?action=query&list=search&srsearch=$(printf '%s' "$QUERY" | sed 's/ /%20/g')&srlimit=${COUNT}&format=json&origin=*")
    if [ -n "$OUT" ]; then
      echo "$RESP" | jq '{query: "'"$QUERY"'", results: [.query.search[]? | {title, snippet}]}' > "$OUT"
      echo "Saved to $OUT"
    else
      echo "$RESP" | jq -r '[.query.search[]? | {title, snippet}] | to_entries[] | "\(.key+1). \(.value.title)\n   \(.value.snippet | gsub("<[^>]*>"; ""))"'
    fi
    ;;
  categories)
    RESP=$(curl -sS --max-time 30 "https://${LANG}.wikipedia.org/w/api.php?action=query&titles=${TITLE}&prop=categories&cllimit=${COUNT}&format=json&origin=*")
    if [ -n "$OUT" ]; then
      echo "$RESP" | jq '{title: "'"$QUERY"'", categories: [.query.pages[].categories[]?.title]}' > "$OUT"
      echo "Saved to $OUT"
    else
      echo "$RESP" | jq -r '"Categories of: \(.query.pages[].title // "'"$QUERY"'")\n" + ([.query.pages[].categories[]?.title] | join("\n"))'
    fi
    ;;
  links)
    RESP=$(curl -sS --max-time 30 "https://${LANG}.wikipedia.org/w/api.php?action=query&titles=${TITLE}&prop=links&pllimit=${COUNT}&format=json&origin=*")
    if [ -n "$OUT" ]; then
      echo "$RESP" | jq '{title: "'"$QUERY"'", links: [.query.pages[].links[]?.title]}' > "$OUT"
      echo "Saved to $OUT"
    else
      echo "$RESP" | jq -r '"Links from: \(.query.pages[].title // "'"$QUERY"'")\n" + ([.query.pages[].links[]?.title] | join("\n"))'
    fi
    ;;
  fetch)
    RESP=$(curl -sS --max-time 30 "https://${LANG}.wikipedia.org/api/rest_v1/page/summary/${TITLE}" -H "Accept: application/json")
    if echo "$RESP" | jq -e '.type == "https://mediawiki.org/wiki/HyperSwitch/errors/not_found"' >/dev/null 2>&1; then
      echo "Article not found: $QUERY" >&2; exit 1
    fi
    if [ -n "$OUT" ]; then
      echo "$RESP" | jq '{title, description, extract, url: .content_urls.desktop.page}' > "$OUT"
      echo "Saved to $OUT"
    else
      echo "$RESP" | jq -r '"\(.title) — \(.description // "")\n\n\(.extract // "")\n\nURL: \(.content_urls.desktop.page)"'
    fi
    ;;
esac
