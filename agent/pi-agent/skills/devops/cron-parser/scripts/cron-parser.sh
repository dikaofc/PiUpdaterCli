#!/usr/bin/env bash
# Cron Parser — parse, validate, describe, and generate cron expressions
# Sources: https://en.wikipedia.org/wiki/Cron https://crontab.guru/
set -euo pipefail

SCRIPT_NAME="cron-parser.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} "<cron-expr>" [--next N] [--out <file>]
Validate 5-field cron expressions, describe them in words,
and compute upcoming run times.

Example: ${SCRIPT_NAME} "*/15 9-17 * * 1-5"

Options:
  --next N    show the next N run times (default 5, max 10)
  --out FILE  write JSON to FILE
  -h | --help show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

EXPR=""
NEXT=5
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    --next) NEXT="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) EXPR="${EXPR:+$EXPR }$1"; shift;;
  esac
done

[ -z "$EXPR" ] && { usage; exit 1; }
[ "$NEXT" -gt 10 ] && NEXT=10

if [ -n "$OUT" ]; then
  python3 - "$EXPR" "$NEXT" <<'PYEOF' > "$OUT"
import sys, json
from datetime import datetime, timedelta

expr = sys.argv[1]
n_next = int(sys.argv[2])
fields = expr.split()
if len(fields) != 5:
    print(json.dumps({"expr": expr, "error": "must have exactly 5 fields (min hour dom month dow)"}, indent=2))
    sys.exit(1)

RANGES = [("minute", 0, 59), ("hour", 0, 23), ("day-of-month", 1, 31), ("month", 1, 12), ("day-of-week", 0, 7)]
DOW_NAMES = ["sun", "mon", "tue", "wed", "thu", "fri", "sat", "sun"]
MONTH_NAMES = [None, "jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"]

def expand(field, lo, hi, name, names=None):
    if field == "*":
        return set(range(lo, hi + 1)), f"every {name}"
    vals, desc = set(), []
    for part in field.split(","):
        if part == "":
            continue
        step = 1
        base = part
        if "/" in part:
            base, _, step_s = part.partition("/")
            step = int(step_s)
        start, end = lo, hi
        if "-" in base:
            a, _, b = base.partition("-")
            start = int(a); end = int(b)
            vals |= set(range(start, end + 1, step))
            lbl = (names[start] if names and start < len(names) and names[start] else str(start)) + "-" + (names[end] if names and end < len(names) and names[end] else str(end))
            desc.append(f"every {step} {name}(s) {lbl}" if step > 1 else f"{lbl} {name}")
        elif base == "*":
            vals |= set(range(lo, hi + 1, step))
            desc.append(f"every {step} {name}s" if step > 1 else f"every {name}")
        else:
            v = int(base)
            vals.add(v)
            desc.append(names[v] if names and v < len(names) and names[v] else str(v))
    return vals, ", ".join(desc)

minutes, dm = expand(fields[0], 0, 59, "minute")
hours, dh = expand(fields[1], 0, 23, "hour")
doms, dd = expand(fields[2], 1, 31, "day-of-month")
months, dmo = expand(fields[3], 1, 12, "month", MONTH_NAMES)
dows, dw = expand(fields[4], 0, 7, "day-of-week", DOW_NAMES)
dows = {0 if d == 7 else d for d in dows}

desc_parts = [dh, dm, "on " + dd + " of month", "in " + dmo, "on " + dw]
description = "At " + ", ".join(p for p in desc_parts if p)

now = datetime.now().replace(second=0, microsecond=0)
results = []
candidate = now + timedelta(minutes=1)
while len(results) < n_next:
    if candidate.minute in minutes and candidate.hour in hours and candidate.month in months and (
        candidate.day in doms or candidate.weekday() in dows):
        results.append(candidate.isoformat())
    candidate += timedelta(minutes=1)

out = {
    "expr": expr,
    "valid": True,
    "description": description,
    "fields": {
        "minute": sorted(minutes), "hour": sorted(hours),
        "day-of-month": sorted(doms), "month": sorted(months), "day-of-week": sorted(dows),
    },
    "next_runs": results,
}
print(json.dumps(out, indent=2))
PYEOF
  echo "Saved to $OUT"
else
  python3 - "$EXPR" "$NEXT" <<'PYEOF'
import sys, json
from datetime import datetime, timedelta

expr = sys.argv[1]
n_next = int(sys.argv[2])
fields = expr.split()
if len(fields) != 5:
    print(json.dumps({"expr": expr, "error": "must have exactly 5 fields (min hour dom month dow)"}, indent=2))
    sys.exit(1)

RANGES = [("minute", 0, 59), ("hour", 0, 23), ("day-of-month", 1, 31), ("month", 1, 12), ("day-of-week", 0, 7)]
DOW_NAMES = ["sun", "mon", "tue", "wed", "thu", "fri", "sat", "sun"]
MONTH_NAMES = [None, "jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"]

def expand(field, lo, hi, name, names=None):
    if field == "*":
        return set(range(lo, hi + 1)), f"every {name}"
    vals, desc = set(), []
    for part in field.split(","):
        if part == "":
            continue
        step = 1
        base = part
        if "/" in part:
            base, _, step_s = part.partition("/")
            step = int(step_s)
        start, end = lo, hi
        if "-" in base:
            a, _, b = base.partition("-")
            start = int(a); end = int(b)
            vals |= set(range(start, end + 1, step))
            lbl = (names[start] if names and start < len(names) and names[start] else str(start)) + "-" + (names[end] if names and end < len(names) and names[end] else str(end))
            desc.append(f"every {step} {name}(s) {lbl}" if step > 1 else f"{lbl} {name}")
        elif base == "*":
            vals |= set(range(lo, hi + 1, step))
            desc.append(f"every {step} {name}s" if step > 1 else f"every {name}")
        else:
            v = int(base)
            vals.add(v)
            desc.append(names[v] if names and v < len(names) and names[v] else str(v))
    return vals, ", ".join(desc)

minutes, dm = expand(fields[0], 0, 59, "minute")
hours, dh = expand(fields[1], 0, 23, "hour")
doms, dd = expand(fields[2], 1, 31, "day-of-month")
months, dmo = expand(fields[3], 1, 12, "month", MONTH_NAMES)
dows, dw = expand(fields[4], 0, 7, "day-of-week", DOW_NAMES)
dows = {0 if d == 7 else d for d in dows}

desc_parts = [dh, dm, "on " + dd + " of month", "in " + dmo, "on " + dw]
description = "At " + ", ".join(p for p in desc_parts if p)

now = datetime.now().replace(second=0, microsecond=0)
results = []
candidate = now + timedelta(minutes=1)
while len(results) < n_next:
    if candidate.minute in minutes and candidate.hour in hours and candidate.month in months and (
        candidate.day in doms or candidate.weekday() in dows):
        results.append(candidate.isoformat())
    candidate += timedelta(minutes=1)

out = {
    "expr": expr,
    "valid": True,
    "description": description,
    "fields": {
        "minute": sorted(minutes), "hour": sorted(hours),
        "day-of-month": sorted(doms), "month": sorted(months), "day-of-week": sorted(dows),
    },
    "next_runs": results,
}
print(json.dumps(out, indent=2))
PYEOF
fi