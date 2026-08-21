#!/usr/bin/env bash
# CI/CD Toolbox — render templates, validate pipelines (GitHub Actions, GitLab)
# Source: https://docs.github.com/actions/using-workflows
set -euo pipefail

SCRIPT_NAME="ci-cd-toolbox.sh"

usage() {
  cat <<'EOF'
Usage: ${SCRIPT_NAME} render <template> [--vars k=v ...] [--out <file>]
       ${SCRIPT_NAME} validate <pipeline-file> [github|gitlab]
       ${SCRIPT_NAME} lint <pipeline-file>          # quick structural checks
Render ${VAR} templates, validate YAML pipelines, lint structure.

Options:
  --vars k=v    set template variables (repeatable)
  --out FILE    write rendered output to FILE
  -h | --help   show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
INPUT=""
VARS=()
OUT=""
TYPE=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    render|validate|lint) CMD="$1"; shift;;
    --vars) VARS+=("$2"); shift 2;;
    --out) OUT="$2"; shift 2;;
    github|gitlab) TYPE="$1"; shift;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) INPUT="$1"; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
[ -f "$INPUT" ] || { echo "file not found: $INPUT" >&2; exit 1; }

emit() {
  if [ -n "$OUT" ]; then
    echo "$1" > "$OUT"
    echo "Saved to $OUT"
  else
    echo "$1"
  fi
}

render_vars() {
  # ${VAR} and $VAR substitution from --vars k=v pairs
  local body
  body=$(cat "$INPUT")
  for kv in "${VARS[@]}"; do
    K="${kv%%=*}"; V="${kv#*=}"
    body=$(printf '%s' "$body" | env "K=$K" "V=$V" python3 -c "
import os, sys
t = sys.stdin.read()
k, v = os.environ['K'], os.environ['V']
t = t.replace('\${' + k + '}', v).replace('\$' + k, v)
sys.stdout.write(t)")
  done
  printf '%s\n' "$body"
}

case "$CMD" in
  render)
    MISSING=$(grep -oE '\$\{[A-Za-z_][A-Za-z0-9_]*\}|\$[A-Za-z_][A-Za-z0-9_]*' "$INPUT" | tr -d '${}' | sort -u | tr '\n' ' ')
    if [ -n "$MISSING" ]; then
      echo "Warning: template variables: $MISSING" >&2
    fi
    emit "$(render_vars)"
    ;;
  validate)
    if command -v python3 >/dev/null && python3 -c "import yaml" 2>/dev/null; then
      if python3 -c "
import sys, yaml
try:
    d = yaml.safe_load(open(sys.argv[1]))
    if d is None: print('empty document')
except yaml.YAMLError as e:
    print(f'YAML error: {e}'); sys.exit(1)
" "$INPUT"; then
        echo "OK: valid YAML"
      else
        exit 1
      fi
    else
      echo "pyyaml not available — skipping YAML parse; running structural lint" >&2
      "$0" lint "$INPUT"
      exit 0
    fi
    ;;
  lint)
    ISSUES=0
    # GitHub Actions: needs 'on' and 'jobs'
    if grep -q '^on:' "$INPUT" || grep -qE '^"?on"?$' "$INPUT"; then
      grep -q '^jobs:' "$INPUT" && echo "  OK: has 'on' + 'jobs'" || { echo "  missing 'jobs:' section"; ISSUES=$((ISSUES+1)); }
    # GitLab: needs stages + at least one job
    elif grep -q '^stages:' "$INPUT"; then
      JOBS=$(grep -cE '^  [a-zA-Z0-9_]+:' "$INPUT")
      [ "$JOBS" -ge 1 ] && echo "  OK: has 'stages' + $JOBS job(s)" || { echo "  no jobs found"; ISSUES=$((ISSUES+1)); }
    else
      echo "  unrecognized pipeline format (no 'on:'/'stages:' marker)" >&2; ISSUES=$((ISSUES+1))
    fi
    grep -nE '^\t' "$INPUT" | head -2 | while read -r _; do echo "  tabs instead of spaces"; ISSUES=$((ISSUES+1)); done
    echo "  $ISSUES structural issue(s)"
    ;;
esac