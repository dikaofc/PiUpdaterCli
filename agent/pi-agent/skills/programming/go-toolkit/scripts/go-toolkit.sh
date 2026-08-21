#!/usr/bin/env bash
# Go Toolkit — build, test, vet, format, and manage Go modules
# Source: https://go.dev/doc/
set -euo pipefail

SCRIPT_NAME="go-toolkit.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} build [dir] [--out NAME]
       ${SCRIPT_NAME} test [dir] [--race]
       ${SCRIPT_NAME} vet [dir]
       ${SCRIPT_NAME} fmt [dir]
       ${SCRIPT_NAME} tidy [dir]
       ${SCRIPT_NAME} coverage [dir]
       ${SCRIPT_NAME} version
Run common Go development workflows. Requires the 'go' toolchain
(pkg install golang on Termux).

Options:
  --out NAME   binary output name for build
  --race       enable race detector for test
  -h | --help  show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
DIR="."
OUT=""
RACE=0
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    build|test|vet|fmt|tidy|coverage|version) CMD="$1"; shift;;
    --out) OUT="$2"; shift 2;;
    --race) RACE=1; shift;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) DIR="$1"; shift;;
  esac
done
[ -z "$CMD" ] && { usage; exit 1; }

if ! command -v go >/dev/null 2>&1; then
  echo "go not found — install it (pkg install golang) or set GO=path" >&2
  exit 1
fi
GO="${GO:-go}"

case "$CMD" in
  version)
    $GO version
    ;;
  build)
    cd "$DIR"
    if [ -n "$OUT" ]; then
      $GO build -o "$OUT" .
      echo "built $OUT"
    else
      $GO build .
      echo "build OK"
    fi
    ;;
  test)
    cd "$DIR"
    if [ "$RACE" = "1" ]; then
      $GO test -race ./...
    else
      $GO test ./...
    fi
    ;;
  vet)
    cd "$DIR" && $GO vet ./...
    echo "vet OK"
    ;;
  fmt)
    cd "$DIR"
    $GO fmt ./...
    echo "fmt OK"
    ;;
  tidy)
    cd "$DIR" && $GO mod tidy
    echo "tidy OK"
    ;;
  coverage)
    cd "$DIR"
    $GO test -coverprofile=coverage.out ./...
    $GO tool cover -func=coverage.out | tail -1
    ;;
esac