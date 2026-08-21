---
name: mongodb-toolkit
description: Inspect collections, indexes, run aggregation, explain.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://www.mongodb.com/docs/manual/reference/command/
metadata:
  category: database
  language: bash
  tags: [mongodb-toolkit]
---
# MongoDB Toolkit

Inspect collections, indexes, run aggregation, explain.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/mongodb-toolkit.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/mongodb-toolkit.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:mongodb-toolkit <args>`
