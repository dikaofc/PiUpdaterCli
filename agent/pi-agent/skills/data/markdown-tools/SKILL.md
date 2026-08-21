---
name: markdown-tools
description: Lint, inject TOC, check links, convert Markdown.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://spec.commonmark.org/
metadata:
  category: data
  language: bash
  tags: [markdown-tools]
---
# Markdown Tools

Lint, inject TOC, check links, convert Markdown.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/markdown-tools.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/markdown-tools.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:markdown-tools <args>`
