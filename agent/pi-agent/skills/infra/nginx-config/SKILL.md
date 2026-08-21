---
name: nginx-config
description: Lint, render, and explain nginx configuration with syntax checks.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://nginx.org/en/docs/
metadata:
  category: infra
  language: bash
  tags: [nginx-config]
---
# Nginx Config

Lint, render, and explain nginx configuration with syntax checks.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/nginx-config.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/nginx-config.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:nginx-config <args>`
