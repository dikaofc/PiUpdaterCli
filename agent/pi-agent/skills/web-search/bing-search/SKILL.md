---
name: bing-search
description: Microsoft Bing Web Search API v7 for general web search.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://learn.microsoft.com/bing/search-apis/bing-web-search/overview
metadata:
  category: web-search
  language: bash
  tags: [bing-search]
---
# Bing Search

Microsoft Bing Web Search API v7 for general web search.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/bing-search.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/bing-search.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:bing-search <args>`
