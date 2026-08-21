#!/usr/bin/env bash
# Firewall Toolkit — manage iptables/nftables/ufw rules, explain firewall state
# Source: https://wiki.nftables.org/
set -euo pipefail

SCRIPT_NAME="firewall-toolkit.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} status
       ${SCRIPT_NAME} rules [--table <name>] [--family ip|ip6]
       ${SCRIPT_NAME} open <port>[/<proto>] [--permanent]
       ${SCRIPT_NAME} close <port>[/<proto>]
       ${SCRIPT_NAME} explain <rule-or-file>
Show firewall status, list rules, open/close ports, and explain rules.
Supports iptables, nftables, and ufw when present.

Options:
  --table NAME  nft table name (default inet filter)
  --family F    nft family (default inet)
  --permanent   persist via ufw (ufw only)
  -h | --help   show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARGS=()
TABLE="filter"
FAMILY="inet"
PERM=0
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    status|rules|open|close|explain) CMD="$1"; shift;;
    --table) TABLE="$2"; shift 2;;
    --family) FAMILY="$2"; shift 2;;
    --permanent) PERM=1; shift;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARGS+=("$1"); shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }

have() { command -v "$1" >/dev/null 2>&1; }

case "$CMD" in
  status)
    if have ufw; then
      echo "== ufw =="; ufw status verbose 2>&1 | head -30
    elif have nft; then
      echo "== nftables =="; nft list ruleset 2>&1 | head -40
    elif have iptables; then
      echo "== iptables =="; iptables -L -n -v 2>&1 | head -40
    else
      echo "no firewall tool found (ufw/nft/iptables). Run: pkg install iptables" >&2; exit 1
    fi
    ;;
  rules)
    if have nft; then
      nft list table "$FAMILY" "$TABLE" 2>&1 || nft list ruleset 2>&1 | head -40
    elif have iptables; then
      iptables -S 2>&1; ip6tables -S 2>&1
    else
      echo "no firewall tool found" >&2; exit 1
    fi
    ;;
  open|close)
    TARGET="${ARGS[0]:?usage: $CMD <port>[/<proto>]}"
    PORT="${TARGET%%/*}"; PROTO="${TARGET##*/}"
    case "$PROTO" in tcp|udp) ;; *) PROTO="tcp";; esac
    if have ufw; then
      CMD_LOW=$(echo "$CMD" | tr '[:upper:]' '[:lower:]')
      if [ "$PERM" = "1" ]; then ufw "$CMD_LOW" "$PORT/$PROTO"; else ufw --dry-run "$CMD_LOW" "$PORT/$PROTO" 2>&1 || true; ufw "$CMD_LOW" "$PORT/$PROTO"; fi
    elif have nft; then
      echo "nftables detected — adding rule to table $FAMILY $TABLE:"
      if [ "$CMD" = "open" ]; then
        nft add rule "$FAMILY" "$TABLE" "$PROTO" dport "$PORT" accept 2>&1 && echo "  added accept rule for $PORT/$PROTO"
      else
        nft add rule "$FAMILY" "$TABLE" "$PROTO" dport "$PORT" drop 2>&1 && echo "  added drop rule for $PORT/$PROTO"
      fi
    elif have iptables; then
      if [ "$CMD" = "open" ]; then
        iptables -A INPUT -p "$PROTO" --dport "$PORT" -j ACCEPT && echo "iptables: ACCEPT $PORT/$PROTO"
      else
        iptables -A INPUT -p "$PROTO" --dport "$PORT" -j DROP && echo "iptables: DROP $PORT/$PROTO"
      fi
    else
      echo "no firewall tool found" >&2; exit 1
    fi
    ;;
  explain)
    SRC="${ARGS[0]:?usage: explain <rule-or-file>}"
    if [ -f "$SRC" ]; then RULES=$(grep -vE '^\s*#|^\s*$' "$SRC"); else RULES="$SRC"; fi
    echo "$RULES" | while IFS= read -r rule; do
      [ -z "$rule" ] && continue
      echo "rule: $rule"
      if echo "$rule" | grep -qE 'nft|add rule'; then
        echo "  nftables: adds a rule to the named table/chain"
      elif echo "$rule" | grep -qE 'iptables|INPUT|OUTPUT|FORWARD'; then
        echo "  iptables: packet filter rule (INPUT=inbound, OUTPUT=outbound)"
      elif echo "$rule" | grep -qE 'ufw (allow|deny|limit)'; then
        echo "  ufw: high-level firewall policy (allow=permit, deny=block, limit=rate-cap)"
      else
        echo "  generic rule line (action on match)"
      fi
      # break down protocol/ports
      echo "$rule" | grep -oE '(-p|proto) (tcp|udp|icmp)|dport [0-9]+|--dport [0-9]+|sport [0-9]+' | sed 's/^/    match: /' || true
      echo "$rule" | grep -oE '(accept|drop|reject|allow|deny|limit|ACCEPT|DROP|REJECT)' | head -1 | sed 's/^/    action: /' || true
    done
    ;;
esac