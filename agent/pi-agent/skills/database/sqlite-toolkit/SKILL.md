---
name: sqlite-toolkit
description: Inspect DBs, schema, run queries, WAL analysis.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://www.sqlite.org/cli.html
metadata:
  category: database
  language: bash
  tags: [sqlite-toolkit]
---
# SQLite Toolkit

Inspect DBs, schema, run queries, WAL analysis.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/sqlite-toolkit.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/sqlite-toolkit.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:sqlite-toolkit <args>`
