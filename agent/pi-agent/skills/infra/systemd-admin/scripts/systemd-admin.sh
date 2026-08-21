#!/usr/bin/env bash
# Systemd Admin — inspect units, logs, timers, generate service unit files
# Source: https://www.freedesktop.org/software/systemd/man/systemd.service.html
set -euo pipefail

SCRIPT_NAME="systemd-admin.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} units [--type service|timer|...]
       ${SCRIPT_NAME} status <unit>
       ${SCRIPT_NAME} logs <unit> [--lines N]
       ${SCRIPT_NAME} timers
       ${SCRIPT_NAME} gen-service --name NAME --exec "/path/to/bin args" [--user]
Generate a systemd service unit from a command line.

Options:
  --type T     unit type filter (default all)
  --lines N    log lines (default 50)
  --name NAME  service name for gen-service
  --exec CMD   ExecStart command
  --user       user-level unit
  -h | --help  show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARGS=()
TYPE=""
LINES=50
NAME=""
EXEC=""
USER_MODE=0
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    units|status|logs|timers|gen-service) CMD="$1"; shift;;
    --type) TYPE="$2"; shift 2;;
    --lines) LINES="$2"; shift 2;;
    --name) NAME="$2"; shift 2;;
    --exec) EXEC="$2"; shift 2;;
    --user) USER_MODE=1; shift;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARGS+=("$1"); shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }

have_systemd() { command -v systemctl >/dev/null 2>&1 && [ -d /run/systemd/system ] 2>/dev/null; }

case "$CMD" in
  gen-service)
    [ -z "$NAME" ] && { echo "missing --name" >&2; exit 2; }
    [ -z "$EXEC" ] && { echo "missing --exec" >&2; exit 2; }
    if [ "$USER_MODE" = "1" ]; then
      OUT_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user/$NAME.service"
    else
      OUT_PATH="/etc/systemd/system/$NAME.service"
    fi
    cat <<UNIT
# systemd service unit for $NAME
# install: cp to $OUT_PATH then:
#   sudo systemctl daemon-reload && sudo systemctl enable --now $NAME
[Unit]
Description=$NAME
After=network.target

[Service]
Type=simple
ExecStart=$EXEC
Restart=on-failure
RestartSec=5
# Environment=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

[Install]
WantedBy=multi-user.target
UNIT
    echo ""
    echo "# target: $OUT_PATH"
    ;;
  units|status|logs|timers)
    if ! have_systemd; then
      echo "systemd not running in this environment (this is normal in Termux/containers)." >&2
      echo "The gen-service command still works for generating unit files." >&2
      exit 0
    fi
    case "$CMD" in
      units)
        FILTER=""
        [ -n "$TYPE" ] && FILTER="--type=$TYPE"
        systemctl list-units $FILTER --no-pager 2>&1 | head -40
        ;;
      status)
        U="${ARGS[0]:?usage: status <unit>}"
        systemctl status "$U" --no-pager 2>&1 | head -30
        ;;
      logs)
        U="${ARGS[0]:?usage: logs <unit>}"
        if command -v journalctl >/dev/null 2>&1; then
          journalctl -u "$U" -n "$LINES" --no-pager 2>&1
        else
          systemctl status "$U" --no-pager 2>&1 | tail -30
        fi
        ;;
      timers)
        systemctl list-timers --no-pager 2>&1 | head -25
        ;;
    esac
    ;;
esac