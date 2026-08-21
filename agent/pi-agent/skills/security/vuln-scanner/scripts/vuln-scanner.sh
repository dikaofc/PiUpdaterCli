#!/usr/bin/env bash
# Vuln Scanner — scan hosts/ports, fingerprint services, run basic checks
# Source: https://nmap.org/book/man.html
set -euo pipefail

SCRIPT_NAME="vuln-scanner.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} ports <host> [--top N] [--range 1-1000]
       ${SCRIPT_NAME} services <host> [--ports 22,80,443]
       ${SCRIPT_NAME} header-check <url>
       ${SCRIPT_NAME} ping <host>
Scan hosts for open ports, fingerprint services, and run basic
checks. Uses nmap when available, otherwise a python3 TCP fallback.

IMPORTANT: only scan hosts you own or have permission to test.

Options:
  --top N       top N ports (default 100)
  --range R     port range for fallback scan
  --ports P     explicit port list
  -h | --help   show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
HOST=""
TOP=100
RANGE="1-1000"
PORTS="22,80,443"
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    ports|services|header-check|ping) CMD="$1"; shift;;
    --top) TOP="$2"; shift 2;;
    --range) RANGE="$2"; shift 2;;
    --ports) PORTS="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) HOST="$1"; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
[ -z "$HOST" ] && { echo "missing host" >&2; exit 2; }

case "$CMD" in
  ping)
    if command -v ping >/dev/null 2>&1; then
      ping -c 3 -W 2 "$HOST" 2>&1 | tail -3
    else
      echo "ping not available — trying TCP 443"
      SCAN_HOST="$HOST" python3 - <<'PYEOF'
import socket, os, sys
host = os.environ["SCAN_HOST"]
try:
    s = socket.create_connection((host, 443), timeout=5)
    print(f"{host}:443 reachable")
    s.close()
except Exception:
    print(f"{host} unreachable")
    sys.exit(1)
PYEOF
    fi
    ;;
  ports)
    if command -v nmap >/dev/null 2>&1; then
      OUT_NMAP=$(nmap -sS -T4 --top-ports "$TOP" "$HOST" 2>&1 || true)
      if echo "$OUT_NMAP" | grep -q 'requires root'; then
        echo "note: SYN scan needs root — using TCP connect scan" >&2
        OUT_NMAP=$(nmap -sT -T4 --top-ports "$TOP" "$HOST" 2>&1 || true)
      fi
      echo "$OUT_NMAP" | grep -E '^[0-9]+/' | head -30
    else
      echo "nmap not found — python3 TCP connect scan (range $RANGE)" >&2
      SCAN_HOST="$HOST" SCAN_RANGE="$RANGE" python3 - <<'PYEOF'
import socket, os, sys
host = os.environ["SCAN_HOST"]
lo, hi = (int(x) for x in os.environ["SCAN_RANGE"].split("-"))
open_ports = []
for p in range(lo, min(hi, lo + 1024)):
    try:
        s = socket.create_connection((host, p), timeout=0.4)
        open_ports.append(p); s.close()
    except OSError:
        pass
if open_ports:
    print("open ports:", ", ".join(str(p) for p in open_ports))
else:
    print("no open ports found in range")
PYEOF
    fi
    ;;
  services)
    if command -v nmap >/dev/null 2>&1; then
      OUT_NMAP=$(nmap -sV -p "$PORTS" "$HOST" 2>&1 || true)
      if echo "$OUT_NMAP" | grep -q 'requires root'; then
        echo "note: SYN scan needs root — using TCP connect scan" >&2
        OUT_NMAP=$(nmap -sT -sV -p "$PORTS" "$HOST" 2>&1 || true)
      fi
      echo "$OUT_NMAP" | grep -E '^[0-9]+/|PORT' | head -30
    else
      echo "nmap not found — python3 banner fetch on ports $PORTS" >&2
      SCAN_HOST="$HOST" SCAN_PORTS="$PORTS" python3 - <<'PYEOF'
import socket, os, sys
host = os.environ["SCAN_HOST"]
ports = [int(x) for x in os.environ["SCAN_PORTS"].split(",")]
for p in ports:
    try:
        s = socket.create_connection((host, p), timeout=3)
        s.settimeout(2)
        try:
            banner = s.recv(256).decode("utf-8", "replace").strip().replace("\n", " ")
        except OSError:
            banner = "(no banner)"
        print(f"{p}/tcp open  {banner[:80]}")
        s.close()
    except OSError:
        print(f"{p}/tcp closed")
PYEOF
    fi
    ;;
  header-check)
    echo "checking $HOST"
    curl -sSI -L --max-time 20 -A "Mozilla/5.0" "$HOST" 2>/dev/null | head -30 || echo "  could not reach host"
    ;;
esac