#!/usr/bin/env bash
# Terraform Toolbox — fmt, validate, plan parsing, state inspection, drift detection
# Source: https://developer.hashicorp.com/terraform/cli
set -euo pipefail

SCRIPT_NAME="terraform-toolbox.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} fmt [<dir>]
       ${SCRIPT_NAME} validate [<dir>]
       ${SCRIPT_NAME} plan [<dir>] [--out <file>]
       ${SCRIPT_NAME} state [<dir>]
       ${SCRIPT_NAME} drift [<dir>]
Format, validate, plan, inspect state, and detect drift.
Requires the terraform CLI.

Options:
  --out FILE   write plan to FILE
  -h | --help  show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
DIR="."
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    fmt|validate|plan|state|drift) CMD="$1"; shift;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) DIR="$1"; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
: "${TF:?terraform not found — install terraform or set TF=path}"

case "$CMD" in
  fmt)
    $TF -chdir="$DIR" fmt -recursive
    ;;
  validate)
    $TF -chdir="$DIR" init -backend=false -input=false >/dev/null 2>&1 || true
    $TF -chdir="$DIR" validate
    ;;
  plan)
    ARGS=(-chdir="$DIR" plan -input=false)
    [ -f "$DIR/.terraform" ] || { echo "plan: .terraform missing, skipping plan (run init first)" >&2; exit 1; }
    if [ -n "$OUT" ]; then
      $TF "${ARGS[@]}" -out="$OUT" >/dev/null && echo "plan saved to $OUT"
    else
      $TF "${ARGS[@]}"
    fi
    ;;
  state)
    [ -f "$DIR/terraform.tfstate" ] || { echo "no terraform.tfstate in $DIR" >&2; exit 1; }
    $TF -chdir="$DIR" state list 2>/dev/null || echo "no state resources"
    echo ""
    echo "resources by type:"
    $TF -chdir="$DIR" state list 2>/dev/null | awk -F'[.[]' '{print $1}' | sort | uniq -c | sort -rn
    ;;
  drift)
    [ -f "$DIR/terraform.tfstate" ] || { echo "no state; cannot check drift" >&2; exit 1; }
    $TF -chdir="$DIR" plan -detailed-exitcode -input=false > "${TMPDIR:-/tmp}/tf_drift.txt" 2>&1
    RC=$?
    cat "${TMPDIR:-/tmp}/tf_drift.txt"
    echo ""
    case $RC in
      0) echo "no drift detected";;
      2) echo "DRIFT DETECTED: plan would make changes";;
      *) echo "plan failed (exit $RC) — see output above";;
    esac
    ;;
esac