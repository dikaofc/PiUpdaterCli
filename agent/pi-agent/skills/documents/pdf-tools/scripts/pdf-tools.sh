#!/usr/bin/env bash
# PDF Tools — extract text, fill forms, merge, split, inspect metadata
# Source: https://pypdf.readthedocs.io/
set -euo pipefail

SCRIPT_NAME="pdf-tools.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} text <file.pdf> [--page N]
       ${SCRIPT_NAME} info <file.pdf>
       ${SCRIPT_NAME} merge <a.pdf> <b.pdf> [more...] --out <result.pdf>
       ${SCRIPT_NAME} split <file.pdf> [--pages 1-3,5] [--out <prefix>]
       ${SCRIPT_NAME} fields <file.pdf>
Extract text, inspect metadata, merge, split, and list form fields.
Requires python3 with pypdf (pip install pypdf).

Options:
  --page N      extract a single page (1-based)
  --pages R     page ranges e.g. 1-3,5 (for split)
  --out FILE    output file
  -h | --help   show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARGS=()
PAGE=""
PAGES=""
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    text|info|merge|split|fields) CMD="$1"; shift;;
    --page) PAGE="$2"; shift 2;;
    --pages) PAGES="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARGS+=("$1"); shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }

python3 - "$CMD" "${ARGS[@]}" "$PAGE" "$PAGES" "$OUT" <<'PYEOF'
import sys

cmd = sys.argv[1]
try:
    from pypdf import PdfReader, PdfWriter
except ImportError:
    print("pypdf not installed: pip install pypdf", file=sys.stderr)
    sys.exit(3)

def reader(p):
    if not p.endswith(".pdf"):
        print(f"error: not a pdf: {p}", file=sys.stderr); sys.exit(1)
    return PdfReader(p)

if cmd == "info":
    r = reader(sys.argv[2])
    meta = r.metadata or {}
    print(f"pages: {len(r.pages)}")
    print(f"title: {meta.get('/Title', 'n/a')}")
    print(f"author: {meta.get('/Author', 'n/a')}")
    print(f"creator: {meta.get('/Creator', 'n/a')}")
    print(f"encrypted: {r.is_encrypted}")

elif cmd == "text":
    p = sys.argv[2]
    page = sys.argv[-5] if len(sys.argv) >= 6 else ""
    r = reader(p)
    if page:
        try:
            n = int(page) - 1
            print(r.pages[n].extract_text() or "(no text extracted — scanned image?)")
        except Exception as e:
            print(f"error: {e}", file=sys.stderr); sys.exit(1)
    else:
        for i, pg in enumerate(r.pages, 1):
            print(f"--- page {i} ---")
            print(pg.extract_text() or "(no text)")

elif cmd == "merge":
    files = [a for a in sys.argv[2:-3] if a.endswith(".pdf")]
    out = sys.argv[-1]
    w = PdfWriter()
    for f in files:
        for pg in reader(f).pages:
            w.add_page(pg)
    with open(out, "wb") as fh:
        w.write(fh)
    print(f"merged {len(files)} pdf(s) -> {out} ({len(w.pages)} pages)")

elif cmd == "split":
    p = sys.argv[2]
    pages = sys.argv[-3]
    out_prefix = sys.argv[-1] or "split"
    r = reader(p)
    wanted = []
    for part in pages.split(","):
        part = part.strip()
        if "-" in part:
            a, b = part.split("-"); wanted += list(range(int(a), int(b) + 1))
        elif part:
            wanted.append(int(part))
    for n in wanted:
        w = PdfWriter()
        w.add_page(r.pages[n - 1])
        fname = f"{out_prefix}_{n}.pdf"
        with open(fname, "wb") as fh:
            w.write(fh)
        print(f"wrote {fname}")

elif cmd == "fields":
    r = reader(sys.argv[2])
    if not r.get_fields():
        print("no form fields found")
    else:
        for name, f in r.get_fields().items():
            print(f"{name}: value={f.get('/V', '(empty)')} type_field={'/T' in f}")
PYEOF