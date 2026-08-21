---
name: docs-style
description: Enforce style guide, generate docs, check links and spelling.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://developers.google.com/style
metadata:
  category: writing
  language: bash
  tags: [docs-style]
---
# Docs Style

Enforce style guide, generate docs, check links and spelling.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/docs-style.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/docs-style.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:docs-style <args>`
