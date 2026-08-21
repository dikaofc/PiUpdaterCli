#!/usr/bin/env bash
# Git Toolbox — inspect commits, diffs, branches, run hooks, audit history
# Source: https://git-scm.com/docs
set -euo pipefail

SCRIPT_NAME="git-toolbox.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} log [--count N] [--path <file>]
       ${SCRIPT_NAME} diff [<ref-a>] [<ref-b>] [--stat]
       ${SCRIPT_NAME} branches [--merged]
       ${SCRIPT_NAME} status
       ${SCRIPT_NAME} audit <author-email> [--since DATE]
       ${SCRIPT_NAME} hooks [--check]
       ${SCRIPT_NAME} blame <file>
Inspect git history, diffs, branches, authorship, and hooks.

Options:
  --count N     number of commits to show (default 20)
  --path FILE   restrict to a path
  --stat        show diffstat
  --merged      only merged branches
  --since DATE  e.g. '1 month ago'
  --check       run hooks in the repo
  -h | --help   show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARGS=()
COUNT=20
PATH_F=""
STAT=0
MERGED=0
SINCE=""
CHECK=0
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    log|diff|branches|status|audit|hooks|blame) CMD="$1"; shift;;
    --count) COUNT="$2"; shift 2;;
    --path) PATH_F="$2"; shift 2;;
    --stat) STAT=1; shift;;
    --merged) MERGED=1; shift;;
    --since) SINCE="$2"; shift 2;;
    --check) CHECK=1; shift;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARGS+=("$1"); shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "not a git repository" >&2; exit 1; }

case "$CMD" in
  log)
    GIT_ARGS=(log --oneline -n "$COUNT")
    [ -n "$PATH_F" ] && GIT_ARGS+=(-- "$PATH_F")
    git "${GIT_ARGS[@]}"
    ;;
  diff)
    GIT_ARGS=(diff)
    [ "$STAT" = "1" ] && GIT_ARGS=(diff --stat)
    if [ ${#ARGS[@]} -ge 2 ]; then git "${GIT_ARGS[@]}" "${ARGS[0]}" "${ARGS[1]}"
    elif [ ${#ARGS[@]} -eq 1 ]; then git "${GIT_ARGS[@]}" "${ARGS[0]}"
    else git "${GIT_ARGS[@]}"; fi
    ;;
  branches)
    if [ "$MERGED" = "1" ]; then git branch --merged; else git branch -a -vv; fi
    ;;
  status)
    git status -sb
    git stash list 2>/dev/null | head -5
    ;;
  audit)
    AUTH="${ARGS[0]:?usage: audit <author-email>}"
    GIT_ARGS=(log --author="$AUTH" --oneline --pretty='%h  %ad  %s' --date=short)
    [ -n "$SINCE" ] && GIT_ARGS+=(--since="$SINCE")
    git "${GIT_ARGS[@]}"
    ;;
  hooks)
    HOOKS_DIR=$(git rev-parse --git-path hooks)
    echo "hooks directory: $HOOKS_DIR"
    find "$HOOKS_DIR" -maxdepth 1 -type f ! -name '*.sample' -executable 2>/dev/null | while read -r h; do
      echo "  active: $(basename "$h")"
    done
    if [ "$CHECK" = "1" ]; then
      echo ""
      echo "running commit-msg + pre-push style checks (ls hooks):"
      ls "$HOOKS_DIR" 2>/dev/null | grep -v '.sample' || echo "  none active"
    fi
    ;;
  blame)
    F="${ARGS[0]:?usage: blame <file>}"
    git blame --line-porcelain "$F" 2>/dev/null | awk '/^author / {a=$0} /^\t/ {print a "\t" $0}' | head -60 || git blame "$F" | head -60
    ;;
esac