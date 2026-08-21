#!/usr/bin/env bash
# Crypto Toolkit — hashes, HMAC, symmetric/asymmetric crypto, JWT, signing
# Source: https://docs.python.org/3/library/hashlib.html
set -euo pipefail

SCRIPT_NAME="crypto-toolkit.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} hash <data|-> <md5|sha1|sha256|sha512> [--salt S]
       ${SCRIPT_NAME} hmac <data> <secret>
       ${SCRIPT_NAME} genkey [--type rsa|ed25519|aes] [--bits N] [--out DIR]
       ${SCRIPT_NAME} jwt-encode <payload.json> <secret> [--ttl SECONDS]
       ${SCRIPT_NAME} jwt-decode <token> [--secret S]
Hashing, HMAC, key generation, and JWT utilities. Uses python3 stdlib
(hashlib, hmac, secrets) + cryptography if installed.

Options:
  --salt S     salt for hash
  --type T     key type (rsa|ed25519|aes; default rsa)
  --bits N     key size (default 2048 rsa / 32 bytes aes)
  --out DIR    directory to write keys
  --ttl SEC    JWT expiry seconds (default 3600)
  --secret S   secret to verify JWT
  -h | --help  show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARGS=()
SALT=""
TYPE="rsa"
BITS=0
OUT_DIR="."
TTL=3600
SECRET=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    hash|hmac|genkey|jwt-encode|jwt-decode) CMD="$1"; shift;;
    --salt) SALT="$2"; shift 2;;
    --type) TYPE="$2"; shift 2;;
    --bits) BITS="$2"; shift 2;;
    --out) OUT_DIR="$2"; shift 2;;
    --ttl) TTL="$2"; shift 2;;
    --secret) SECRET="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARGS+=("$1"); shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }

case "$CMD" in
  hash)
    DATA="${ARGS[0]:-}"
    ALGO="${ARGS[1]:-sha256}"
    if [ "$DATA" = "-" ]; then DATA=$(cat); fi
    [ -z "$DATA" ] && { echo "missing data (use - for stdin)" >&2; exit 2; }
    HASHTOOL="$ALGO" SALT="$SALT" DATA="$DATA" python3 - <<'PYEOF'
import hashlib, os

algo = os.environ["HASHTOOL"]
data = os.environ["DATA"].encode()
salt = os.environ["SALT"].encode()
if salt:
    data = salt + data
try:
    h = hashlib.new(algo, data)
except ValueError:
    print(f"unsupported algorithm: {algo}", file=sys.stderr)
    raise SystemExit(1)
print(f"{algo}: {h.hexdigest()}")
if salt:
    print(f"salt: {os.environ['SALT']}")
PYEOF
    ;;
  hmac)
    DATA="${ARGS[0]:-}"
    KEY="${ARGS[1]:-}"
    [ -z "$KEY" ] && { echo "usage: crypto-toolkit.sh hmac <data> <secret>" >&2; exit 2; }
    HMAC_DATA="$DATA" HMAC_KEY="$KEY" python3 - <<'PYEOF'
import hmac, hashlib, os

data = os.environ["HMAC_DATA"].encode()
key = os.environ["HMAC_KEY"].encode()
sig = hmac.new(key, data, hashlib.sha256).hexdigest()
print(f"HMAC-SHA256: {sig}")
PYEOF
    ;;
  genkey)
    [ "$BITS" = "0" ] && BITS=$([ "$TYPE" = "aes" ] && echo 32 || echo 2048)
    mkdir -p "$OUT_DIR"
    GENTYPE="$TYPE" GENBITS="$BITS" GENOUT="$OUT_DIR" python3 - <<'PYEOF'
import os, base64

t, bits, out = os.environ["GENTYPE"], int(os.environ["GENBITS"]), os.environ["GENOUT"]
if t == "rsa":
    try:
        from cryptography.hazmat.primitives.asymmetric import rsa
        from cryptography.hazmat.primitives import serialization
        key = rsa.generate_private_key(public_exponent=65537, key_size=bits)
        priv = key.private_bytes(serialization.Encoding.PEM, serialization.PrivateFormat.PKCS8, serialization.NoEncryption())
        pub = key.public_key().public_bytes(serialization.Encoding.PEM, serialization.PublicFormat.SubjectPublicKeyInfo)
        open(os.path.join(out, "id_rsa.pem"), "wb").write(priv)
        open(os.path.join(out, "id_rsa.pub.pem"), "wb").write(pub)
        print(f"wrote {out}/id_rsa.pem and id_rsa.pub.pem ({bits}-bit RSA)")
    except ImportError:
        print("cryptography not installed — pip install cryptography", file=sys.stderr)
        raise SystemExit(3)
elif t == "ed25519":
    try:
        from cryptography.hazmat.primitives.asymmetric import ed25519
        from cryptography.hazmat.primitives import serialization
        key = ed25519.Ed25519PrivateKey.generate()
        priv = key.private_bytes(serialization.Encoding.PEM, serialization.PrivateFormat.PKCS8, serialization.NoEncryption())
        pub = key.public_key().public_bytes(serialization.Encoding.PEM, serialization.PublicFormat.SubjectPublicKeyInfo)
        open(os.path.join(out, "ed25519.pem"), "wb").write(priv)
        open(os.path.join(out, "ed25519.pub.pem"), "wb").write(pub)
        print(f"wrote {out}/ed25519.pem and ed25519.pub.pem")
    except ImportError:
        print("cryptography not installed — pip install cryptography", file=sys.stderr)
        raise SystemExit(3)
elif t == "aes":
    k = os.urandom(bits)
    open(os.path.join(out, "aes_key.bin"), "wb").write(k)
    print(f"wrote {out}/aes_key.bin ({bits}-byte random key)")
    print(f"hex: {k.hex()}")
else:
    print(f"unknown type: {t}", file=sys.stderr)
    raise SystemExit(2)
PYEOF
    ;;
  jwt-encode)
    PAYLOAD="${ARGS[0]:-}"
    SECRET_ARG="${ARGS[1]:-$SECRET}"
    [ -z "$SECRET_ARG" ] && { echo "usage: crypto-toolkit.sh jwt-encode <payload.json> <secret>" >&2; exit 2; }
    JWT_SECRET="$SECRET_ARG" JWT_PAYLOAD="$PAYLOAD" JWT_TTL="$TTL" python3 - <<'PYEOF'
import base64, json, hmac, hashlib, os, time

payload = json.loads(os.environ["JWT_PAYLOAD"])
payload.setdefault("iat", int(time.time()))
payload["exp"] = int(time.time()) + int(os.environ["JWT_TTL"])
header = {"alg": "HS256", "typ": "JWT"}

def b64(o):
    return base64.urlsafe_b64encode(json.dumps(o, separators=(",", ":")).encode()).rstrip(b"=").decode()

sig_input = f"{b64(header)}.{b64(payload)}"
sig = base64.urlsafe_b64encode(hmac.new(os.environ["JWT_SECRET"].encode(), sig_input.encode(), hashlib.sha256).digest()).rstrip(b"=").decode()
print(f"{sig_input}.{sig}")
PYEOF
    ;;
  jwt-decode)
    TOKEN="${ARGS[0]:-}"
    [ -z "$TOKEN" ] && { echo "usage: crypto-toolkit.sh jwt-decode <token> [--secret S]" >&2; exit 2; }
    JWT_SECRET="$SECRET" JWT_TOKEN="$TOKEN" python3 - <<'PYEOF'
import base64, json, hmac, hashlib, os, time

token = os.environ["JWT_TOKEN"]
parts = token.split(".")
if len(parts) != 3:
    print("invalid JWT format"); raise SystemExit(1)

def b64d(s):
    s += "=" * (-len(s) % 4)
    return base64.urlsafe_b64decode(s)

h = json.loads(b64d(parts[0]))
p = json.loads(b64d(parts[1]))
print(f"header: {json.dumps(h)}")
print(f"claims: {json.dumps(p, indent=2)}")
if "exp" in p:
    left = p["exp"] - time.time()
    print(f"expires in {left/60:.0f} min ({'OK' if left > 0 else 'EXPIRED'})")
if os.environ.get("JWT_SECRET"):
    sig = base64.urlsafe_b64encode(hmac.new(os.environ["JWT_SECRET"].encode(), token.rsplit(".", 1)[0].encode(), hashlib.sha256).digest()).rstrip(b"=").decode()
    print(f"signature: {'VALID' if hmac.compare_digest(sig, parts[2]) else 'INVALID'}")
else:
    print("signature: not verified")
PYEOF
    ;;
esac