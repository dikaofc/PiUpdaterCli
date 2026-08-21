#!/usr/bin/env bash
# Python Toolkit — venv, deps, lint, test, build for Python projects
# Source: https://docs.python.org/3/library/venv.html
set -euo pipefail

SCRIPT_NAME="python-toolkit.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} venv [dir]                      # create virtualenv (.venv)
       ${SCRIPT_NAME} deps [--install FILE] [--freeze]
       ${SCRIPT_NAME} check <file|dir>                # syntax check (py_compile)
       ${SCRIPT_NAME} lint <file|dir>                 # pyflakes/pylint if present
       ${SCRIPT_NAME} test [dir]                      # pytest or unittest discover
       ${SCRIPT_NAME} build [dir]                     # build sdist+wheel
Manage Python environments and run dev workflows.

Options:
  --install FILE  install requirements from FILE
  --freeze        print installed packages (pip freeze)
  -h | --help     show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARG="."
INSTALL=""
FREEZE=0
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    venv|deps|check|lint|test|build) CMD="$1"; shift;;
    --install) INSTALL="$2"; shift 2;;
    --freeze) FREEZE=1; shift;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARG="$1"; shift;;
  esac
done
[ -z "$CMD" ] && { usage; exit 1; }

PY="${PYTHON:-python3}"
command -v "$PY" >/dev/null 2>&1 || { echo "python3 not found" >&2; exit 1; }

case "$CMD" in
  venv)
    VENV_DIR="${ARG:-.venv}"
    [ -d "$VENV_DIR" ] || "$PY" -m venv "$VENV_DIR"
    echo "venv ready: $VENV_DIR (activate: source $VENV_DIR/bin/activate)"
    ;;
  deps)
    if [ -n "$INSTALL" ]; then
      "$PY" -m pip install -r "$INSTALL" 2>&1 | tail -3
      echo "installed from $INSTALL"
    elif [ "$FREEZE" = "1" ]; then
      "$PY" -m pip freeze
    else
      "$PY" -m pip list
    fi
    ;;
  check)
    if [ -d "$ARG" ]; then
      find "$ARG" -name '*.py' -print0 | xargs -0 -n1 "$PY" -m py_compile
      echo "syntax OK ($(find "$ARG" -name '*.py' | wc -l) files)"
    else
      "$PY" -m py_compile "$ARG"
      echo "syntax OK: $ARG"
    fi
    ;;
  lint)
    if command -v pyflakes >/dev/null 2>&1; then
      pyflakes "$ARG"
    elif command -v pylint >/dev/null 2>&1; then
      pylint "$ARG"
    else
      echo "no linter (pyflakes/pylint) — install: pip install pyflakes" >&2
      "$PY" -m py_compile "$ARG" 2>/dev/null && echo "syntax OK (lint fallback)"
    fi
    ;;
  test)
    if command -v pytest >/dev/null 2>&1; then
      pytest "$ARG" -q
    else
      cd "$ARG" 2>/dev/null || true
      "$PY" -m unittest discover -v 2>&1 | tail -5
    fi
    ;;
  build)
    if "$PY" -c "import build" 2>/dev/null; then
      cd "$ARG" && "$PY" -m build 2>&1 | tail -3
      echo "built: $(ls dist/ 2>/dev/null | tr '\n' ' ')"
    else
      echo "'build' package not installed (pip install build)" >&2
      exit 1
    fi
    ;;
esac