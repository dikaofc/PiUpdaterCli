#!/usr/bin/env bash
# Postgres Toolkit — inspect schema, run queries, manage connections, explain plans
# Source: https://www.postgresql.org/docs/current/reference.html
set -euo pipefail

SCRIPT_NAME="postgres-toolkit.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} run <url> <sql> [--out <file>]
       ${SCRIPT_NAME} schema <url>
       ${SCRIPT_NAME} tables <url>
       ${SCRIPT_NAME} connections <url>
       ${SCRIPT_NAME} explain <url> <sql>
Run queries, inspect schema, list connections, and EXPLAIN ANALYZE.
Requires the psql client. URL format: postgres://user:pass@host:5432/db

Options:
  --out FILE   write query output to FILE
  -h | --help  show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
URL=""
SQL=""
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    run|schema|tables|connections|explain) CMD="$1"; shift;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) if [ -z "$URL" ]; then URL="$1"; else SQL="${SQL:+$SQL }$1"; fi; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
[ -z "$URL" ] && { echo "missing postgres:// URL" >&2; exit 2; }
: "${PSQL:?psql not found — install postgresql or set PSQL=path}"

run_psql() {
  if [ -n "$OUT" ]; then
    $PSQL "$URL" -c "$1" > "$OUT"
    echo "Saved to $OUT"
  else
    $PSQL "$URL" -c "$1"
  fi
}

case "$CMD" in
  run)
    [ -z "$SQL" ] && { echo "missing SQL statement" >&2; exit 2; }
    run_psql "$SQL"
    ;;
  schema)
    run_psql "\dt+ *.*"
    ;;
  tables)
    run_psql "\dt"
    ;;
  connections)
    run_psql "SELECT pid, usename, application_name, client_addr, state, query_start FROM pg_stat_activity ORDER BY query_start;"
    ;;
  explain)
    [ -z "$SQL" ] && { echo "missing SQL statement" >&2; exit 2; }
    run_psql "EXPLAIN (ANALYZE, BUFFERS) $SQL"
    ;;
esac