#!/usr/bin/env bash
# TypeScript Toolkit — type-check, build, test, and inspect TS projects
# Source: https://www.typescriptlang.org/
set -euo pipefail

SCRIPT_NAME="typescript-toolkit.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} check <file|dir>        # tsc --noEmit
       ${SCRIPT_NAME} build [dir]
       ${SCRIPT_NAME} test [dir]              # npm test
       ${SCRIPT_NAME} deps [dir]              # npm ls --depth=0
       ${SCRIPT_NAME} syntax <file>           # node --check (fast, no tsc needed)
Run common TypeScript workflows. Requires node; tsc is resolved via
npx/typescript if installed locally or globally.

Options:
  -h | --help  show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARG="."
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    check|build|test|deps|syntax) CMD="$1"; shift;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARG="$1"; shift;;
  esac
done
[ -z "$CMD" ] && { usage; exit 1; }

command -v node >/dev/null 2>&1 || { echo "node not found" >&2; exit 1; }

find_tsc() {
  if [ -x "node_modules/.bin/tsc" ]; then echo "node_modules/.bin/tsc"; return; fi
  if command -v tsc >/dev/null 2>&1; then echo "tsc"; return; fi
  echo ""
}

case "$CMD" in
  syntax)
    case "$ARG" in
      *.ts)
        if node --check "$ARG" 2>/dev/null; then
          echo "syntax OK: $ARG"
        elif TSC_FALLBACK=$(find_tsc) && [ -n "$TSC_FALLBACK" ]; then
          "$TSC_FALLBACK" --noEmit "$ARG" && echo "syntax OK (via tsc): $ARG"
        else
          echo "node --check cannot parse TypeScript annotations; install typescript for tsc or use 'check'" >&2
          exit 1
        fi
        ;;
      *)
        node --check "$ARG"
        echo "syntax OK: $ARG"
        ;;
    esac
    ;;
  check)
    TSC=$(find_tsc)
    if [ -z "$TSC" ]; then
      echo "tsc not found — install: npm i -D typescript (or npm i -g typescript)" >&2
      exit 1
    fi
    if [ -d "$ARG" ]; then
      (cd "$ARG" && "$TSC" --noEmit)
    else
      "$TSC" --noEmit "$ARG"
    fi
    echo "type-check OK"
    ;;
  build)
    TSC=$(find_tsc)
    if [ -z "$TSC" ]; then
      echo "tsc not found — install: npm i -D typescript" >&2
      exit 1
    fi
    (cd "$ARG" && "$TSC")
    echo "build OK"
    ;;
  test)
    if [ -f "$ARG/package.json" ] || [ -f package.json ]; then
      (cd "$ARG" && npm test --silent 2>&1 | tail -15)
    else
      echo "no package.json found (npm test needs a project)" >&2
      exit 1
    fi
    ;;
  deps)
    (cd "$ARG" && npm ls --depth=0 2>&1 | head -30)
    ;;
esac