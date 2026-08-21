#!/usr/bin/env bash
# DOCX Tools — read, create, modify Word .docx files via Office Open XML
# Source: https://learn.microsoft.com/en-us/office/open-xml/word
set -euo pipefail

SCRIPT_NAME="docx-tools.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} text <file.docx>
       ${SCRIPT_NAME} create <out.docx> <text-file|-> [--title T]
       ${SCRIPT_NAME} replace <file.docx> <old> <new> [--out <file>]
       ${SCRIPT_NAME} info <file.docx>
Read text, create simple docx, find/replace text. Works via python3
(+ zipfile + basic XML). No external libraries required.

Options:
  --title T     title for created document
  --out FILE    write result to FILE
  -h | --help   show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARGS=()
TITLE=""
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    text|create|replace|info) CMD="$1"; shift;;
    --title) TITLE="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -) ARGS+=("$1"); shift;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARGS+=("$1"); shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }

case "$CMD" in
  text)
    F="${ARGS[0]:?usage: text <file.docx>}"
    [ -f "$F" ] || { echo "not found: $F" >&2; exit 1; }
    python3 - "$F" <<'PYEOF'
import sys, zipfile, re
path = sys.argv[1]
with zipfile.ZipFile(path) as z:
    xml = z.read("word/document.xml").decode("utf-8")
# paragraphs
paras = re.split(r"</w:p>", xml)
for p in paras:
    texts = re.findall(r"<w:t[^>]*>([^<]*)</w:t>", p)
    line = "".join(texts).replace("&amp;", "&").replace("&lt;", "<").replace("&gt;", ">")
    if line.strip():
        print(line)
PYEOF
    ;;
  create)
    OUT_DOCX="${ARGS[0]:?usage: create <out.docx> <text-file>}"
    SRC="${ARGS[1]:--}"
    if [ "$SRC" = "-" ]; then BODY=$(cat); else [ -f "$SRC" ] && BODY=$(cat "$SRC") || { echo "not found: $SRC" >&2; exit 1; }; fi
    DOCX_BODY="$BODY" python3 - "$OUT_DOCX" "$TITLE" <<'PYEOF'
import sys, zipfile, os
from xml.sax.saxutils import escape

out_docx, title = sys.argv[1], sys.argv[2]
body = os.environ.get("DOCX_BODY", "")
paras = []
if title:
    paras.append(f'<w:p><w:r><w:rPr><w:b/><w:sz w:val="36"/></w:rPr><w:t xml:space="preserve">{escape(title)}</w:t></w:r></w:p>')
paras.append('<w:p><w:r><w:rPr><w:sz w:val="24"/></w:rPr><w:t xml:space="preserve">&#160;</w:t></w:r></w:p>' if not title else '')
for line in body.splitlines():
    paras.append(f'<w:p><w:r><w:t xml:space="preserve">{escape(line)}</w:t></w:r></w:p>')

doc_xml = ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
 '<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">'
 '<w:body>' + "".join(paras) +
 '<w:sectPr><w:pgSz w:w="12240" w:h="15840"/><w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440"/></w:sectPr>'
 '</w:body></w:document>')

content_types = ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
 '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
 '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
 '<Default Extension="xml" ContentType="application/xml"/>'
 '<Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>'
 '</Types>')

rels = ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
 '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
 '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>'
 '</Relationships>')

with zipfile.ZipFile(out_docx, "w") as z:
    z.writestr("[Content_Types].xml", content_types)
    z.writestr("_rels/.rels", rels)
    z.writestr("word/document.xml", doc_xml)
print(f"created {out_docx}")
PYEOF
    ;;
  replace)
    F="${ARGS[0]:?usage: replace <file.docx> <old> <new>}"
    OLD="${ARGS[1]}"
    NEW="${ARGS[2]:-}"
    OUT_F="${OUT:-$F}"
    python3 - "$F" "$OUT_F" "$OLD" "$NEW" <<'PYEOF'
import sys, zipfile, re
src, dst, old, new = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
with zipfile.ZipFile(src) as z:
    xml = z.read("word/document.xml").decode("utf-8")
    n = xml.count(old)
    xml = xml.replace(old, new)
    with zipfile.ZipFile(dst, "w") as out:
        for item in z.infolist():
            data = z.read(item.filename)
            if item.filename == "word/document.xml":
                data = xml.encode("utf-8")
            out.writestr(item, data)
print(f"replaced {n} occurrence(s) -> {dst}")
PYEOF
    ;;
  info)
    F="${ARGS[0]:?usage: info <file.docx>}"
    [ -f "$F" ] || { echo "not found: $F" >&2; exit 1; }
    python3 - "$F" <<'PYEOF'
import sys, zipfile
path = sys.argv[1]
with zipfile.ZipFile(path) as z:
    core = z.read("docProps/core.xml").decode("utf-8") if "docProps/core.xml" in z.namelist() else ""
    app = z.read("docProps/app.xml").decode("utf-8") if "docProps/app.xml" in z.namelist() else ""
    dom = z.read("word/document.xml").decode("utf-8")
import re
def tag(xml, name):
    m = re.search(rf"<{name}[^>]*>([^<]*)</{name}>", xml)
    return m.group(1) if m else ""
print(f"file: {path}")
print(f"title: {tag(core, 'dc:title') or 'n/a'}")
print(f"creator: {tag(core, 'dc:creator') or 'n/a'}")
print(f"words: {tag(app, 'Words') or 'n/a'}")
print(f"paragraphs (approx): {dom.count('<w:p ')}")
PYEOF
    ;;
esac