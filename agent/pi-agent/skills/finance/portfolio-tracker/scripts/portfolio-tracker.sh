#!/usr/bin/env bash
# Portfolio Tracker — returns, risk metrics, asset allocation
# Source: https://www.investopedia.com/
set -euo pipefail

SCRIPT_NAME="portfolio-tracker.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} <holdings.json|holdings.csv> [--prices prices.json] [--out <file>]
       ${SCRIPT_NAME} returns <daily-returns.csv> [--riskfree 0.02] [--out <file>]
Compute allocation, dollar values, simple returns, volatility, Sharpe.

Input formats:
  holdings.json: [{"ticker": "AAPL", "shares": 10, "price": 150.0}]
  holdings.csv:  ticker,shares,price
  returns.csv:   date,return   (decimal daily returns, one per line)

Options:
  --prices FILE  override per-ticker prices: {"AAPL": 155.0}
  --riskfree R   risk-free rate for Sharpe (default 0.02)
  --out FILE     write JSON to FILE
  -h | --help    show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

INPUT=""
PRICES=""
RISKFREE=0.02
OUT=""
MODE="holdings"
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    returns) MODE="returns"; shift;;
    --prices) PRICES="$2"; shift 2;;
    --riskfree) RISKFREE="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) INPUT="$1"; shift;;
  esac
done

[ -f "$INPUT" ] || { echo "input file not found: $INPUT" >&2; exit 1; }

if [ "$MODE" = "returns" ]; then
  # CSV of daily returns: date,return
  python3 - "$INPUT" "$RISKFREE" <<'PYEOF' > "${TMPDIR:-/tmp}/pt_ret.json"
import csv, math, sys

path, rf = sys.argv[1], float(sys.argv[2])
rets = []
with open(path) as f:
    for row in csv.reader(f):
        if len(row) < 2 or row[0].lower() in ("date", "day", ""):
            continue
        try:
            rets.append(float(row[1]))
        except ValueError:
            pass
n = len(rets)
if n == 0:
    print('{"error": "no returns parsed"}'); sys.exit(0)
mean = sum(rets) / n
var = sum((r - mean) ** 2 for r in rets) / (n - 1) if n > 1 else 0.0
sd = math.sqrt(var)
sharpe = (mean * 252 - rf) / (sd * math.sqrt(252)) if sd > 0 else None
cum = 1.0
for r in rets:
    cum *= (1 + r)
print(__import__("json").dumps({
    "n_days": n, "mean_daily": mean, "std_daily": sd,
    "annualized_return": (1 + mean) ** 252 - 1,
    "annualized_vol": sd * math.sqrt(252),
    "sharpe": sharpe, "cumulative_return": cum - 1,
    "best_day": max(rets), "worst_day": min(rets),
}, indent=2))
PYEOF
  if [ -n "$OUT" ]; then mv "${TMPDIR:-/tmp}/pt_ret.json" "$OUT"; echo "Saved to $OUT";
  else cat "${TMPDIR:-/tmp}/pt_ret.json" | jq -r '"Daily returns (\(.n_days) days)\nAnnualized return: \((.annualized_return * 10000 | round) / 100)%\nAnnualized vol:    \((.annualized_vol * 10000 | round) / 100)%\nSharpe ratio:      \(.sharpe // "n/a")\nCumulative:        \((.cumulative_return * 10000 | round) / 100)%\nBest / worst day:  \((.best_day * 10000 | round) / 100)% / \((.worst_day * 10000 | round) / 100)%"'; fi
  exit 0
fi

# holdings mode
python3 - "$INPUT" "$PRICES" <<'PYEOF' > "${TMPDIR:-/tmp}/pt_hold.json"
import csv, json, sys

path, prices_path = sys.argv[1], sys.argv[2]
holdings = []
if path.endswith(".json"):
    with open(path) as f:
        holdings = json.load(f)
else:
    with open(path) as f:
        for row in csv.DictReader(f):
            holdings.append({"ticker": row["ticker"], "shares": float(row["shares"]), "price": float(row["price"])})

overrides = {}
if prices_path:
    with open(prices_path) as f:
        overrides = json.load(f)

total = 0.0
for h in holdings:
    h["price"] = float(overrides.get(h["ticker"], h.get("price", 0)))
    h["value"] = h["shares"] * h["price"]
    total += h["value"]

for h in holdings:
    h["weight"] = h["value"] / total if total else 0.0

print(json.dumps({"total_value": total, "holdings": holdings}, indent=2))
PYEOF
jq -n --slurpfile h "${TMPDIR:-/tmp}/pt_hold.json" '
  $h[0] as $p |
  {total_value: $p.total_value,
   n_positions: ($p.holdings | length),
   allocation: [$p.holdings[] | {ticker, value: ((.value * 100 | round) / 100), weight: ((.weight * 10000 | round) / 100)}],
   largest: ($p.holdings | max_by(.weight) | {ticker, weight: ((.weight * 10000 | round) / 100)})}
' > "${TMPDIR:-/tmp}/pt_summary.json"

if [ -n "$OUT" ]; then
  cat "${TMPDIR:-/tmp}/pt_hold.json" "${TMPDIR:-/tmp}/pt_summary.json" | jq -s '.[0] + .[1]' > "$OUT"
  echo "Saved to $OUT"
else
  jq -r '"Total value: \((.total_value * 100 | round) / 100)\nPositions: \(.n_positions)\n\nAllocation:" + ([.allocation[] | "\n  \(.ticker): \(.value) (\(.weight)%)"] | join("")) + "\n\nLargest: \(.largest.ticker) at \(.largest.weight)%"' "${TMPDIR:-/tmp}/pt_summary.json"
fi
rm -f "${TMPDIR:-/tmp}/pt_ret.json" "${TMPDIR:-/tmp}/pt_hold.json" "${TMPDIR:-/tmp}/pt_summary.json"
