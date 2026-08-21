---
name: pptx-tools
description: Extract text and notes from PowerPoint .pptx slides.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://python-pptx.readthedocs.io/
metadata:
  category: documents
  language: bash
  tags: [pptx-tools]
---
# PPTX Tools

Extract text and notes from PowerPoint .pptx slides.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/pptx-tools.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/pptx-tools.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:pptx-tools <args>`
