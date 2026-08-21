---
name: wikipedia-search
description: Search or fetch Wikipedia articles via the MediaWiki REST API.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://en.wikipedia.org/api/rest_v1/ https://www.mediawiki.org/wiki/API:Main_page
metadata:
  category: web-search
  language: bash
  tags: [wikipedia-search]
---
# Wikipedia Search

Search or fetch Wikipedia articles via the MediaWiki REST API.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/wikipedia-search.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/wikipedia-search.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:wikipedia-search <args>`
