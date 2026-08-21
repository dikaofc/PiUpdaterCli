#!/usr/bin/env bash
# SQLite Toolkit — inspect DBs, schema, run queries, WAL analysis
# Source: https://www.sqlite.org/cli.html
set -euo pipefail

SCRIPT_NAME="sqlite-toolkit.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} inspect <file.db> [--tables-only]
       ${SCRIPT_NAME} schema <file.db>
       ${SCRIPT_NAME} query <file.db> <sql> [--out <file>]
       ${SCRIPT_NAME} wal <file.db>
Inspect SQLite databases, schemas, WAL mode, and run queries.
Uses python3's built-in sqlite3 module (no CLI needed).

Options:
  --tables-only  list only table names
  --out FILE     write query output to FILE
  -h | --help    show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
DB=""
SQL=""
TABLES_ONLY=0
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    inspect|schema|query|wal) CMD="$1"; shift;;
    --tables-only) TABLES_ONLY=1; shift;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) if [ -z "$DB" ]; then DB="$1"; else SQL="${SQL:+$SQL }$1"; fi; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
[ -f "$DB" ] || { echo "database not found: $DB" >&2; exit 1; }

python3 - "$DB" "$CMD" "$SQL" "$TABLES_ONLY" "$OUT" <<'PYEOF'
import sqlite3, sys

db, cmd, sql, tables_only, out = sys.argv[1], sys.argv[2], sys.argv[3], bool(int(sys.argv[4])), sys.argv[5]
conn = sqlite3.connect(db)
conn.row_factory = sqlite3.Row
cur = conn.cursor()

def emit(text):
    if out:
        open(out, "w").write(text)
        print(f"Saved to {out}")
    else:
        print(text)

if cmd == "inspect":
    if tables_only:
        emit("\n".join(r[0] for r in cur.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name")))
    else:
        tables = cur.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name").fetchall()
        lines = [f"database: {db}", f"tables: {len(tables)}"]
        for t in tables:
            tname = t["name"]
            cols = len(cur.execute(f'PRAGMA table_info("{tname}")').fetchall())
            try:
                n = cur.execute(f'SELECT COUNT(*) FROM "{tname}"').fetchone()[0]
            except Exception:
                n = "?"
            lines.append(f"  {tname} ({cols} cols, {n} rows)")
        emit("\n".join(lines))
elif cmd == "schema":
    rows = cur.execute("SELECT type, name, sql FROM sqlite_master WHERE sql IS NOT NULL ORDER BY type, name").fetchall()
    emit("\n\n".join(f"--- {r['type']}: {r['name']}\n{r['sql']};" for r in rows) if rows else "no schema")
elif cmd == "wal":
    mode = cur.execute("PRAGMA journal_mode").fetchone()[0]
    wal = cur.execute("PRAGMA wal_checkpoint(TRUNCATE)").fetchall() if mode == "wal" else []
    page = cur.execute("PRAGMA page_size").fetchone()[0]
    emit(f"journal mode: {mode}\npage size: {page}\nwal checkpoint: {wal}")
elif cmd == "query":
    try:
        if sql.strip().lower().startswith(("select", "pragma", "explain")):
            rows = cur.execute(sql).fetchall()
            if rows:
                names = [d[0] for d in cur.description]
                widths = [max(len(n), *(len(str(r[i])) for r in rows)) for i, n in enumerate(names)]
                body = "\n".join(["  ".join(n.ljust(w) for n, w in zip(names, widths)),
                                  "  ".join("-" * w for w in widths)] +
                                 ["  ".join(str(r[i]).ljust(w) for i, w in enumerate(widths)) for r in rows] +
                                 [f"({len(rows)} rows)"])
                emit(body)
            else:
                emit("(0 rows)")
        else:
            cur.executescript(sql)
            conn.commit()
            emit("OK")
    except Exception as e:
        print(f"SQL error: {e}", file=sys.stderr)
        sys.exit(1)
PYEOF