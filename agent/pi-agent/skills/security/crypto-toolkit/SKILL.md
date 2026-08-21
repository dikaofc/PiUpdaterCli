---
name: crypto-toolkit
description: Hashes, HMAC, symmetric/asymmetric crypto, JWT, signing, verification.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://openssl.org/docs/ https://datatracker.ietf.org/wg/oauth/
metadata:
  category: security
  language: bash
  tags: [crypto-toolkit]
---
# Crypto Toolkit

Hashes, HMAC, symmetric/asymmetric crypto, JWT, signing, verification.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/crypto-toolkit.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/crypto-toolkit.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:crypto-toolkit <args>`
