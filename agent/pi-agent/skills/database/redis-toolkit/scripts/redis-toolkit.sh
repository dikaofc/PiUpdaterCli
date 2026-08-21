#!/usr/bin/env bash
# Redis Toolkit — inspect keys, analyze memory, TTL, Lua scripts, pub/sub
# Source: https://redis.io/commands/
set -euo pipefail

SCRIPT_NAME="redis-toolkit.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} keys [--pattern P] [--host H] [--port P]
       ${SCRIPT_NAME} memory [--host H] [--port P]
       ${SCRIPT_NAME} ttl <key> [--host H] [--port P]
       ${SCRIPT_NAME} types [--host H] [--port P]
       ${SCRIPT_NAME} info [section] [--host H] [--port P]
       ${SCRIPT_NAME} lua <script.lua> <key...>
Inspect keys, memory, TTLs, types; run Lua scripts. Requires redis-cli.

Options:
  --pattern P   key glob pattern (default *)
  --host H      host (default 127.0.0.1)
  --port P      port (default 6379)
  -h | --help   show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARGS=""
PATTERN="*"
HOST="127.0.0.1"
PORT="6379"
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    keys|memory|ttl|types|info|lua) CMD="$1"; shift;;
    --pattern) PATTERN="$2"; shift 2;;
    --host) HOST="$2"; shift 2;;
    --port) PORT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARGS="${ARGS:+$ARGS }$1"; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
: "${REDIS_CLI:?redis-cli not found — install redis or set REDIS_CLI=path}"
RC=($REDIS_CLI -h "$HOST" -p "$PORT" --raw)

case "$CMD" in
  keys)
    "${RC[@]}" --scan --pattern "$PATTERN" | head -200 | while read -r k; do
      T=$("${RC[@]}" type "$k" 2>/dev/null)
      S=$("${RC[@]}" strlen "$k" 2>/dev/null || echo "?")
      printf "%-50s %-10s %s bytes\n" "$k" "$T" "$S"
    done
    ;;
  memory)
    "${RC[@]}" info memory | grep -E 'used_memory_human|maxmemory_human|mem_fragmentation_ratio|used_memory_peak_human'
    echo ""
    echo "top keys by memory (sample of 200 scanned keys):"
    "${RC[@]}" --scan --pattern "$PATTERN" | head -200 | while read -r k; do
      M=$("${RC[@]}" memory usage "$k" 2>/dev/null || echo 0)
      printf "%10s %s\n" "$M" "$k"
    done | sort -rn | head -10
    ;;
  ttl)
    KEY=$(echo "$ARGS" | awk '{print $1}')
    [ -z "$KEY" ] && { echo "usage: redis-toolkit.sh ttl <key>" >&2; exit 2; }
    T=$("${RC[@]}" ttl "$KEY")
    PT=$("${RC[@]}" pttl "$KEY")
    echo "key: $KEY"
    echo "ttl (seconds): $T   pttl (ms): $PT"
    echo "expires at: $(date -d "@$(( $(date +%s) + T ))" 2>/dev/null || echo "never/n/a")"
    ;;
  types)
    echo "key type histogram (sample of 200 scanned keys):"
    "${RC[@]}" --scan --pattern "$PATTERN" | head -200 | while read -r k; do
      "${RC[@]}" type "$k" 2>/dev/null
    done | sort | uniq -c | sort -rn
    ;;
  info)
    SECTION=$(echo "$ARGS" | awk '{print $1}')
    if [ -n "$SECTION" ]; then "${RC[@]}" info "$SECTION"; else "${RC[@]}" info; fi
    ;;
  lua)
    SCRIPT_FILE=$(echo "$ARGS" | awk '{print $1}')
    KEYS=$(echo "$ARGS" | sed 's/^[^ ]* *//')
    [ -f "$SCRIPT_FILE" ] || { echo "script file not found: $SCRIPT_FILE" >&2; exit 1; }
    "${RC[@]}" --eval "$SCRIPT_FILE" $KEYS
    ;;
esac