#!/usr/bin/env bash
# Markdown Tools — lint, inject TOC, check links, convert Markdown
# Source: https://spec.commonmark.org/
set -euo pipefail

SCRIPT_NAME="markdown-tools.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} toc <file.md> [--out <file>]
       ${SCRIPT_NAME} lint <file.md>
       ${SCRIPT_NAME} links <file.md> [--check]
       ${SCRIPT_NAME} convert <file.md> [--out <file>.html]
Generate a table of contents, lint style issues, check links, convert to HTML.

Options:
  --check        verify external links with HEAD requests
  --out FILE     write result to FILE
  -h | --help    show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
INPUT=""
CHECK=0
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    toc|lint|links|convert) CMD="$1"; shift;;
    --check) CHECK=1; shift;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) INPUT="$1"; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
[ -f "$INPUT" ] || { echo "file not found: $INPUT" >&2; exit 1; }

emit() {
  if [ -n "$OUT" ]; then
    echo "$1" > "$OUT"
    echo "Saved to $OUT"
  else
    echo "$1"
  fi
}

case "$CMD" in
  toc)
    emit "$(awk '
      /^#{1,6} / {
        line = $0
        sub(/^#+ /, "", line)
        level = index($0, " ") - 1
        indent = sprintf("%*s", (level - 1) * 2, "")
        anchor = tolower(line)
        gsub(/[^a-z0-9 -]/, "", anchor)
        gsub(/ /, "-", anchor)
        printf "%s- [%s](#%s)\n", indent, line, anchor
      }' "$INPUT")"
    ;;
  lint)
    ISSUES=0
    check() { ISSUES=$((ISSUES + 1)); echo "  $1"; }
    echo "Lint: $INPUT"
    # trailing whitespace
    awk '/[ \t]+$/ {print NR}' "$INPUT" | head -5 | while read -r n; do check "trailing whitespace (line $n)"; done
    # non-sequential heading levels
    awk '
      /^#{1,6} / { l = index($0, " ") - 1
        if (prev && l > prev + 1) print "heading level jump: line " NR " (level " prev " -> " l ")"
        prev = l }' "$INPUT" | while IFS= read -r msg; do check "$msg"; done
    # unbalanced code fences
    FENCES=$(grep -c '^```' "$INPUT")
    [ $((FENCES % 2)) -ne 0 ] && check "unbalanced code fences ($FENCES backtick fences)"
    # bare TODO / FIXME
    grep -n 'TODO\|FIXME\|XXX' "$INPUT" | head -3 | while IFS= read -r line; do check "marker found: $line"; done
    # broken relative links (local files)
    grep -oE '\]\([^)]+\)' "$INPUT" | sed 's/](//; s/)$//' | grep -vE '^(http|#|mailto:)' | sort -u | while IFS= read -r target; do
      [ -e "$target" ] || check "broken relative link: $target"
    done
    if [ "$ISSUES" = "0" ]; then echo "  no issues found"; else echo "  ($ISSUES issue(s) found)"; fi
    ;;
  links)
    LINKS=$(grep -oE '\]\([^)]+\)' "$INPUT" | sed 's/](//; s/)$//' | sort -u)
    echo "Links in $INPUT:"
    echo "$LINKS" | nl -w2 -s'. '
    if [ "$CHECK" = "1" ]; then
      echo ""
      echo "Checking external links:"
      for u in $LINKS; do
        case "$u" in
          http*)
            CODE=$(curl -sS -o /dev/null -w "%{http_code}" -L --max-time 15 -A "Mozilla/5.0" "$u" 2>/dev/null || echo "ERR")
            if [ "$CODE" = "200" ] || [ "$CODE" = "301" ] || [ "$CODE" = "302" ]; then
              echo "  OK  ($CODE) $u"
            else
              echo "  FAIL ($CODE) $u"
            fi
            ;;
        esac
      done
    fi
    ;;
  convert)
    python3 - "$INPUT" <<'PYEOF' > "${TMPDIR:-/tmp}/md_out.html" 2>/dev/null || true
import re, sys
md = open(sys.argv[1], encoding="utf-8").read()
lines = md.splitlines()
out, in_code, i = [], False, 0
while i < len(lines):
    line = lines[i]
    m = re.match(r"^(#{1,6})\s+(.*)", line)
    if m:
        lvl = len(m.group(1)); out.append(f"<h{lvl}>{m.group(2)}</h{lvl}>"); i += 1; continue
    if line.startswith("```"):
        out.append("<pre><code>" if not in_code else "</code></pre>")
        in_code = not in_code; i += 1; continue
    if not in_code:
        m = re.match(r"^\s*[-*]\s+(.*)", line)
        if m:
            out.append(f"<li>{m.group(1)}</li>"); i += 1; continue
        m = re.match(r"^>\s?(.*)", line)
        if m:
            out.append(f"<blockquote>{m.group(1)}</blockquote>"); i += 1; continue
        if re.match(r"^!\[([^\]]*)\]\(([^)]+)\)", line):
            m = re.match(r"^!\[([^\]]*)\]\(([^)]+)\)", line)
            out.append(f'<img alt="{m.group(1)}" src="{m.group(2)}">'); i += 1; continue
        m = re.match(r"^\[([^\]]+)\]\(([^)]+)\)", line)
        if m:
            out.append(f'<a href="{m.group(2)}">{m.group(1)}</a>'); i += 1; continue
        if line.strip() == "": out.append(""); i += 1; continue
        if in_code:
            out.append(line)
        else:
            out.append(f"<p>{line}</p>")
    else:
        out.append(line)
    i += 1
html = "<!doctype html><html><head><meta charset='utf-8'><title>Converted</title></head><body>\n" + "\n".join(out) + "\n</body></html>"
sys.stdout.write(html)
PYEOF
    if [ -s "${TMPDIR:-/tmp}/md_out.html" ]; then
      if [ -n "$OUT" ]; then mv "${TMPDIR:-/tmp}/md_out.html" "$OUT"; echo "Converted to $OUT"; else cat "${TMPDIR:-/tmp}/md_out.html"; fi
    else
      echo "conversion failed (python3 unavailable?)" >&2; exit 1
    fi
    ;;
esac
