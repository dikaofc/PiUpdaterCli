---
name: xlsx-tools
description: Read, write, and inspect Excel .xlsx workbooks and metadata.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://openpyxl.readthedocs.io/
metadata:
  category: documents
  language: bash
  tags: [xlsx-tools]
---
# XLSX Tools

Read, write, and inspect Excel .xlsx workbooks and metadata.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/xlsx-tools.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/xlsx-tools.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:xlsx-tools <args>`
