---
name: searxng
description: Search across many engines via a SearXNG instance; no API key.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://docs.searxng.org/ https://github.com/searxng/searxng
metadata:
  category: web-search
  language: bash
  tags: [searxng]
---
# SearXNG Meta Search

Search across many engines via a SearXNG instance; no API key.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/searxng.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/searxng.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:searxng <args>`
