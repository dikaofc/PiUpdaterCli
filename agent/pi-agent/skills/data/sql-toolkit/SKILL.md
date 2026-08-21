---
name: sql-toolkit
description: Run ad-hoc SQL against sqlite/postgres/mysql and generate schema docs.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://www.sqlite.org/cli.html
metadata:
  category: data
  language: bash
  tags: [sql-toolkit]
---
# SQL Toolkit

Run ad-hoc SQL against sqlite/postgres/mysql and generate schema docs.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/sql-toolkit.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/sql-toolkit.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:sql-toolkit <args>`
