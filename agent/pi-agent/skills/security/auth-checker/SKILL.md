---
name: auth-checker
description: "Audit authn/authz: JWT validation, OAuth flows, session security."
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://datatracker.ietf.org/wg/oauth/ https://openid.net/connect/
metadata:
  category: security
  language: bash
  tags: [auth-checker]
---
# Auth Checker

Audit authn/authz: JWT validation, OAuth flows, session security.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/auth-checker.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/auth-checker.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:auth-checker <args>`
