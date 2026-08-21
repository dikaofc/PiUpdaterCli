#!/usr/bin/env bash
# Book Search — OpenLibrary / Google Books metadata + covers
# Source: https://openlibrary.org/developers/api
set -euo pipefail

SCRIPT_NAME="book-search.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} <query> [--count N] [--engine openlibrary|google] [--cover] [--out <file>]
Search books and fetch metadata + cover URLs.

Options:
  --count N        number of results (default 10)
  --engine NAME    openlibrary (default) or google
  --cover          include cover URLs
  --out FILE       write JSON to FILE
  -h | --help      show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

QUERY=""
COUNT=10
ENGINE="openlibrary"
COVER=0
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    --count) COUNT="$2"; shift 2;;
    --engine) ENGINE="$2"; shift 2;;
    --cover) COVER=1; shift;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) QUERY="${QUERY:+$QUERY }$1"; shift;;
  esac
done

Q=$(printf '%s' "$QUERY" | sed 's/ /%20/g')

if [ "$ENGINE" = "google" ]; then
  RESP=$(curl -sS --max-time 30 "https://www.googleapis.com/books/v1/volumes?q=${Q}&maxResults=${COUNT}")
  N=$(echo "$RESP" | jq '[.items[]?] | length')
  if [ "$N" = "0" ] || [ -z "$N" ]; then echo "No books found: $QUERY"; exit 0; fi
  if [ -n "$OUT" ]; then
    echo "$RESP" | jq '{query: "'"$QUERY"'", results: [.items[]? | {title: .volumeInfo.title, authors: .volumeInfo.authors, publisher: .volumeInfo.publisher, year: .volumeInfo.publishedDate, url: .volumeInfo.infoLink}]}' > "$OUT"
    echo "Saved $N books to $OUT"
  else
    echo "$RESP" | jq -r '[.items[]? | {title: .volumeInfo.title, authors: .volumeInfo.authors, year: .volumeInfo.publishedDate, url: .volumeInfo.infoLink}] | to_entries[] | "\(.key+1). \(.value.title) (\(.value.year // "?"))\n   \(.value.authors // [] | join(", "))\n   \(.value.url)"'
  fi
else
  RESP=$(curl -sS --max-time 30 "https://openlibrary.org/search.json?q=${Q}&limit=${COUNT}")
  N=$(echo "$RESP" | jq '[.docs[]?] | length')
  if [ "$N" = "0" ] || [ -z "$N" ]; then echo "No books found: $QUERY"; exit 0; fi
  if [ -n "$OUT" ]; then
    if [ "$COVER" = "1" ]; then
      echo "$RESP" | jq '{query: "'"$QUERY"'", results: [.docs[]? | {title, authors: .author_name, year: .first_publish_year, key, url: ("https://openlibrary.org" + .key), cover: ("https://covers.openlibrary.org/b/id/" + (.cover_i|tostring) + "-M.jpg")}]}' > "$OUT"
    else
      echo "$RESP" | jq '{query: "'"$QUERY"'", results: [.docs[]? | {title, authors: .author_name, year: .first_publish_year, key, url: ("https://openlibrary.org" + .key)}]}' > "$OUT"
    fi
    echo "Saved $N books to $OUT"
  else
    if [ "$COVER" = "1" ]; then
      echo "$RESP" | jq -r '[.docs[]? | {title, authors: (.author_name // [] | join(", ")), year: .first_publish_year, url: ("https://openlibrary.org" + .key), cover: ("https://covers.openlibrary.org/b/id/" + (.cover_i|tostring) + "-M.jpg")}] | to_entries[] | "\(.key+1). \(.value.title) (\(.value.year // "?"))\n   \(.value.authors)\n   \(.value.url)\n   Cover: \(.value.cover)"'
    else
      echo "$RESP" | jq -r '[.docs[]? | {title, authors: (.author_name // [] | join(", ")), year: .first_publish_year, url: ("https://openlibrary.org" + .key)}] | to_entries[] | "\(.key+1). \(.value.title) (\(.value.year // "?"))\n   \(.value.authors)\n   \(.value.url)"'
    fi
  fi
fi
