#!/usr/bin/env bash
# Docker Toolbox — build, run, inspect images/containers, scan for secrets
# Source: https://docs.docker.com/reference/
set -euo pipefail

SCRIPT_NAME="docker-toolbox.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} ps [--all]
       ${SCRIPT_NAME} images
       ${SCRIPT_NAME} inspect <name-or-id>
       ${SCRIPT_NAME} logs <container>
       ${SCRIPT_NAME} build <path> [--tag NAME]
       ${SCRIPT_NAME} run <image> <cmd...>
       ${SCRIPT_NAME} secrets <image-or-path>
Inspect Docker state, build/run, and scan images or directories for secrets.
Requires the docker CLI.

Options:
  --all      include stopped containers for ps
  --tag NAME image tag for build
  -h | --help show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARGS=()
TAG=""
ALL=0
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    ps|images|inspect|logs|build|run|secrets) CMD="$1"; shift;;
    --all) ALL=1; shift;;
    --tag) TAG="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARGS+=("$1"); shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
: "${DOCKER:?docker not found — install docker or set DOCKER=path}"

case "$CMD" in
  ps)
    if [ "$ALL" = "1" ]; then $DOCKER ps -a; else $DOCKER ps; fi
    ;;
  images)
    $DOCKER images
    ;;
  inspect)
    TARGET="${ARGS[0]:?usage: inspect <name-or-id>}"
    $DOCKER inspect "$TARGET"
    ;;
  logs)
    TARGET="${ARGS[0]:?usage: logs <container>}"
    T=$(timeout 2 $DOCKER logs --tail 1 "$TARGET" >/dev/null 2>&1; echo $?)
    $DOCKER logs --tail "${ARGS[1]:-50}" "$TARGET"
    ;;
  build)
    PATH_ARG="${ARGS[0]:-.}"
    if [ -n "$TAG" ]; then $DOCKER build -t "$TAG" "$PATH_ARG"; else $DOCKER build -t "$(basename "$PATH_ARG"):latest" "$PATH_ARG"; fi
    ;;
  run)
    IMG="${ARGS[0]:?usage: run <image> <cmd...>}"
    cmd_args=("${ARGS[@]:1:20}")
    if [ ${#cmd_args[@]} -gt 0 ]; then
      $DOCKER run --rm "$IMG" "${cmd_args[@]}"
    else
      $DOCKER run --rm "$IMG"
    fi
    ;;
  secrets)
    TARGET="${ARGS[0]:?usage: secrets <image-or-path>}"
    if [ -d "$TARGET" ]; then
      FILES=$(find "$TARGET" -type f -size -2M 2>/dev/null | head -500)
    else
      FILES=$(timeout 60 $DOCKER run --rm --entrypoint /bin/sh "$TARGET" -c "find / -type f -not -path '/proc/*' -size -2M 2>/dev/null | head -500" 2>/dev/null || echo "")
      [ -z "$FILES" ] && { echo "could not list files in image $TARGET" >&2; exit 1; }
    fi
    echo "scanning for secrets in: $TARGET"
    echo "$FILES" | while IFS= read -r f; do
      [ -f "$f" ] || continue
      case "$f" in
        *node_modules*|*.so*|*.a|*.o|*/\.git/*) continue;;
      esac
      grep -lE 'AKIA[0-9A-Z]{16}|-----BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY-----|ghp_[A-Za-z0-9]{36}|sk-[A-Za-z0-9]{20,50}|xox[bp]-[A-Za-z0-9-]{10,}' "$f" 2>/dev/null | while read -r hit; do
        echo "  candidate: $hit"
      done
    done | head -40
    echo "secrets scan complete"
    ;;
esac