#!/usr/bin/env bash
# Nginx Config — lint, render, explain nginx configuration
# Source: https://nginx.org/en/docs/
set -euo pipefail

SCRIPT_NAME="nginx-config.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} lint <nginx.conf> [--nginx-bin PATH]
       ${SCRIPT_NAME} render <template> [--vars k=v ...] [--out <file>]
       ${SCRIPT_NAME} explain <nginx.conf>
Lint nginx configs with nginx -t, render variable templates,
and explain server blocks and directives.

Options:
  --nginx-bin PATH  path to nginx binary (default: nginx)
  --vars k=v        template variables (repeatable)
  --out FILE        write rendered output to FILE
  -h | --help       show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
INPUT=""
NGINX_BIN="nginx"
VARS=()
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    lint|render|explain) CMD="$1"; shift;;
    --nginx-bin) NGINX_BIN="$2"; shift 2;;
    --vars) VARS+=("$2"); shift 2;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) INPUT="$1"; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
[ -f "$INPUT" ] || { echo "file not found: $INPUT" >&2; exit 1; }

emit() {
  if [ -n "$OUT" ]; then
    echo "$1" > "$OUT"
    echo "Saved to $OUT"
  else
    echo "$1"
  fi
}

render_vars() {
  local body
  body=$(cat "$INPUT")
  for kv in "${VARS[@]}"; do
    K="${kv%%=*}"; V="${kv#*=}"
    body=$(printf '%s' "$body" | env "K=$K" "V=$V" python3 -c "
import os, sys
t = sys.stdin.read()
k, v = os.environ['K'], os.environ['V']
t = t.replace('\${' + k + '}', v).replace('\$' + k, v)
sys.stdout.write(t)")
  done
  printf '%s\n' "$body"
}

case "$CMD" in
  lint)
    if command -v "$NGINX_BIN" >/dev/null 2>&1; then
      "$NGINX_BIN" -t -c "$(realpath "$INPUT")" 2>&1
    else
      echo "nginx binary not found ($NGINX_BIN) — running structural checks" >&2
      python3 - "$INPUT" <<'PYEOF'
import sys, re

path = sys.argv[1]
src = open(path, encoding="utf-8").read()
issues = []
depth = 0
lineno = 0
stack = []
for i, line in enumerate(src.splitlines(), 1):
    stripped = re.sub(r"#.*", "", line)
    opens = stripped.count("{") - stripped.count("}")
    # count braces carefully
    for ch in stripped:
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth < 0:
                issues.append(f"line {i}: unexpected '}}'")
    if depth < 0:
        depth = 0
if depth != 0:
    issues.append(f"unbalanced braces: {depth} open at EOF")
if not issues:
    print("OK: braces balanced, looks structurally valid")
else:
    print("\n".join(issues))
    sys.exit(1)
PYEOF
    fi
    ;;
  render)
    emit "$(render_vars)"
    ;;
  explain)
    python3 - "$INPUT" <<'PYEOF'
import sys, re

path = sys.argv[1]
src = open(path, encoding="utf-8").read()
lines = src.splitlines()
i = 0
block_re = re.compile(r"^\s*([a-z_]+)\s*(.*?)\s*\{")
while i < len(lines):
    line = lines[i].strip()
    if not line or line.startswith("#"):
        i += 1; continue
    m = block_re.match(line)
    if m:
        d, args = m.group(1), m.group(2)
        indent = len(lines[i]) - len(lines[i].lstrip())
        if d in ("server", "http", "location", "upstream", "events", "stream", "if", "map"):
            desc = {"server": "virtual host / connection vhost",
                    "http": "HTTP protocol context (global)",
                    "location": "URI routing block",
                    "upstream": "backend server pool for load balancing",
                    "events": "connection processing model",
                    "stream": "TCP/UDP proxying context",
                    "map": "variable mapping block",
                    "if": "conditional directive"}[d]
            print(f"{' ' * indent}{d} {args}:  ({desc})")
            if d == "server":
                if re.search(r"listen\s+(\d+)", src):
                    m2 = re.search(r"listen\s+(\d+)", src)
                    print(f"{' ' * (indent + 2)}listens on port {m2.group(1)}")
                m3 = re.search(r"server_name\s+([^;]+);", src)
                if m3:
                    print(f"{' ' * (indent + 2)}server_name: {m3.group(1).strip()}")
            if d == "location":
                print(f"{' ' * (indent + 2)}routes requests matching '{args}'")
        else:
            print(f"{' ' * indent}{d} {args}:  (block)")
    else:
        # simple directive
        m2 = re.match(r"^\s*([a-z_]+)\s+(.+);", line)
        if m2:
            d, args = m2.group(1), m2.group(2)
            desc = {"listen": "port/address to accept connections",
                    "server_name": "hostnames this server responds to",
                    "root": "document root directory",
                    "proxy_pass": "upstream to forward requests to",
                    "return": "immediate response (e.g. redirects)",
                    "rewrite": "URL rewrite rule",
                    "try_files": "fallback file resolution order",
                    "location": "URI block"}.get(d, "directive")
            print(f"  {d} {args};  ({desc})")
    i += 1
PYEOF
    ;;
esac