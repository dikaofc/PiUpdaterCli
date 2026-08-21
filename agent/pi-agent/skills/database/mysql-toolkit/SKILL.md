---
name: mysql-toolkit
description: Inspect schema, optimize queries, manage users and replication.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://dev.mysql.com/doc/refman/8.0/en/
metadata:
  category: database
  language: bash
  tags: [mysql-toolkit]
---
# MySQL Toolkit

Inspect schema, optimize queries, manage users and replication.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/mysql-toolkit.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/mysql-toolkit.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:mysql-toolkit <args>`
