#!/usr/bin/env bash
# Test Suite — discover and run tests, summarize results
# Source: https://docs.pytest.org/ https://pkg.go.dev/testing
set -euo pipefail

SCRIPT_NAME="test-suite.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} run [dir]           # auto-detect & run tests
       ${SCRIPT_NAME} list [dir]          # list discovered test files
Auto-detect the test framework in a project and run it:
  pytest.ini/pyproject.toml -> pytest
  go.mod                     -> go test ./...
  package.json               -> npm test
  Cargo.toml                 -> cargo test
  Makefile                   -> make test

Options:
  -h | --help  show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
DIR="."
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    run|list) CMD="$1"; shift;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) DIR="$1"; shift;;
  esac
done
[ -z "$CMD" ] && { usage; exit 1; }
[ -d "$DIR" ] || { echo "dir not found: $DIR" >&2; exit 1; }

detect() {
  if [ -f "$DIR/pytest.ini" ] || [ -f "$DIR/pyproject.toml" ] || [ -f "$DIR/tox.ini" ]; then
    echo "pytest"
  elif [ -f "$DIR/go.mod" ]; then
    echo "go"
  elif [ -f "$DIR/package.json" ]; then
    echo "npm"
  elif [ -f "$DIR/Cargo.toml" ]; then
    echo "cargo"
  elif [ -f "$DIR/Makefile" ]; then
    echo "make"
  else
    echo "none"
  fi
}

case "$CMD" in
  list)
    echo "test files under $DIR:"
    find "$DIR" \( -name 'test_*.py' -o -name '*_test.py' -o -name '*_test.go' \
      -o -name '*.test.ts' -o -name '*.test.js' -o -name '*_test.rs' -o -name '*Test.java' \) \
      -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/target/*' \
      -not -path '*/__pycache__/*' 2>/dev/null | head -40
    ;;
  run)
    FRAMEWORK=$(detect)
    echo "detected framework: $FRAMEWORK"
    case "$FRAMEWORK" in
      pytest)
        if command -v pytest >/dev/null 2>&1; then
          (cd "$DIR" && pytest -q 2>&1 | tail -12)
        elif python3 -m pytest --version >/dev/null 2>&1; then
          (cd "$DIR" && python3 -m pytest -q 2>&1 | tail -12)
        else
          echo "pytest not installed (pip install pytest) — falling back to unittest" >&2
          (cd "$DIR" && python3 -m unittest discover -v 2>&1 | tail -8)
        fi
        ;;
      go)
        (cd "$DIR" && go test ./... 2>&1 | tail -20)
        ;;
      npm)
        (cd "$DIR" && npm test --silent 2>&1 | tail -15)
        ;;
      cargo)
        (cd "$DIR" && cargo test 2>&1 | tail -15)
        ;;
      make)
        (cd "$DIR" && make test 2>&1 | tail -15)
        ;;
      none)
        PY_TESTS=$(find "$DIR" -maxdepth 2 -name 'test_*.py' -o -name '*_test.py' 2>/dev/null | grep -v __pycache__ | head -1)
        if [ -n "$PY_TESTS" ]; then
          echo "no framework config, but test_*.py found — using unittest discover"
          RESULT=$(cd "$DIR" && python3 -m unittest discover -v 2>&1 | tail -8)
          echo "$RESULT"
          if echo "$RESULT" | grep -q 'Ran 0 tests'; then
            echo "note: 0 tests ran — plain test functions need pytest (pip install pytest)" >&2
          fi
        else
          echo "no recognized test framework in $DIR" >&2
          echo "hint: create pytest.ini/go.mod/package.json/Cargo.toml or pass a subdir" >&2
          exit 1
        fi
        ;;
    esac
    ;;
esac