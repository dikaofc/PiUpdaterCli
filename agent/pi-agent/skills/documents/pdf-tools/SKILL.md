---
name: pdf-tools
description: Extract text, fill forms, merge, split, and inspect PDF metadata.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://pypdf.readthedocs.io/ https://pdfa.org/
metadata:
  category: documents
  language: bash
  tags: [pdf-tools]
---
# PDF Tools

Extract text, fill forms, merge, split, and inspect PDF metadata.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/pdf-tools.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/pdf-tools.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:pdf-tools <args>`
