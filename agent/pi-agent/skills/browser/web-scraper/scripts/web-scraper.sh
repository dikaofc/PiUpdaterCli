#!/usr/bin/env bash
# Web Scraper — recursive site scraping with sitemap/robots compliance and polite delays
# Source: https://www.robotstxt.org/robotstxt.html
set -euo pipefail

SCRIPT_NAME="web-scraper.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} crawl <url> [--max-pages N] [--delay S] [--out DIR]
       ${SCRIPT_NAME} sitemap <url-or-file> [--out <file>]
       ${SCRIPT_NAME} robots <url> [--ua USER-AGENT]
Recursive site crawler with robots.txt awareness, sitemap parsing,
and polite delays. Uses curl + python3 stdlib (no external deps).

Options:
  --max-pages N  page limit (default 50)
  --delay S      seconds between requests (default 0.5)
  --out DIR      save scraped pages under DIR (default ./scrape_out)
  --ua STRING    user agent for robots checks (default ScraperBot/1.0)
  --out FILE     output file for sitemap
  -h | --help    show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
TARGET=""
MAX_PAGES=50
DELAY=0.5
OUT_DIR="scrape_out"
UA="ScraperBot/1.0"
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    crawl|sitemap|robots) CMD="$1"; shift;;
    --max-pages) MAX_PAGES="$2"; shift 2;;
    --delay) DELAY="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    --ua) UA="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) TARGET="$1"; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
[ -z "$TARGET" ] && { echo "missing target URL" >&2; exit 2; }

case "$CMD" in
  robots)
    url="$TARGET"
    [[ "$url" == http* ]] || url="https://$url"
    BASE=$(python3 -c "
from urllib.parse import urlparse
u = urlparse('$url')
print(f'{u.scheme}://{u.netloc}')")
    echo "fetching $BASE/robots.txt"
    ROBOTS=$(curl -sSL --max-time 20 -A "$UA" "$BASE/robots.txt" 2>/dev/null || echo "# (no robots.txt)")
    echo "$ROBOTS" | grep -q "User-agent" || echo "# (robots.txt not available)"
    echo "$ROBOTS" | python3 -c "
import sys, os
ua = os.environ.get('SCRAPE_UA', '')
print(sys.stdin.read())" 2>/dev/null || echo "$ROBOTS"
    ;;
  sitemap)
    if [ -f "$TARGET" ]; then
      CONTENT=$(cat "$TARGET")
    else
      CONTENT=$(curl -sSL --max-time 30 -A "$UA" "${TARGET}" 2>/dev/null || { echo "fetch failed" >&2; exit 1; })
    fi
    MAP_OUT="$OUT" python3 -c "
import re, sys, os
text = sys.stdin.read()
urls = re.findall(r'<loc>(.*?)</loc>', text, re.S)
out = os.environ.get('MAP_OUT', '')
if out:
    open(out, 'w').write('\n'.join(urls) + '\n')
    print(f'{len(urls)} URLs saved to {out}')
else:
    for u in urls:
        print(u)
    if not urls:
        print('no <loc> entries found (not a sitemap?)')" <<< "$CONTENT"
    ;;
  crawl)
    START="$TARGET"
    if [ "$OUT" != "" ]; then OUT_DIR="$OUT"; fi
    mkdir -p "$OUT_DIR"
    export SCRAPE_UA="$UA" SCRAPE_START="$START" SCRAPE_MAX="$MAX_PAGES" SCRAPE_DELAY="$DELAY" SCRAPE_DIR="$OUT_DIR"
    python3 - <<'PYEOF'
import os, re, time, urllib.parse
from html.parser import HTMLParser

BASE_UA = os.environ.get("SCRAPE_UA", "ScraperBot/1.0")
start = os.environ["SCRAPE_START"]
max_pages = int(os.environ.get("SCRAPE_MAX", "50"))
delay = float(os.environ.get("SCRAPE_DELAY", "0.5"))
outdir = os.environ.get("SCRAPE_DIR", "scrape_out")

import urllib.request

def fetch(url):
    req = urllib.request.Request(url, headers={"User-Agent": BASE_UA, "Accept": "text/html"})
    with urllib.request.urlopen(req, timeout=20) as r:
        return r.read().decode("utf-8", "replace")

# robots check (simple: user-agent * + Disallow prefixes)
def allowed(url, robots_text):
    for line in robots_text.splitlines():
        line = line.strip().lower()
        if line.startswith("disallow") and ":" in line:
            path = line.split(":", 1)[1].strip()
            if path and urlparse(url).path.strip("/").startswith(path.strip("/")):
                return False
    return True

from urllib.parse import urlparse, urljoin

class LinkParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.links = []
    def handle_starttag(self, tag, attrs):
        if tag == "a":
            for k, v in attrs:
                if k == "href" and v:
                    self.links.append(v)

parsed_start = urlparse(start)
base = f"{parsed_start.scheme}://{parsed_start.netloc}"
robots_text = ""
try:
    robots_text = fetch(base + "/robots.txt")
except Exception:
    pass

visited = set()
queue = [start]
count = 0
pages_saved = 0
print(f"crawling {start} (max {max_pages} pages, delay {delay}s, robots: {'loaded' if robots_text else 'none'})")
while queue and count < max_pages:
    url = queue.pop(0)
    if url in visited:
        continue
    visited.add(url)
    if not allowed(url, robots_text):
        print(f"  [robots] skipping {url}")
        continue
    try:
        html = fetch(url)
    except Exception as e:
        print(f"  [error] {url}: {e}")
        continue
    count += 1
    # save page
    fname = urlparse(url).path.strip("/").replace("/", "_") or "index"
    fname = re.sub(r"[^A-Za-z0-9_.-]", "_", fname)[:80] + ".html"
    path = os.path.join(outdir, f"{count:03d}_{fname}")
    with open(path, "w", encoding="utf-8") as f:
        f.write(f"<!-- source: {url} -->\n" + html)
    pages_saved += 1
    print(f"  [{count}] {url} -> {path}")
    # extract links
    p = LinkParser()
    p.feed(html)
    for link in p.links:
        full = urljoin(url, link)
        u = urlparse(full)
        if u.scheme not in ("http", "https"):
            continue
        if u.netloc != parsed_start.netloc:
            continue
        if u.fragment:
            full = full.split("#")[0]
        if full not in visited and url not in full.replace(full, full):  # keep same-origin only
            queue.append(full)
    time.sleep(delay)
print(f"done: {pages_saved} page(s) saved to {outdir}/")
PYEOF
    ;;
esac