#!/usr/bin/env bash
# Design System — design tokens, palettes, typography scales, spacing systems
# Source: https://m3.material.io/foundations
set -euo pipefail

SCRIPT_NAME="ui-design-system.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} palette <hex-color>
       ${SCRIPT_NAME} type-scale [--base 16]
       ${SCRIPT_NAME} spacing [--unit 4]
       ${SCRIPT_NAME} tokens [--out <file>]
Generate color palettes, typography scales, spacing scales, and CSS tokens.

Options:
  --base N    base font size px (default 16)
  --unit N    spacing unit px (default 4)
  --out FILE  write output to FILE
  -h | --help show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
COLOR=""
BASE=16
UNIT=4
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    palette|type-scale|spacing|tokens) CMD="$1"; shift;;
    --base) BASE="$2"; shift 2;;
    --unit) UNIT="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) COLOR="$1"; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }

emit() {
  if [ -n "$OUT" ]; then
    echo "$1" > "$OUT"
    echo "Saved to $OUT"
  else
    echo "$1"
  fi
}

case "$CMD" in
  palette)
    [ -z "$COLOR" ] && { echo "usage: ui-design-system.sh palette <hex>" >&2; exit 2; }
    python3 - "$COLOR" <<'PYEOF'
import sys, colorsys

hex_in = sys.argv[1].lstrip("#")
r, g, b = (int(hex_in[i:i+2], 16) / 255.0 for i in (0, 2, 4))
h, l, s = colorsys.rgb_to_hls(r, g, b)

def hex_out(rgb):
    return "#" + "".join(f"{max(0, min(255, round(c * 255))):02x}" for c in rgb)

steps = ["50", "100", "200", "300", "400", "500", "600", "700", "800", "900", "950"]
targets = [0.97, 0.93, 0.87, 0.78, 0.67, 0.55, 0.45, 0.36, 0.27, 0.18, 0.12]
for name, t in zip(steps, targets):
    # lighten/darken by adjusting lightness toward target; keep hue + sat
    s_adj = min(1.0, s * (0.7 if t < 0.5 else 1.0))
    out = colorsys.hls_to_rgb(h, t, s_adj if t < 0.97 else s_adj * 0.35)
    print(f"{name}: {hex_out(out)}")
PYEOF
    ;;
  type-scale)
    echo "Modular type scale (base ${BASE}px, ratio 1.25):"
    python3 - "$BASE" <<'PYEOF'
import sys
base = int(sys.argv[1])
ratio = 1.25
steps = [("text-xs", -2), ("text-sm", -1), ("text-base", 0), ("text-lg", 1),
         ("text-xl", 2), ("text-2xl", 3), ("text-3xl", 4), ("text-4xl", 5),
         ("text-5xl", 6), ("text-6xl", 7)]
for name, n in steps:
    size = round(base * ratio ** n, 1)
    line = round(size * 1.5, 1) if n <= 0 else round(size * 1.25, 1)
    print(f"  {name:<10} {size:>7}px   line-height {line}px")
PYEOF
    ;;
  spacing)
    echo "Spacing scale (unit ${UNIT}px):"
    for i in 0 1 2 3 4 5 6 8 10 12 16 20 24; do
      printf "  %-6s %4dpx\n" "space-$i" "$((i * UNIT))"
    done
    ;;
  tokens)
    python3 - "$BASE" "$UNIT" <<'PYEOF' 
import sys, colorsys
base, unit = int(sys.argv[1]), int(sys.argv[2])
print(":root {")
# spacing tokens
for i in (0, 1, 2, 3, 4, 5, 6, 8, 10, 12, 16, 20, 24):
    print(f"  --space-{i}: {i * unit}px;")
# type scale
ratio = 1.25
for name, n in (("xs",-2), ("sm",-1), ("base",0), ("lg",1), ("xl",2), ("2xl",3), ("3xl",4), ("4xl",5), ("5xl",6), ("6xl",7)):
    size = round(base * ratio ** n, 1)
    print(f"  --text-{name}: {size}px;")
# neutral grays
for name, l in (("50",0.97), ("100",0.93), ("200",0.87), ("300",0.78), ("400",0.67), ("500",0.55), ("600",0.45), ("700",0.36), ("800",0.27), ("900",0.18)):
    r, g, b = colorsys.hls_to_rgb(0.0, l, 0.0)
    c = "".join(f"{max(0, min(255, round(v * 255))):02x}" for v in (r, g, b))
    print(f"  --gray-{name}: #{c};")
print("}")
PYEOF
    ;;
esac