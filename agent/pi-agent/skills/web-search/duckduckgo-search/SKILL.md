---
name: duckduckgo-search
description: Instant answers via DuckDuckGo HTML lite endpoint (privacy-respecting, no key).
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://duckduckgo.com/ https://duckduckgo.com/api
metadata:
  category: web-search
  language: bash
  tags: [duckduckgo-search]
---
# DuckDuckGo Search

Instant answers via DuckDuckGo HTML lite endpoint (privacy-respecting, no key).

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/duckduckgo-search.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/duckduckgo-search.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:duckduckgo-search <args>`
