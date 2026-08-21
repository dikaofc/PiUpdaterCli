---
name: docx-tools
description: Read, create, and modify Word .docx files via Office Open XML.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://python-docx.readthedocs.io/
metadata:
  category: documents
  language: bash
  tags: [docx-tools]
---
# DOCX Tools

Read, create, and modify Word .docx files via Office Open XML.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/docx-tools.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/docx-tools.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:docx-tools <args>`
