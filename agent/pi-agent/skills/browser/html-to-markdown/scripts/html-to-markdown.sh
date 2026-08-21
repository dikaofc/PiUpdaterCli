#!/usr/bin/env bash
# HTML to Markdown — convert HTML pages to readable Markdown
# Sources: https://spec.commonmark.org/0.30/ https://developer.mozilla.org/docs/Web/HTML/Element
set -euo pipefail

SCRIPT_NAME="html-to-markdown.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} <file.html|url> [--out <file.md>]
Convert HTML to Markdown. Works on local files, raw HTML on stdin,
or URLs (fetched via curl).

Options:
  --out FILE   write markdown to FILE
  -h | --help  show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

INPUT=""
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    --out) OUT="$2"; shift 2;;
    -) INPUT="-"; shift;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) INPUT="$1"; shift;;
  esac
done
[ -z "$INPUT" ] && { usage; exit 1; }

if [ "$INPUT" = "-" ]; then
  HTML=$(cat)
elif [[ "$INPUT" == http* ]]; then
  HTML=$(curl -sSL --max-time 30 -A "Mozilla/5.0" "$INPUT" 2>/dev/null || { echo "fetch failed: $INPUT" >&2; exit 1; })
elif [ -f "$INPUT" ]; then
  HTML=$(cat "$INPUT")
else
  echo "input not found: $INPUT" >&2
  exit 1
fi

MD_OUT="$OUT" python3 - "$HTML" <<'PYEOF'
import re, html, sys
from html.parser import HTMLParser

raw = sys.argv[1]
# Strip scripts/styles/comments first
raw = re.sub(r"(?is)<(script|style|noscript|template)[^>]*>.*?</\1>", " ", raw)
raw = re.sub(r"(?is)<!--.*?-->", " ", raw)

class MD(HTMLParser):
    BLOCK = {"p","li","div","section","article","header","footer","tr","blockquote","pre","ul"}
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.out = []
        self.list_stack = []
        self.in_code = 0
        self.in_pre = 0
        self.skip = 0
        self.h = 0
        self.a_href = ""
        self.em = 0
        self.strong = 0
    def handle_starttag(self, tag, attrs):
        a = dict(attrs)
        if tag in ("h1","h2","h3","h4","h5","h6"):
            self.h = int(tag[1]); self.out.append("\n" + "#" * self.h + " ")
        elif tag == "p":
            self.out.append("\n\n")
        elif tag == "br":
            self.out.append("\n")
        elif tag in ("ul","ol"):
            self.list_stack.append(("ol" if tag == "ol" else "ul", 0)); self.out.append("\n")
        elif tag == "li":
            kind, n = self.list_stack[-1] if self.list_stack else ("ul", 0)
            self.list_stack[-1] = (kind, n + 1)
            self.out.append(("\n" + "  " * (len(self.list_stack) - 1) + (f"{n+1}. " if kind == "ol" else "- ")))
        elif tag == "blockquote":
            self.out.append("\n> ")
        elif tag == "pre":
            self.in_pre = 1; self.out.append("\n```\n")
        elif tag == "code":
            if not self.in_pre:
                self.out.append("`")
        elif tag == "a":
            self.a_href = a.get("href", "")
            self.out.append("[")
        elif tag == "strong" or tag == "b":
            self.strong = 1; self.out.append("**")
        elif tag == "em" or tag == "i":
            self.em = 1; self.out.append("*")
        elif tag in ("img",):
            self.out.append(f"\n![{a.get('alt','')}]({a.get('src','')})\n")
        elif tag == "hr":
            self.out.append("\n---\n")
        elif tag == "table":
            self.out.append("\n")
        elif tag == "th" or tag == "td":
            self.out.append(" | " if self.out and self.out[-1] != "\n" else "| ")
        elif tag == "tr":
            self.out.append("\n|")
        elif tag in ("script", "style"):
            self.skip += 1
    def handle_endtag(self, tag):
        if tag in ("h1","h2","h3","h4","h5","h6"):
            self.out.append("\n"); self.h = 0
        elif tag == "p":
            self.out.append("\n")
        elif tag == "li":
            self.out.append("\n")
        elif tag in ("ul","ol"):
            if self.list_stack: self.list_stack.pop()
            self.out.append("\n")
        elif tag == "pre":
            self.in_pre = 0; self.out.append("\n```\n")
        elif tag == "code":
            if not self.in_pre: self.out.append("`")
        elif tag == "a":
            if self.a_href:
                # close any inline **/* markers at end of link text for clean nesting
                self.out.append(f"]({self.a_href})")
                self.a_href = ""
        elif tag == "strong" or tag == "b":
            self.strong = 0; self.out.append("**")
        elif tag == "em" or tag == "i":
            self.em = 0; self.out.append("*")
        elif tag == "script" or tag == "style":
            self.skip -= 1
    def handle_data(self, data):
        if self.skip: return
        if self.in_pre:
            self.out.append(data)
            return
        self.out.append(data)

p = MD()
try:
    p.feed(raw)
except Exception as e:
    print(f"html parse warning: {e}", file=sys.stderr)
p.close()

text = "".join(p.out)
# collapse 3+ newlines
text = re.sub(r"\n{3,}", "\n\n", text)
text = re.sub(r"[ \t]+\n", "\n", text)
lines = [ln.rstrip() for ln in text.splitlines()] or [""]
md = "\n".join(lines).strip() + "\n"
if sys.argv[0]: pass
out_path = __import__("os").environ.get("MD_OUT", "")
if out_path:
    open(out_path, "w", encoding="utf-8").write(md)
    print(f"Saved to {out_path}")
else:
    sys.stdout.write(md)
PYEOF