#!/usr/bin/env bash
# Image Tools — convert, resize, caption, OCR images
# Source: https://imagemagick.org/script/command-line-processing.php
set -euo pipefail

SCRIPT_NAME="image-tools.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} info <file>
       ${SCRIPT_NAME} convert <in> <out> [--resize WxH] [--quality N]
       ${SCRIPT_NAME} resize <in> <out> <WxH>
       ${SCRIPT_NAME} ocr <file> [--lang LANG]
Inspect, convert, resize images (ImageMagick) and run OCR (tesseract).

Options:
  --resize WxH  e.g. 800x600 or 50%
  --quality N   0-100 JPEG quality (default 85)
  --lang LANG   tesseract language (default eng)
  -h | --help   show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARGS=()
RESIZE=""
QUALITY=85
LANG="eng"
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    info|convert|resize|ocr) CMD="$1"; shift;;
    --resize) RESIZE="$2"; shift 2;;
    --quality) QUALITY="$2"; shift 2;;
    --lang) LANG="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARGS+=("$1"); shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }

case "$CMD" in
  info)
    F="${ARGS[0]:?usage: info <file>}"
    [ -f "$F" ] || { echo "not found: $F" >&2; exit 1; }
    if command -v identify >/dev/null 2>&1; then
      identify -verbose "$F" 2>&1 | grep -E '^  (Format|Geometry|Colorspace|Filesize|Type)' | head -6
    else
      python3 - "$F" <<'PYEOF'
import sys, os
from struct import unpack
p = sys.argv[1]
with open(p, "rb") as f:
    head = f.read(32)
if head[:8] == b"\x89PNG\r\n\x1a\n":
    w, h = unpack(">II", head[16:24]); print(f"PNG {w}x{h} {os.path.getsize(p)} bytes")
elif head[:2] == b"\xff\xd8":
    print(f"JPEG {os.path.getsize(p)} bytes (dimensions need ImageMagick)")
elif head[:6] in (b"GIF87a", b"GIF89a"):
    w, h = unpack("<HH", head[6:10]); print(f"GIF {w}x{h} {os.path.getsize(p)} bytes")
else:
    print(f"unknown format, {os.path.getsize(p)} bytes")
PYEOF
    fi
    ;;
  convert)
    IN="${ARGS[0]:?usage: convert <in> <out>}"
    OUT_ARG="${ARGS[1]:?usage: convert <in> <out>}"
    [ -f "$IN" ] || { echo "not found: $IN" >&2; exit 1; }
    if command -v convert >/dev/null 2>&1; then
      CMDLINE=(convert "$IN")
      [ -n "$RESIZE" ] && CMDLINE+=(-resize "$RESIZE")
      CMDLINE+=(-quality "$QUALITY" "$OUT_ARG")
      "${CMDLINE[@]}" 2>&1 | tail -3 && echo "done: $OUT_ARG"
    else
      echo "ImageMagick not installed: pkg install imagemagick" >&2
      exit 1
    fi
    ;;
  resize)
    IN="${ARGS[0]:?usage: resize <in> <out> <WxH>}"
    OUT_ARG="${ARGS[1]}"; SIZE="${ARGS[2]:?missing size}"
    [ -f "$IN" ] || { echo "not found: $IN" >&2; exit 1; }
    if command -v convert >/dev/null 2>&1; then
      convert "$IN" -resize "$SIZE" "$OUT_ARG" 2>&1 | tail -3 && echo "done: $OUT_ARG"
    else
      echo "ImageMagick not installed: pkg install imagemagick" >&2
      exit 1
    fi
    ;;
  ocr)
    F="${ARGS[0]:?usage: ocr <file>}"
    [ -f "$F" ] || { echo "not found: $F" >&2; exit 1; }
    if command -v tesseract >/dev/null 2>&1; then
      tesseract "$F" stdout -l "$LANG" 2>/dev/null
    else
      echo "tesseract not installed: pkg install tesseract tesseract-data $LANG" >&2
      echo "fallback: try python3 + pytesseract/pillow if available" >&2
      exit 1
    fi
    ;;
esac