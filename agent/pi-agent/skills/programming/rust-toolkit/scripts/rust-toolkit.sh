#!/usr/bin/env bash
# Rust Toolkit — cargo build, test, clippy, fmt, doc
# Source: https://doc.rust-lang.org/cargo/
set -euo pipefail

SCRIPT_NAME="rust-toolkit.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} build [dir] [--release]
       ${SCRIPT_NAME} test [dir]
       ${SCRIPT_NAME} clippy [dir]
       ${SCRIPT_NAME} fmt [dir]
       ${SCRIPT_NAME} doc [dir]
       ${SCRIPT_NAME} check [dir]
       ${SCRIPT_NAME} version
Run common Rust/cargo workflows. Requires the cargo toolchain
(pkg install rust on Termux).

Options:
  --release  build in release mode
  -h | --help  show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
DIR="."
RELEASE=0
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    build|test|clippy|fmt|doc|check|version) CMD="$1"; shift;;
    --release) RELEASE=1; shift;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) DIR="$1"; shift;;
  esac
done
[ -z "$CMD" ] && { usage; exit 1; }

if ! command -v cargo >/dev/null 2>&1; then
  echo "cargo not found — install it (pkg install rust) or set CARGO=path" >&2
  exit 1
fi
CARGO="${CARGO:-cargo}"

case "$CMD" in
  version)
    $CARGO --version
    ;;
  build)
    cd "$DIR"
    if [ "$RELEASE" = "1" ]; then $CARGO build --release; else $CARGO build; fi
    echo "build OK"
    ;;
  test)
    cd "$DIR" && $CARGO test
    ;;
  clippy)
    if $CARGO clippy --version >/dev/null 2>&1; then
      cd "$DIR" && $CARGO clippy -- -D warnings
    else
      echo "clippy not installed — run: rustup component add clippy" >&2
      exit 1
    fi
    ;;
  fmt)
    if $CARGO fmt --version >/dev/null 2>&1; then
      cd "$DIR" && $CARGO fmt && echo "fmt OK"
    else
      echo "rustfmt not installed — run: rustup component add rustfmt" >&2
      exit 1
    fi
    ;;
  doc)
    cd "$DIR" && $CARGO doc --no-deps
    echo "docs at target/doc/index.html"
    ;;
  check)
    cd "$DIR" && $CARGO check
    echo "check OK"
    ;;
esac