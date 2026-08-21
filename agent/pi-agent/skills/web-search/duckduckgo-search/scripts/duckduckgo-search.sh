#!/usr/bin/env bash
# DuckDuckGo Search — instant answers via the HTML endpoint (no API key)
# Source: https://duckduckgo.com/
set -euo pipefail

SCRIPT_NAME="duckduckgo-search.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} <query> [--count N] [--out <file>]
Search DuckDuckGo via the privacy-respecting HTML endpoint. No API key needed.

Options:
  --count N      number of results (default 10)
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

UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"
HTML=$(curl -sS --max-time 30 -A "$UA" \
  -H "Accept: text/html,application/xhtml+xml" \
  -H "Accept-Language: en-US,en;q=0.9" \
  -H "Referer: https://duckduckgo.com/" \
  --data-urlencode "q=$QUERY" \
  "https://html.duckduckgo.com/html/")

if ! echo "$HTML" | grep -q 'result__a'; then
  if echo "$HTML" | grep -qi 'anomaly\|challenge\|captcha'; then
    echo "DuckDuckGo blocked the request (bot detection). Try again later or use a different search skill." >&2
  else
    echo "No results found for: $QUERY"
  fi
  exit 1
fi

RESULTS=$(python3 - "$HTML" "$COUNT" <<'PYEOF'
import html, re, sys, json

raw, count = sys.argv[1], int(sys.argv[2])
blocks = re.split(r'<div class="result results_links', raw)
out = []
for b in blocks[1:]:
    m = re.search(r'<a rel="nofollow" class="result__a" href="([^"]+)"[^>]*>(.*?)</a>', b, re.S)
    if not m:
        continue
    url = html.unescape(m.group(1))
    title = html.unescape(re.sub(r"<[^>]+>", "", m.group(2))).strip()
    s = re.search(r'class="result__snippet"[^>]*>(.*?)</a>', b, re.S)
    snippet = html.unescape(re.sub(r"<[^>]+>", "", s.group(1))).strip() if s else ""
    out.append({"title": title, "url": url, "snippet": snippet})
    if len(out) >= count:
        break
print(json.dumps(out, indent=2))
PYEOF
)

if [ "$(echo "$RESULTS" | jq 'length')" = "0" ]; then
  echo "No results found for: $QUERY"
  exit 0
fi

if [ -n "$OUT" ]; then
  echo "$RESULTS" | jq '{query: "'"$QUERY"'", results: .}' > "$OUT"
  echo "Saved $(echo "$RESULTS" | jq 'length') results to $OUT"
else
  echo "$RESULTS" | jq -r 'to_entries[] | "\(.key+1). \(.value.title)\n   \(.value.url)\n   \(.value.snippet // "")\n"'
fi
