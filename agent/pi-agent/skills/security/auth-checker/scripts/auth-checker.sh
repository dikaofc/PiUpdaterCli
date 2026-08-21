#!/usr/bin/env bash
# Auth Checker — verify credentials, validate token formats, check expiry
# Source: https://datatracker.ietf.org/doc/html/rfc7519 (JWT)
set -euo pipefail

SCRIPT_NAME="auth-checker.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} validate <path>             # file or env-file with KEY=value
       ${SCRIPT_NAME} jwt <token>                 # decode + validate a JWT
       ${SCRIPT_NAME} key <api-key>               # detect provider by prefix
       ${SCRIPT_NAME} env <file>                  # report which vars are set/empty
Check credentials: detect key types, decode JWTs (no signature verify
unless a secret is provided), check expiry, and scan env files.
JWT decoding needs python3.

Options:
  --secret S   secret (HMAC) to verify JWT signature
  -h | --help  show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARG=""
SECRET=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    validate|jwt|key|env) CMD="$1"; shift;;
    --secret) SECRET="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARG="$1"; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
[ -z "$ARG" ] && { echo "missing argument: ${CMD} <value>" >&2; exit 2; }

detect_key() {
  local k="$1"
  if echo "$k" | grep -qE '^AKIA[0-9A-Z]{16}$'; then echo "AWS Access Key ID (16-char, starts AKIA)"; return; fi
  if echo "$k" | grep -qE '^ASIA[0-9A-Z]{16}$'; then echo "AWS temporary Access Key"; return; fi
  if echo "$k" | grep -qE '^ghp_[A-Za-z0-9]{36}$'; then echo "GitHub Personal Access Token (classic)"; return; fi
  if echo "$k" | grep -qE '^github_pat_[A-Za-z0-9_]{22,}$'; then echo "GitHub fine-grained PAT"; return; fi
  if echo "$k" | grep -qE '^gho_[A-Za-z0-9]{20,}$'; then echo "GitHub OAuth token"; return; fi
  if echo "$k" | grep -qE '^xox[bap]-[A-Za-z0-9-]{10,}$'; then echo "Slack token"; return; fi
  if echo "$k" | grep -qE '^sk-[A-Za-z0-9]{20,}$'; then echo "OpenAI-style API key (sk-...)"; return; fi
  if echo "$k" | grep -qE '^pk_[A-Za-z0-9]{20,}$'; then echo "Stripe publishable key"; return; fi
  if echo "$k" | grep -qE '^sk_live_[A-Za-z0-9]{20,}$'; then echo "Stripe secret key (live)"; return; fi
  if echo "$k" | grep -qE '^sk_test_[A-Za-z0-9]{20,}$'; then echo "Stripe test secret key"; return; fi
  if echo "$k" | grep -qE '^AIza[A-Za-z0-9_-]{35}$'; then echo "Google API key"; return; fi
  if echo "$k" | grep -qE '^ya29\.[A-Za-z0-9_-]+$'; then echo "Google OAuth token"; return; fi
  if echo "$k" | grep -qE '^[0-9]{15,16}$'; then echo "possible card number / numeric ID (length ${#k})"; return; fi
  echo "unknown key type (length ${#k})"
}

case "$CMD" in
  key)
    detect_key "$ARG"
    ;;
  validate)
    if [ -f "$ARG" ]; then
      echo "validating env file: $ARG"
      # extract KEY=value pairs (skip comments), report per-line
      grep -vE '^\s*#|^\s*$' "$ARG" | while IFS='=' read -r k v; do
        [ -z "$k" ] && continue
        v="${v#\"}"; v="${v%\"}"
        if [ -z "$v" ]; then
          echo "  $k: EMPTY"
        else
          echo "  $k: set (${#v} chars) — $(detect_key "$v")"
        fi
      done
    else
      detect_key "$ARG"
      echo ""
      echo "non-empty: yes  length: ${#ARG}"
    fi
    ;;
  jwt)
    command -v python3 >/dev/null 2>&1 || { echo "python3 required for JWT decoding" >&2; exit 1; }
    JWT_SECRET="$SECRET" JWT_TOKEN="$ARG" python3 - <<'PYEOF'
import base64, json, hmac, hashlib, os, sys, time

token = os.environ.get("JWT_TOKEN", "")
parts = token.split(".")
if len(parts) != 3:
    print(f"invalid JWT: expected 3 dot-separated segments, got {len(parts)}")
    sys.exit(1)

def b64d(s):
    s += "=" * (-len(s) % 4)
    return base64.urlsafe_b64decode(s)

try:
    header = json.loads(b64d(parts[0]))
    payload = json.loads(b64d(parts[1]))
except Exception as e:
    print(f"JWT decode error: {e}")
    sys.exit(1)

print(f"header: {header}")
print(f"claims:")
for k, v in payload.items():
    print(f"  {k}: {v}")

now = time.time()
if "exp" in payload:
    left = payload["exp"] - now
    if left < 0:
        print(f"EXPIRED {abs(left):.0f}s ago")
    else:
        print(f"expires in {left/3600:.1f}h (ok)")
if "nbf" in payload and now < payload["nbf"]:
    print("not yet valid (nbf in future)")

secret = os.environ.get("JWT_SECRET", "")
if secret:
    sig = base64.urlsafe_b64encode(hmac.new(secret.encode(), token.rsplit(".", 1)[0].encode(), hashlib.sha256).digest()).rstrip("=").decode()
    ok = hmac.compare_digest(sig, parts[2])
    print(f"signature (HS256, provided secret): {'VALID' if ok else 'INVALID'}")
else:
    print("signature: not verified (no --secret provided; header claims " + str(header.get("alg", "?")) + ")")
PYEOF
    ;;
  env)
    [ -f "$ARG" ] || { echo "not found: $ARG" >&2; exit 1; }
    echo "env file: $ARG"
    grep -vE '^\s*#|^\s*$' "$ARG" | while IFS='=' read -r k v; do
      if [ -n "$k" ] && [ -n "$v" ]; then
        echo "  OK   $k (set)"
      elif [ -n "$k" ]; then
        echo "  EMPTY $k"
      fi
    done
    echo ""
    WARN=$(grep -cE '^\s*[A-Z_]+=\s*$' "$ARG")
    echo "empty variables: $WARN"
    ;;
esac
