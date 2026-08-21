#!/usr/bin/env bash
# MySQL Toolkit — inspect schema, optimize queries, manage users and replication
# Source: https://dev.mysql.com/doc/refman/8.0/en/
set -euo pipefail

SCRIPT_NAME="mysql-toolkit.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} <sql> [--host H] [--user U] [--password P] [--db D]
       ${SCRIPT_NAME} schema [--host H] [--user U] [--password P] [--db D]
       ${SCRIPT_NAME} slow [--host H] [--user U] [--password P]
       ${SCRIPT_NAME} status [--host H] [--user U] [--password P]
Run SQL, dump schema, check slow queries, and server status.
Requires the mysql client.

Options:
  --host H       host (default 127.0.0.1)
  --user U       user (default root)
  --password P   password
  --db D         database
  -h | --help    show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
SQL=""
HOST="127.0.0.1"
USER="root"
PASS=""
DB=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    schema|slow|status) CMD="$1"; shift;;
    --host) HOST="$2"; shift 2;;
    --user) USER="$2"; shift 2;;
    --password) PASS="$2"; shift 2;;
    --db) DB="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) if [ -z "$CMD" ]; then CMD="run"; fi; SQL="${SQL:+$SQL }$1"; shift;;
  esac
done

: "${MYSQL_BIN:?mysql client not found — install mysql (mariadb) or set MYSQL_BIN=path}"

OPTS=(-h "$HOST" -u "$USER")
[ -n "$PASS" ] && OPTS+=("-p$PASS")
[ -n "$DB" ] && OPTS+=("$DB")

case "$CMD" in
  run)
    [ -z "$SQL" ] && { echo "missing SQL statement" >&2; exit 2; }
    $MYSQL_BIN "${OPTS[@]}" -e "$SQL" -t
    ;;
  schema)
    $MYSQL_BIN "${OPTS[@]}" -e "SHOW TABLES;"
    for t in $($MYSQL_BIN "${OPTS[@]}" -N -e "SHOW TABLES;"); do
      echo ""
      echo "=== $t ==="
      $MYSQL_BIN "${OPTS[@]}" -e "SHOW CREATE TABLE \`$t\`;" 
    done
    ;;
  slow)
    $MYSQL_BIN "${OPTS[@]}" -e "SHOW VARIABLES LIKE 'slow_query_log';"
    $MYSQL_BIN "${OPTS[@]}" -e "SELECT * FROM mysql.slow_log ORDER BY start_time DESC LIMIT 20;" 2>/dev/null ||
      echo "slow log not enabled or not accessible"
    ;;
  status)
    $MYSQL_BIN "${OPTS[@]}" -e "SHOW GLOBAL STATUS WHERE Variable_name IN ('Uptime','Threads_connected','Max_used_connections','Questions','Slow_queries','Aborted_connects');"
    ;;
esac