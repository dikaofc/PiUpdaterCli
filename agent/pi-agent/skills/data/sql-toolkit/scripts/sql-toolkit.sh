#!/usr/bin/env bash
# SQL Toolkit — run ad-hoc SQL against sqlite/postgres/mysql, schema docs
# Source: https://www.sqlite.org/cli.html
set -euo pipefail

SCRIPT_NAME="sql-toolkit.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} run <db> <sql>          # db: file.sqlite | postgres://... | mysql://...
       ${SCRIPT_NAME} schema <db> [--out <file>]
       ${SCRIPT_NAME} tables <db>
Run SQL against SQLite files or postgres/mysql URLs, and dump schema docs.

Examples:
  ${SCRIPT_NAME} run app.db "SELECT * FROM users LIMIT 5;"
  ${SCRIPT_NAME} schema app.db
  ${SCRIPT_NAME} tables postgres://user:pass@host/db

Options:
  --out FILE   write schema docs to FILE
  -h | --help  show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
DB=""
SQL=""
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    run|schema|tables) CMD="$1"; shift;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) if [ -z "$DB" ]; then DB="$1"; else SQL="${SQL:+$SQL }$1"; fi; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
[ -z "$DB" ] && { echo "missing database argument" >&2; exit 2; }

dbtype() {
  case "$DB" in
    postgres://*|postgresql://*) echo "postgres";;
    mysql://*|mariadb://*) echo "mysql";;
    *.sqlite|*.db|*.sqlite3) echo "sqlite";;
    *) echo "sqlite";;
  esac
}

case "$(dbtype)" in
  postgres)
    : "${PSQL:?psql client not found — install postgresql or set PSQL=path}"
    case "$CMD" in
      run) $PSQL "$DB" -c "$SQL" ;;
      tables) $PSQL "$DB" -c "\dt" ;;
      schema) $PSQL "$DB" -c "\d+";;
    esac
    ;;
  mysql)
    : "${MYSQL:?mysql client not found — install mysql or set MYSQL=path}"
    case "$CMD" in
      run) $MYSQL --url "$DB" -e "$SQL" ;;
      tables) $MYSQL --url "$DB" -e "SHOW TABLES;" ;;
      schema) $MYSQL --url "$DB" -e "SHOW FULL TABLES;";;
    esac
    ;;
  sqlite)
    python3 - "$DB" "$CMD" "$SQL" "$OUT" <<'PYEOF'
import sqlite3, sys

db, cmd, sql, out = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
conn = sqlite3.connect(db)
conn.row_factory = sqlite3.Row
cur = conn.cursor()

def emit(text):
    if out:
        open(out, "w").write(text)
        print(f"Saved to {out}")
    else:
        print(text)

if cmd == "tables":
    rows = cur.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name").fetchall()
    emit("tables:\n" + "\n".join(f"  {r['name']}" for r in rows) if rows else "no tables")
elif cmd == "schema":
    parts = []
    for r in cur.execute("SELECT name, sql FROM sqlite_master WHERE type IN ('table','index') AND sql IS NOT NULL ORDER BY name"):
        parts.append(f"-- {r['name']}\n{r['sql']};")
    if not parts:
        emit("no schema found")
    else:
        emit("\n\n".join(parts))
elif cmd == "run":
    try:
        if sql.strip().lower().startswith(("select", "pragma", "explain")):
            rows = cur.execute(sql).fetchall()
            if rows:
                names = [d[0] for d in cur.description]
                widths = [max(len(n), *(len(str(r[i])) for r in rows)) for i, n in enumerate(names)]
                emit("  ".join(n.ljust(w) for n, w in zip(names, widths)))
                emit("  ".join("-" * w for w in widths))
                for r in rows:
                    emit("  ".join(str(r[i]).ljust(w) for i, w in enumerate(widths)))
                emit(f"({len(rows)} rows)")
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
    ;;
esac
