#!/usr/bin/env bash
# Market Data — fetch stock/crypto/FX prices via public APIs (no key needed)
# Sources: https://www.coingecko.com/en/api https://query1.finance.yahoo.com https://api.frankfurter.app
set -euo pipefail

SCRIPT_NAME="market-data.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} price <symbol> [currency]      # crypto: bitcoin, ethereum, ... (currency default usd)
       ${SCRIPT_NAME} stock <ticker> [--range 5d]    # stocks via Yahoo Finance (e.g. AAPL, MSFT)
       ${SCRIPT_NAME} fx <FROM> <TO> [amount]        # FX rates via Frankfurter (EUR, USD, ...)
       ${SCRIPT_NAME} price --out <file> ...
All use free public APIs without keys.

Options:
  --range R      Yahoo range: 1d, 5d, 1mo, 3mo, 1y (default 5d)
  --out FILE     write JSON to FILE
  -h | --help    show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARGS=""
RANGE="5d"
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    price|stock|fx) CMD="$1"; shift;;
    --range) RANGE="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARGS="${ARGS:+$ARGS }$1"; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }

emit() {
  if [ -n "$OUT" ]; then
    echo "$1" > "$OUT"
    echo "Saved to $OUT"
  else
    echo "$1" | jq -r "$2"
  fi
}

case "$CMD" in
  price)
    SYM=$(echo "$ARGS" | awk '{print $1}')
    CUR=$(echo "$ARGS" | awk '{print $2}'); CUR=${CUR:-usd}
    [ -z "$SYM" ] && { echo "usage: market-data.sh price <symbol> [currency]" >&2; exit 2; }
    RESP=$(curl -sS --max-time 30 "https://api.coingecko.com/api/v3/simple/price?ids=${SYM}&vs_currencies=${CUR}")
    if echo "$RESP" | jq -e 'has("'$SYM'")' >/dev/null 2>&1; then
      emit "$RESP" '."'$SYM'"."'$CUR'" | ((. // 0) * 100 | round | . / 100) | "\(.) '${CUR^^}'"'
    else
      echo "No data for crypto symbol '$SYM' (check https://api.coingecko.com/api/v3/coins/list)" >&2
      exit 1
    fi
    ;;
  stock)
    TICK=$(echo "$ARGS" | awk '{print $1}')
    [ -z "$TICK" ] && { echo "usage: market-data.sh stock <ticker> [--range R]" >&2; exit 2; }
    RESP=$(curl -sS --max-time 30 -H "User-Agent: Mozilla/5.0" \
      "https://query1.finance.yahoo.com/v8/finance/chart/${TICK}?interval=1d&range=${RANGE}")
    if echo "$RESP" | jq -e '.chart.error' >/dev/null 2>&1; then
      echo "Yahoo Finance error for $TICK: $(echo "$RESP" | jq -r '.chart.error.description')" >&2
      exit 1
    fi
    emit "$RESP" '
      .chart.result[0] as $r |
      ($r.meta.regularMarketPrice) as $p |
      "\($r.meta.symbol) — \($p) \($r.meta.currency // "USD") (\($r.meta.exchangeName // ""))
       prev close: \($r.chart.previousClose // "n/a")   \($r.meta.regularMarketTime | todate)"'
    ;;
  fx)
    FROM=$(echo "$ARGS" | awk '{print $1}')
    TO=$(echo "$ARGS" | awk '{print $2}')
    AMT=$(echo "$ARGS" | awk '{print $3}'); AMT=${AMT:-1}
    [ -z "$FROM" ] || [ -z "$TO" ] && { echo "usage: market-data.sh fx <FROM> <TO> [amount]" >&2; exit 2; }
    RESP=$(curl -sSL --max-time 30 "https://api.frankfurter.app/latest?from=${FROM}&to=${TO}")
    if echo "$RESP" | jq -e '.rates' >/dev/null 2>&1; then
      RES=$(python3 -c "
import json, sys
r = json.loads(sys.argv[1])
rate = r['rates']['$TO']
print(f'$AMT ${FROM^^} = {float($AMT) * rate:.4f} ${TO^^}')
" "$RESP")
      if [ -n "$OUT" ]; then echo "$RESP" > "$OUT"; echo "Saved to $OUT"; else echo "$RES"; fi
    else
      echo "FX error: $(echo "$RESP" | jq -r '.message // "unknown code"')" >&2
      exit 1
    fi
    ;;
esac
