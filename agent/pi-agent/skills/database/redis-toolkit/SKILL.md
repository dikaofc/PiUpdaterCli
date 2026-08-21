---
name: redis-toolkit
description: Inspect keys, analyze memory, TTL, Lua scripts, pub/sub.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://redis.io/commands/
metadata:
  category: database
  language: bash
  tags: [redis-toolkit]
---
# Redis Toolkit

Inspect keys, analyze memory, TTL, Lua scripts, pub/sub.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/redis-toolkit.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/redis-toolkit.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:redis-toolkit <args>`
