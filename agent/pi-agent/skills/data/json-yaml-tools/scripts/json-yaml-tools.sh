#!/usr/bin/env bash
# JSON/YAML Tools — validate, query (jq), diff, merge JSON and YAML
# Sources: https://jqlang.github.io/jq/manual/ https://yaml.org/spec/
set -euo pipefail

SCRIPT_NAME="json-yaml-tools.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} validate <file>
       ${SCRIPT_NAME} query <file> <jq-expr> [--out <file>]
       ${SCRIPT_NAME} diff <a> <b>
       ${SCRIPT_NAME} merge <a> <b> [--out <file>]
       ${SCRIPT_NAME} yaml2json <file.yaml> [--out <file>]
Validate, query, diff, and merge JSON/YAML. YAML support needs python3 + pyyaml.

Options:
  --out FILE     write result to FILE
  -h | --help    show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
FILES=()
EXPR=""
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    validate|query|diff|merge|yaml2json) CMD="$1"; shift;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) FILES+=("$1"); shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }

is_yaml() { grep -qE '^[a-zA-Z0-9_-]+:|^---' "$1" 2>/dev/null; }

yaml_to_json() {
  python3 -c "
import json, sys
try:
    import yaml
except ImportError:
    print('pyyaml not installed: pip install pyyaml', file=sys.stderr)
    sys.exit(3)
print(json.dumps(yaml.safe_load(open(sys.argv[1])), indent=2))
" "$1"
}

emit() {
  if [ -n "$OUT" ]; then
    echo "$1" > "$OUT"
    echo "Saved to $OUT"
  else
    echo "$1"
  fi
}

case "$CMD" in
  validate)
    for f in "${FILES[@]}"; do
      [ -f "$f" ] || { echo "not found: $f" >&2; exit 1; }
      if is_yaml "$f"; then
        if yaml_to_json "$f" >/dev/null 2>&1; then echo "OK (yaml): $f"; else echo "INVALID (yaml): $f"; exit 1; fi
      else
        if jq -e . "$f" >/dev/null 2>&1; then echo "OK (json): $f"; else echo "INVALID (json): $f"; exit 1; fi
      fi
    done
    ;;
  query)
    [ ${#FILES[@]} -lt 2 ] && { echo "usage: json-yaml-tools.sh query <file> <jq-expr>" >&2; exit 2; }
    f="${FILES[0]}"; EXPR="${FILES[1]}"
    [ -f "$f" ] || { echo "not found: $f" >&2; exit 1; }
    if is_yaml "$f"; then
      emit "$(yaml_to_json "$f" | jq "$EXPR")"
    else
      emit "$(jq "$EXPR" "$f")"
    fi
    ;;
  diff)
    [ ${#FILES[@]} -lt 2 ] && { echo "usage: json-yaml-tools.sh diff <a> <b>" >&2; exit 2; }
    a="${FILES[0]}"; b="${FILES[1]}"
    if is_yaml "$a"; then A=$(yaml_to_json "$a"); else A=$(cat "$a"); fi
    if is_yaml "$b"; then B=$(yaml_to_json "$b"); else B=$(cat "$b"); fi
    diff <(echo "$A" | jq -S .) <(echo "$B" | jq -S .) && echo "files are identical" || true
    ;;
  merge)
    [ ${#FILES[@]} -lt 2 ] && { echo "usage: json-yaml-tools.sh merge <a> <b>" >&2; exit 2; }
    a="${FILES[0]}"; b="${FILES[1]}"
    if is_yaml "$a"; then A=$(yaml_to_json "$a"); else A=$(cat "$a"); fi
    if is_yaml "$b"; then B=$(yaml_to_json "$b"); else B=$(cat "$b"); fi
    MERGED=$(jq -n --slurpfile a <(echo "$A") --slurpfile b <(echo "$B") '$a[0] * $b[0]')
    emit "$MERGED"
    ;;
  yaml2json)
    [ ${#FILES[@]} -lt 1 ] && { echo "usage: json-yaml-tools.sh yaml2json <file.yaml>" >&2; exit 2; }
    emit "$(yaml_to_json "${FILES[0]}")"
    ;;
esac
