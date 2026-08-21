#!/usr/bin/env bash
# Scholarly Search — Semantic Scholar / Crossref academic references
# Source: https://api.semanticscholar.org/ https://www.crossref.org/
set -euo pipefail

SCRIPT_NAME="scholarly-search.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} <query> [--engine s2|crossref] [--count N] [--out <file>]
Search academic references via Semantic Scholar or Crossref.

Options:
  --engine NAME   s2 (default) or crossref
  --count N       number of results (default 10)
  --out FILE      write JSON to FILE
  -h | --help     show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

QUERY=""
ENGINE="s2"
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

Q=$(printf '%s' "$QUERY" | sed 's/ /%20/g')

if [ "$ENGINE" = "crossref" ]; then
  RESP=$(curl -sS --max-time 30 "https://api.crossref.org/works?query=${Q}&rows=${COUNT}")
  N=$(echo "$RESP" | jq '[.message.items[]?] | length')
  if [ "$N" = "0" ] || [ -z "$N" ]; then echo "No results: $QUERY"; exit 0; fi
  if [ -n "$OUT" ]; then
    echo "$RESP" | jq '{query: "'"$QUERY"'", results: [.message.items[]? | {title: (.title[0] // ""), authors: [.author[]? | (.given + " " + .family)], year: (.issued."date-parts"[0][0] // null), doi, container: (.container-title[0] // "")}]}' > "$OUT"
    echo "Saved $N results to $OUT"
  else
    echo "$RESP" | jq -r '[.message.items[]? | {title: (.title[0] // ""), authors: [.author[]? | (.given + " " + .family)], year: (.issued."date-parts"[0][0] // "?"), doi}] | to_entries[] | "\(.key+1). \(.value.title)\n   \(.value.authors[0] // "?") et al. (\(.value.year)) — doi:\(.value.doi)"'
  fi
else
  RESP=$(curl -sS --max-time 30 "https://api.semanticscholar.org/graph/v1/paper/search?query=${Q}&limit=${COUNT}&fields=title,year,authors,abstract,citationCount,externalIds,url")
  if echo "$RESP" | jq -e '.error' >/dev/null 2>&1; then
    echo "Semantic Scholar error: $(echo "$RESP" | jq -r '.error // "rate limited"')" >&2
    exit 1
  fi
  N=$(echo "$RESP" | jq '[.data[]?] | length')
  if [ "$N" = "0" ] || [ -z "$N" ]; then echo "No results: $QUERY"; exit 0; fi
  if [ -n "$OUT" ]; then
    echo "$RESP" | jq '{query: "'"$QUERY"'", results: [.data[]? | {title, year, authors: [.authors[]?.name], citationCount, url}]}' > "$OUT"
    echo "Saved $N results to $OUT"
  else
    echo "$RESP" | jq -r '[.data[]? | {title, year, authors: [.authors[]?.name], citationCount, url}] | to_entries[] | "\(.key+1). \(.value.title) (\(.value.year // "?")) — \(.value.citationCount // 0) citations\n   \(.value.authors[0] // "?") et al.\n   \(.value.url)"'
  fi
fi
