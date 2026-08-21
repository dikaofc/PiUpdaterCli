#!/usr/bin/env bash
# Security Audit — static analysis, dependency vulns, secret scanning, SAST/DAST triage
# Source: https://owasp.org/www-project-top-ten/
set -euo pipefail

SCRIPT_NAME="security-audit.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} secrets <path>                 # scan files for secrets
       ${SCRIPT_NAME} deps <path>                    # check dependency manifests
       ${SCRIPT_NAME} sast <dir>                     # static heuristics per language
       ${SCRIPT_NAME} headers <url>                  # check HTTP security headers
       ${SCRIPT_NAME} tls <host>[:<port>]            # TLS/SSL check (openssl or python)
Static analysis, secret scanning, dependency vuln checks, HTTP header
audits, and TLS checks. Uses curl, grep, python3 stdlib.

Options:
  -h | --help    show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARG=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    secrets|deps|sast|headers|tls) CMD="$1"; shift;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARG="$1"; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
[ -z "$ARG" ] && { echo "missing argument: ${CMD} <path|url|host>" >&2; exit 2; }

SECRET_RE='(AKIA[0-9A-Z]{16}|-----BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY-----|ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{22,}|sk-[A-Za-z0-9]{20,}|xox[bap]-[A-Za-z0-9-]{10,}|AIza[A-Za-z0-9_-]{35}|sk_live_[A-Za-z0-9]{20,}|sk_test_[A-Za-z0-9]{20,})'

case "$CMD" in
  secrets)
    if [ -f "$ARG" ]; then
      echo "scanning file: $ARG"
      grep -nE "$SECRET_RE" "$ARG" | sed 's/^/  /' || echo "  no hits"
    elif [ -d "$ARG" ]; then
      echo "scanning directory: $ARG"
      HITS=0
      while IFS= read -r f; do
        case "$f" in
          *node_modules*|*/\.git/*|*.min.js|*.map|*.class) continue;;
        esac
        [ -f "$f" ] || continue
        if grep -lE "$SECRET_RE" "$f" >/dev/null 2>&1; then
          echo "  potential secret in: $f"
          grep -noE "$SECRET_RE" "$f" | head -2 | sed 's/^/    /'
          HITS=$((HITS + 1))
        fi
      done < <(find "$ARG" -type f -size -2M 2>/dev/null | head -1000)
      echo "done: $HITS file(s) with potential secrets"
    else
      echo "not found: $ARG" >&2; exit 1
    fi
    ;;
  deps)
    if [ -f "$ARG/package.json" ]; then
      echo "node: $(grep -c '"' "$ARG/package.json" || true) deps listed — use 'npm audit' for advisory check"
      [ -f "$ARG/package-lock.json" ] && echo "  lockfile present: package-lock.json"
    fi
    if [ -f "$ARG/requirements.txt" ]; then
      echo "python requirements:"
      grep -vE '^\s*#|^\s*$' "$ARG/requirements.txt" | head -20 | while IFS= read -r p; do echo "  $p"; done
      echo "  (pip-audit or 'pip list --outdated' for advisories)"
    fi
    if [ -f "$ARG/pom.xml" ] || [ -f "$ARG/build.gradle" ]; then
      echo "java build file present (use OWASP Dependency-Check)"
    fi
    echo ""
    echo "note: run dependency scanners when package managers are available"
    ;;
  sast)
    [ -d "$ARG" ] || { echo "not a directory: $ARG" >&2; exit 1; }
    echo "static analysis heuristics for: $ARG"
    echo "--- command injection (shell/exec) ---"
    grep -rnE '(system|exec|shell_exec|os\.system|subprocess\.(call|run|Popen)|Runtime\.getRuntime)\([^)]*' "$ARG" --include="*.php" --include="*.py" --include="*.js" --include="*.java" 2>/dev/null | grep -vE 'test|spec' | head -5 | sed 's/^/  /' || echo "  none found"
    echo "--- SQL string concatenation ---"
    grep -rnE 'SELECT .*from .*(" *\+|\"\s*\+|\+ *\"|f["'"'"'].*SELECT)' "$ARG" --include="*.php" --include="*.py" --include="*.js" 2>/dev/null | head -5 | sed 's/^/  /' || echo "  none found"
    echo "--- eval / innerHTML (XSS) ---"
    grep -rnE '(eval\(|innerHTML *=|document\.write)' "$ARG" --include="*.js" --include="*.jsx" --include="*.ts" 2>/dev/null | head -5 | sed 's/^/  /' || echo "  none found"
    echo "--- insecure file permissions ---"
    find "$ARG" -type f -perm -0002 2>/dev/null | head -5 | sed 's/^/  /' || true
    ;;
  headers)
    echo "checking HTTP security headers on $ARG"
    RESP=$(curl -sSI -L --max-time 20 -A "Mozilla/5.0" "$ARG" 2>/dev/null || echo "ERR")
    if [ "$RESP" = "ERR" ]; then echo "  could not fetch $ARG" >&2; exit 1; fi
    for h in "strict-transport-security" "content-security-policy" "x-frame-options" "x-content-type-options" "referrer-policy" "permissions-policy"; do
      if echo "$RESP" | grep -qi "^$h:"; then
        echo "  OK   $h: $(echo "$RESP" | grep -i "^$h:" | head -1 | cut -d: -f2- | xargs | cut -c1-80)"
      else
        echo "  MISS $h"
      fi
    done
    ;;
  tls)
    HOST="${ARG%%:*}"; PORT="${ARG##*:}"
    case "$PORT" in *[!0-9]*|"") PORT=443;; esac
    if command -v openssl >/dev/null 2>&1; then
      echo | timeout 15 openssl s_client -connect "$HOST:$PORT" -servername "$HOST" 2>/dev/null | grep -E 'subject=|issuer=|Protocol|Cipher|Verify return' | sed 's/^/  /' || echo "  connection failed"
    else
      echo "openssl not installed — using python3 TLS check"
      TLS_HOST="$HOST" TLS_PORT="$PORT" python3 - <<'PYEOF'
import socket, ssl, os, sys
host, port = os.environ["TLS_HOST"], int(os.environ["TLS_PORT"])
try:
    ctx = ssl.create_default_context()
    with socket.create_connection((host, port), timeout=8) as s:
        with ctx.wrap_socket(s, server_hostname=host) as ss:
            cert = ss.getpeercert()
            print(f"  connected via TLS {ss.version()}")
            print(f"  cipher: {ss.cipher()}")
            print(f"  cert subject: {cert.get('subject')}")
            print(f"  cert issuer: {cert.get('issuer')}")
except Exception as e:
    print(f"  TLS check failed: {e}")
PYEOF
    fi
    ;;
esac