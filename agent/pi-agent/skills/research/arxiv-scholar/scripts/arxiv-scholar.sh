#!/usr/bin/env bash
# ArXiv Scholar — search & fetch arXiv papers via the arXiv API
# Source: https://arxiv.org/help/api/user-manual
set -euo pipefail

SCRIPT_NAME="arxiv-scholar.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} <query> [--count N] [--sort relevance|submitted] [--out <file>]
       ${SCRIPT_NAME} fetch <id> [--out <file>]     # fetch one paper (e.g. 1706.03762)
Search arXiv and extract titles, authors, abstracts.

Options:
  --count N        number of results (default 10, max 100)
  --sort FIELD     sort by relevance or submitted (default relevance)
  --out FILE       write JSON to FILE
  -h | --help      show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

MODE="search"
QUERY=""
COUNT=10
SORT="relevance"
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    fetch) MODE="fetch"; shift;;
    --count) COUNT="$2"; shift 2;;
    --sort) SORT="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) QUERY="${QUERY:+$QUERY }$1"; shift;;
  esac
done

parse_atom() {
  # Parse arXiv Atom XML into JSON via python3 (robust against multi-line fields)
  python3 - "$1" <<'PYEOF'
import re, sys, json

xml = sys.argv[1]
entries = re.findall(r"<entry>(.*?)</entry>", xml, re.S)
out = []
for e in entries:
    def field(tag):
        m = re.search(rf"<{tag}[^>]*>(.*?)</{tag}>", e, re.S)
        return m.group(1).strip() if m else ""
    authors = re.findall(r"<name>(.*?)</name>", e, re.S)
    links = re.findall(r'<link[^>]*href="([^"]+)"[^>]*title="(?:pdf|abs)"', e) or re.findall(r'<link[^>]*href="([^"]+)"', e)
    out.append({
        "id": field("id").split("/abs/")[-1],
        "title": re.sub(r"\s+", " ", field("title")),
        "authors": [a.strip() for a in authors],
        "published": field("published"),
        "abstract": re.sub(r"\s+", " ", field("summary")),
        "url": links[0] if links else "",
    })
print(json.dumps(out, indent=2))
PYEOF
}

if [ "$MODE" = "search" ]; then
  RESP=$(curl -sS --max-time 40 \
    "https://export.arxiv.org/api/query?search_query=all:$(printf '%s' "$QUERY" | sed 's/ /+/g')&start=0&max_results=${COUNT}&sortBy=${SORT}")
  RESULTS=$(parse_atom "$RESP")
  N=$(echo "$RESULTS" | jq 'length')
  if [ "$N" = "0" ]; then
    echo "No papers found for: $QUERY"
    exit 0
  fi
  if [ -n "$OUT" ]; then
    echo "$RESULTS" | jq '{query: "'"$QUERY"'", results: .}' > "$OUT"
    echo "Saved $N papers to $OUT"
  else
    echo "$RESULTS" | jq -r 'to_entries[] | "\(.key+1). \(.value.title)\n   \(.value.url) [\(.value.id)]\n   \(.value.authors[0]) et al. (\(.value.published[0:10]))\n"'
  fi
else
  RESP=$(curl -sS --max-time 40 "http://export.arxiv.org/api/query?id_list=${QUERY}")
  RESULTS=$(parse_atom "$RESP")
  if [ "$(echo "$RESULTS" | jq 'length')" = "0" ]; then
    echo "Paper not found: $QUERY" >&2
    exit 1
  fi
  if [ -n "$OUT" ]; then
    echo "$RESULTS" > "$OUT"
    echo "Saved paper to $OUT"
  else
    echo "$RESULTS" | jq -r '.[0] | "\(.title)\n\n\(.abstract)\n\nAuthors: \(.authors | join(", "))\nPublished: \(.published[0:10])\nURL: \(.url)"'
  fi
fi
