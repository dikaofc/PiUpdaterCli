#!/usr/bin/env bash
# Ethereum Dev — query the Ethereum blockchain via public JSON-RPC
# Source: https://ethereum.org/en/developers/docs/apis/json-rpc/
set -euo pipefail

SCRIPT_NAME="ethereum-dev.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} balance <address> [--rpc URL]
       ${SCRIPT_NAME} gas [--rpc URL]
       ${SCRIPT_NAME} block [--rpc URL] [--number N]
       ${SCRIPT_NAME} tx <hash> [--rpc URL]
Query the Ethereum blockchain through a public JSON-RPC endpoint.
Defaults to https://ethereum-rpc.publicnode.com (override with --rpc).

Options:
  --rpc URL   JSON-RPC endpoint (default publicnode)
  --number N  block number for block command (default: latest)
  -h | --help show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

RPC="https://ethereum.publicnode.com"
CMD=""
ARG=""
BLOCKNUM="latest"
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    balance|gas|block|tx) CMD="$1"; shift;;
    --rpc) RPC="$2"; shift 2;;
    --number) BLOCKNUM="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARG="$1"; shift;;
  esac
done
[ -z "$CMD" ] && { usage; exit 1; }

rpc() {
  # rpc <method> <params-json>
  curl -sS --max-time 25 -X POST "$RPC" \
    -H "Content-Type: application/json" \
    -d "{\"jsonrpc\":\"2.0\",\"method\":\"$1\",\"params\":${2:-[]},\"id\":1}" 2>/dev/null \
    || { echo "RPC request failed (endpoint: $RPC)" >&2; exit 1; }
}

hex_to_dec() {
  python3 -c "print(int('$1', 16))"
}

case "$CMD" in
  balance)
    [ -z "$ARG" ] && { echo "usage: ${SCRIPT_NAME} balance <address>" >&2; exit 2; }
    RESP=$(rpc "eth_getBalance" "[\"$ARG\",\"latest\"]")
    WEI=$(echo "$RESP" | jq -r '.result // empty')
    if [ -z "$WEI" ]; then
      echo "no result (invalid address or RPC error): $(echo "$RESP" | jq -r '.error.message // "unknown"')" >&2
      exit 1
    fi
    ETH=$(python3 -c "print(f'{$WEI:#x} wei' if False else round(int('$WEI',16)/1e18, 6))")
    echo "$ARG -> $ETH ETH ($(hex_to_dec "$WEI") wei)"
    ;;
  gas)
    RESP=$(rpc "eth_gasPrice" "[]")
    WEI=$(echo "$RESP" | jq -r '.result // empty')
    [ -z "$WEI" ] && { echo "no result: $(echo "$RESP" | jq -r '.error.message // "unknown"')" >&2; exit 1; }
    GWEI=$(python3 -c "print(round(int('$WEI',16)/1e9, 3))")
    echo "current gas price: ${GWEI} gwei ($(hex_to_dec "$WEI") wei)"
    ;;
  block)
    # JSON-RPC expects hex block numbers; convert decimal input
    if [ "$BLOCKNUM" != "latest" ] && ! [[ "$BLOCKNUM" == 0x* ]]; then
      BLOCKNUM=$(python3 -c "print(hex(int('$BLOCKNUM')))")
    fi
    RESP=$(rpc "eth_getBlockByNumber" "[\"$BLOCKNUM\",false]")
    if echo "$RESP" | jq -e '.result == null' >/dev/null 2>&1; then
      echo "block not found: $BLOCKNUM" >&2; exit 1
    fi
    echo "$RESP" | python3 -c "
import sys, json, datetime
d = json.load(sys.stdin)['result']
def h(x): return int(x, 16)
ts = h(d['timestamp'])
print(f\"block #{h(d['number'])}\")
print(f\"  hash:     {d['hash']}\")
print(f\"  ts:       {ts} ({datetime.datetime.fromtimestamp(ts, datetime.timezone.utc).strftime('%Y-%m-%d %H:%M:%S UTC')})\")
print(f\"  tx count: {len(d['transactions'])}\")
print(f\"  gas used: {h(d['gasUsed'])} / {h(d['gasLimit'])}\")
print(f\"  miner:    {d['miner']}\")
"
    ;;
  tx)
    [ -z "$ARG" ] && { echo "usage: ${SCRIPT_NAME} tx <hash>" >&2; exit 2; }
    RESP=$(rpc "eth_getTransactionByHash" "[\"$ARG\"]")
    if echo "$RESP" | jq -e '.result == null' >/dev/null 2>&1; then
      echo "transaction not found: $ARG" >&2; exit 1
    fi
    echo "$RESP" | python3 -c "
import sys, json
d = json.load(sys.stdin)['result']
def h(x): return int(x, 16)
print(f\"tx {d['hash']}\")
print(f\"  from:    {d['from']}\")
print(f\"  to:      {d.get('to') or '(contract creation)'}\")
print(f\"  value:   {h(d['value'])/1e18:.6f} ETH\")
print(f\"  gas:     {h(d['gas'])}\")
print(f\"  nonce:   {h(d['nonce'])}\")
"
    ;;
esac