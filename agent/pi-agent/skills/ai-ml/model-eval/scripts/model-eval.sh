#!/usr/bin/env bash
# Model Eval — benchmark model outputs, compute metrics, build leaderboards
# Sources: https://huggingface.co/docs/evaluate/ https://truthfulqa.github.io/
set -euo pipefail

SCRIPT_NAME="model-eval.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} <results.jsonl|results.json> [--label FIELD] [--pred FIELD] [--out <file>]
       ${SCRIPT_NAME} compare <a.jsonl> <b.jsonl> [--label FIELD] [--pred FIELD] [--out <file>]
Compute accuracy, precision, recall, F1, and confusion matrix.
Results format (JSONL or JSON array of objects):
  {"label": "spam", "prediction": "ham"}   — fields configurable via --label/--pred

Options:
  --label FIELD   label field name (default label)
  --pred FIELD    prediction field name (default prediction)
  --out FILE      write JSON metrics to FILE
  -h | --help     show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

MODE="single"
INPUT=""
INPUT2=""
LABEL="label"
PRED="prediction"
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    compare) MODE="compare"; shift;;
    --label) LABEL="$2"; shift 2;;
    --pred) PRED="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) if [ -z "$INPUT" ]; then INPUT="$1"; else INPUT2="$1"; fi; shift;;
  esac
done

[ -f "$INPUT" ] || { echo "input file not found: $INPUT" >&2; exit 1; }
[ "$MODE" = "compare" ] && { [ -f "$INPUT2" ] || { echo "second file not found: $INPUT2" >&2; exit 1; }; }

# Normalize JSONL/JSON to a JSON array
norm() {
  local f="$1"
  if head -1 "$f" | grep -q '^\['; then
    jq -c '.[]' "$f"
  else
    grep -v '^[[:space:]]*$' "$f"
  fi
}

if [ "$MODE" = "single" ]; then
  norm "$INPUT" > "${TMPDIR:-/tmp}/mev.jsonl"
else
  # merge predictions: assume same order
  python3 - "$INPUT" "$INPUT2" "$LABEL" "$PRED" <<'PYEOF' > "${TMPDIR:-/tmp}/mev.jsonl"
import json, sys

fa, fb, la, pb = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
def load(f):
    d = json.load(open(f))
    return d if isinstance(d, list) else [json.loads(l) for l in open(f) if l.strip()]
a, b = load(fa), load(fb)
for x, y in zip(a, b):
    print(json.dumps({"label": x.get(la), "prediction": y.get(pb)}))
PYEOF
fi

python3 - "${TMPDIR:-/tmp}/mev.jsonl" "$LABEL" "$PRED" <<'PYEOF' > "${TMPDIR:-/tmp}/mev_metrics.json"
import json, sys
from collections import defaultdict

rows = [json.loads(l) for l in open(sys.argv[1]) if l.strip()]
n = len(rows)
if n == 0:
    print(json.dumps({"error": "no rows"})); sys.exit(0)

labels = sorted({str(r.get("label")) for r in rows} | {str(r.get("prediction")) for r in rows})
tp, fp, fn = defaultdict(int), defaultdict(int), defaultdict(int)
conf = defaultdict(lambda: defaultdict(int))
correct = 0
for r in rows:
    y = str(r.get("label")); yh = str(r.get("prediction"))
    conf[y][yh] += 1
    if y == yh: correct += 1
    for c in labels:
        if y == c and yh == c: tp[c] += 1
        elif y != c and yh == c: fp[c] += 1
        elif y == c and yh != c: fn[c] += 1

per_class = {}
for c in labels:
    p = tp[c] / (tp[c] + fp[c]) if (tp[c] + fp[c]) else None
    r = tp[c] / (tp[c] + fn[c]) if (tp[c] + fn[c]) else None
    f1 = 2 * p * r / (p + r) if (p is not None and r is not None and p + r) else None
    per_class[c] = {"precision": p, "recall": r, "f1": f1, "support": tp[c] + fn[c]}

macro_p = sum(v["precision"] for v in per_class.values() if v["precision"] is not None) / len(labels)
macro_r = sum(v["recall"] for v in per_class.values() if v["recall"] is not None) / len(labels)
macro_f1 = 2 * macro_p * macro_r / (macro_p + macro_r) if (macro_p + macro_r) else None

print(json.dumps({
    "n_samples": n,
    "accuracy": correct / n,
    "macro_precision": macro_p,
    "macro_recall": macro_r,
    "macro_f1": macro_f1,
    "per_class": per_class,
    "confusion_matrix": {k: dict(v) for k, v in conf.items()},
    "labels": labels,
}, indent=2, default=float))
PYEOF

if [ -n "$OUT" ]; then
  mv "${TMPDIR:-/tmp}/mev_metrics.json" "$OUT"
  echo "Saved metrics to $OUT"
else
  jq -r '"n: \(.n_samples)\naccuracy:      \((.accuracy * 10000 | round) / 100)%\nmacro precision: \((.macro_precision * 10000 | round) / 100)%\nmacro recall:    \((.macro_recall * 10000 | round) / 100)%\nmacro F1:        \((.macro_f1 * 10000 | round) / 100)%\n\nper class:" + ([.per_class | to_entries[] | "  \(.key): P=\((.value.precision * 1000 | round) / 10)% R=\((.value.recall * 1000 | round) / 10)% F1=\((.value.f1 * 1000 | round) / 10)% (n=\(.value.support))"] | join("\n"))' "${TMPDIR:-/tmp}/mev_metrics.json"
fi
rm -f "${TMPDIR:-/tmp}/mev.jsonl" "${TMPDIR:-/tmp}/mev_a.json" "${TMPDIR:-/tmp}/mev_metrics.json"
