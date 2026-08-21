#!/usr/bin/env bash
# News Aggregator — fetch headlines from RSS/Atom feeds
# Source: https://www.rssboard.org/rss-specification
set -euo pipefail

SCRIPT_NAME="news-aggregator.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} <feed-url> [<feed-url> ...] [--count N] [--out <file>]
       ${SCRIPT_NAME} --file <feeds.txt> [--count N] [--out <file>]
Fetch and parse RSS/Atom feeds into headline lists.

Options:
  --file FILE    read feed URLs from a file (one per line)
  --count N      max items per feed (default 10)
  --out FILE     write JSON to FILE
  -h | --help    show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

URLS=""
FEEDFILE=""
COUNT=10
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    --file) FEEDFILE="$2"; shift 2;;
    --count) COUNT="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) URLS="${URLS:+$URLS }$1"; shift;;
  esac
done

if [ -n "$FEEDFILE" ]; then
  [ -f "$FEEDFILE" ] || { echo "feed file not found: $FEEDFILE" >&2; exit 1; }
  URLS=$(grep -v '^[[:space:]]*#' "$FEEDFILE" | grep -v '^[[:space:]]*$')
fi

[ -z "$URLS" ] && { usage; exit 1; }

parse_feed() {
  python3 - "$1" "$2" <<'PYEOF'
import re, sys, json, html

raw, count = sys.argv[1], int(sys.argv[2])
items = []
# RSS items
for e in re.findall(r"<item>(.*?)</item>", raw, re.S):
    def f(tag):
        m = re.search(rf"<{tag}[^>]*>(.*?)</{tag}>", e, re.S)
        return html.unescape(re.sub(r"<[^>]+>", "", m.group(1))).strip() if m else ""
    items.append({"title": f("title"), "link": f("link"), "date": f("pubDate"), "description": f("description")[:300]})
# Atom entries
for e in re.findall(r"<entry>(.*?)</entry>", raw, re.S):
    def f(tag):
        m = re.search(rf"<{tag}[^>]*>(.*?)</{tag}>", e, re.S)
        return html.unescape(re.sub(r"<[^>]+>", "", m.group(1))).strip() if m else ""
    m = re.search(r'<link[^>]*href="([^"]+)"', e)
    items.append({"title": f("title"), "link": m.group(1) if m else "", "date": f("updated") or f("published"), "description": ""})
seen, out = set(), []
for it in items:
    if it["title"] and it["title"] not in seen:
        seen.add(it["title"]); out.append(it)
    if len(out) >= count:
        break
print(json.dumps(out, indent=2))
PYEOF
}

ALL="[]"
for U in $URLS; do
  RAW=$(curl -sS -L --max-time 30 -A "Mozilla/5.0" "$U" || true)
  ITEMS=$(parse_feed "$RAW" "$COUNT" 2>/dev/null || echo "[]")
  ALL=$(echo "$ALL" | jq --argjson items "$ITEMS" --arg feed "$U" '. + [{feed: $feed, items: $items}]')
done

TOTAL=$(echo "$ALL" | jq '[.items[]] | length')
if [ "$TOTAL" = "0" ]; then
  echo "No items parsed from the given feeds."
  exit 0
fi

if [ -n "$OUT" ]; then
  echo "$ALL" > "$OUT"
  echo "Saved $TOTAL items to $OUT"
else
  echo "$ALL" | jq -r '.[] | "=== \(.feed) ===\n" + ([.items[] | "• \(.title)  (\(.date // "?"))"] | join("\n")) + "\n"'
fi
