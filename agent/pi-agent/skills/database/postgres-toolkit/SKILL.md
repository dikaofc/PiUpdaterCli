---
name: postgres-toolkit
description: Inspect schema, run queries, manage connections, explain plans.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://www.postgresql.org/docs/current/reference.html
metadata:
  category: database
  language: bash
  tags: [postgres-toolkit]
---
# Postgres Toolkit

Inspect schema, run queries, manage connections, explain plans.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/postgres-toolkit.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/postgres-toolkit.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:postgres-toolkit <args>`
