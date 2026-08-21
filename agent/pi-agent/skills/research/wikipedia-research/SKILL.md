---
name: wikipedia-research
description: Search, fetch, cross-link Wikipedia articles and categories.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://en.wikipedia.org/api/rest_v1/
metadata:
  category: research
  language: bash
  tags: [wikipedia-research]
---
# Wikipedia Research

Search, fetch, cross-link Wikipedia articles and categories.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/wikipedia-research.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/wikipedia-research.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:wikipedia-research <args>`
