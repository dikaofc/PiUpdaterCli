#!/usr/bin/env bash
# PPTX Tools — extract text and notes from PowerPoint .pptx slides
# Source: https://python-pptx.readthedocs.io/
set -euo pipefail

SCRIPT_NAME="pptx-tools.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} text <file.pptx>
       ${SCRIPT_NAME} notes <file.pptx>
Extract slide text and speaker notes from PowerPoint files.
Works via python3 + zipfile (no external libs required).

Options:
  -h | --help   show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
F=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    text|notes) CMD="$1"; shift;;
    *) F="$1"; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
[ -n "$F" ] || { echo "usage: pptx-tools.sh $CMD <file.pptx>" >&2; exit 2; }
[ -f "$F" ] || { echo "not found: $F" >&2; exit 1; }

python3 - "$F" "$CMD" <<'PYEOF'
import sys, zipfile, re

path, cmd = sys.argv[1], sys.argv[2]

def strip_ns(tag):
    return tag.split("}")[-1] if "}" in tag else tag

def text_of(xml):
    out = []
    for m in re.finditer(r"<a:t[^>]*>([^<]*)</a:t>", xml):
        out.append(m.group(1))
    return "".join(out)

def paragraphs_of(xml):
    paras = []
    for p in re.split(r"</a:p>", xml):
        t = text_of(p)
        if t.strip():
            paras.append(t)
    return paras

with zipfile.ZipFile(path) as z:
    slides = sorted([n for n in z.namelist() if re.match(r"ppt/slides/slide\d+\.xml$", n)],
                    key=lambda n: int(re.search(r"(\d+)", n).group(1)))
    if not slides:
        print("no slides found"); sys.exit(1)
    for i, s in enumerate(slides, 1):
        xml = z.read(s).decode("utf-8", errors="replace")
        print(f"\n--- slide {i} ---")
        for para in paragraphs_of(xml):
            print(para)
        if cmd == "notes":
            # find associated notesSlide
            note_rel = f"ppt/slides/_rels/{s.split('/')[-1]}.rels"
            note_target = None
            if note_rel in z.namelist():
                relxml = z.read(note_rel).decode("utf-8")
                m = re.search(r'notesSlide[^"]*', relxml)
                if m:
                    fname = m.group(0)
                    note_target = "ppt/notesSlides/" + fname.split("/")[-1]
            if note_target and note_target in z.namelist():
                nx = z.read(note_target).decode("utf-8", errors="replace")
                nt = text_of(nx)
                if nt.strip():
                    print(f"  [notes] {nt}")
PYEOF