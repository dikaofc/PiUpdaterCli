#!/usr/bin/env bash
# CSV Tools — inspect, transform, validate, and query CSV files
# Sources: https://csvkit.readthedocs.io/ https://www.rfc-editor.org/rfc/rfc4180
set -euo pipefail

SCRIPT_NAME="csv-tools.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} inspect <file.csv> [--rows N]
       ${SCRIPT_NAME} query <file.csv> <sql>
       ${SCRIPT_NAME} filter <file.csv> <column> <op> <value>
       ${SCRIPT_NAME} stats <file.csv>
       ${SCRIPT_NAME} tojson <file.csv> [--out <file>]
Inspect, query (SQL), filter, and convert CSV files. Uses python3's csv module.

Options:
  --rows N       preview rows for inspect (default 5)
  --out FILE     write result to FILE
  -h | --help    show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
POS=()
ROWS=5
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    inspect|query|filter|stats|tojson) CMD="$1"; shift;;
    --rows) ROWS="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -) POS+=("$1"); shift;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) POS+=("$1"); shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
INPUT="${POS[0]:-}"
SQL="${POS[1]:-}"
COL="${POS[1]:-}"
OP="${POS[2]:-}"
VAL="${POS[3]:-}"

[ -f "$INPUT" ] || { echo "file not found: $INPUT" >&2; exit 1; }

case "$CMD" in
  inspect)
    python3 - "$INPUT" "$ROWS" <<'PYEOF'
import csv, sys

path, rows = sys.argv[1], int(sys.argv[2])
with open(path, newline="", encoding="utf-8", errors="replace") as f:
    reader = csv.reader(f)
    header = next(reader, [])
    data = list(reader)
ncols = len(header)
print(f"file: {path}")
print(f"rows: {len(data)}  columns: {ncols}")
print(f"columns: {', '.join(header)}")
print("\npreview:")
for i, r in enumerate(data[:rows]):
    cells = (c[:40] + "…" if len(c) > 40 else c for c in r[:ncols])
    print(f"  {i+1:>4}  " + " | ".join(cells))
PYEOF
    ;;
  query)
    [ -z "$SQL" ] && { echo "usage: csv-tools.sh query <file> <sql>" >&2; exit 2; }
    python3 - "$INPUT" "$SQL" <<'PYEOF'
import csv, sqlite3, sys

path, sql = sys.argv[1], sys.argv[2]
conn = sqlite3.connect(":memory:")
with open(path, newline="", encoding="utf-8", errors="replace") as f:
    reader = csv.reader(f)
    header = next(reader)
    cols = ", ".join(f'"{c}"' for c in header)
    conn.execute(f"CREATE TABLE data ({cols})")
    conn.executemany(f"INSERT INTO data VALUES ({','.join('?' * len(header))})", reader)
try:
    cur = conn.execute(sql)
    out = cur.fetchall()
    if cur.description:
        names = [d[0] for d in cur.description]
        print("\t".join(names))
        for row in out:
            print("\t".join("" if v is None else str(v) for v in row))
    else:
        conn.commit()
        print(f"OK ({cur.rowcount} rows affected)")
except Exception as e:
    print(f"SQL error: {e}", file=sys.stderr)
    sys.exit(1)
PYEOF
    ;;
  filter)
    [ -z "$COL" ] || [ -z "$OP" ] || [ -z "$VAL" ] && { echo "usage: csv-tools.sh filter <file> <column> <op> <value>" >&2; exit 2; }
    python3 - "$INPUT" "$COL" "$OP" "$VAL" "$OUT" <<'PYEOF'
import csv, sys

path, col, op, val, out = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5]
ops = {"=": lambda a, b: a == b, "!=": lambda a, b: a != b,
       ">": lambda a, b: a > b, ">=": lambda a, b: a >= b,
       "<": lambda a, b: a < b, "<=": lambda a, b: a <= b,
       "contains": lambda a, b: b in a, "startswith": lambda a, b: a.startswith(b)}
pred = ops.get(op)
if pred is None:
    print(f"unknown op: {op} (use =, !=, >, >=, <, <=, contains, startswith)", file=sys.stderr)
    sys.exit(2)
dest = open(out, "w", newline="") if out else sys.stdout
with open(path, newline="", encoding="utf-8", errors="replace") as f:
    reader = csv.DictReader(f)
    writer = csv.DictWriter(dest, fieldnames=reader.fieldnames)
    writer.writeheader()
    n = 0
    for row in reader:
        if pred(row.get(col, ""), val):
            writer.writerow(row)
            n += 1
if out:
    print(f"{n} matching rows written to {out}")
else:
    print(f"{n} matching rows", file=sys.stderr)
PYEOF
    ;;
  stats)
    python3 - "$INPUT" <<'PYEOF'
import csv, sys
from collections import Counter

def _isnum(s):
    try:
        float(s); return True
    except ValueError:
        return False

path = sys.argv[1]
with open(path, newline="", encoding="utf-8", errors="replace") as f:
    reader = csv.DictReader(f)
    rows = list(reader)
print(f"rows: {len(rows)}")
for col in reader.fieldnames:
    vals = [r.get(col, "") for r in rows]
    nonempty = [v for v in vals if v != ""]
    uniq = len(set(vals))
    print(f"  {col}: non-empty={len(nonempty)} unique={uniq}")
    if nonempty and all(_isnum(v) for v in nonempty):
        nums = sorted(float(v) for v in nonempty)
        mean = sum(nums) / len(nums)
        mid = nums[len(nums) // 2]
        print(f"      numeric: min={nums[0]} max={nums[-1]} mean={mean:.2f} median={mid}")
    elif nonempty:
        top = Counter(nonempty).most_common(3)
        print(f"      top: " + ", ".join(f"{k} ({v})" for k, v in top))
PYEOF
    ;;
  tojson)
    if [ -n "$OUT" ]; then
      python3 - "$INPUT" "$OUT" <<'PYEOF'
import csv, json, sys
with open(sys.argv[1], newline="", encoding="utf-8", errors="replace") as f:
    rows = list(csv.DictReader(f))
json.dump(rows, open(sys.argv[2], "w"), indent=2)
print(f"{len(rows)} rows written to {sys.argv[2]}")
PYEOF
    else
      python3 - "$INPUT" <<'PYEOF'
import csv, json, sys
with open(sys.argv[1], newline="", encoding="utf-8", errors="replace") as f:
    rows = list(csv.DictReader(f))
print(json.dumps(rows, indent=2))
PYEOF
    fi
    ;;
esac
