---
name: scholarly-search
description: Search Google Scholar, Semantic Scholar, Crossref for academic refs.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://api.semanticscholar.org/ https://www.crossref.org/
metadata:
  category: research
  language: bash
  tags: [scholarly-search]
---
# Scholarly Search

Search Google Scholar, Semantic Scholar, Crossref for academic refs.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/scholarly-search.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/scholarly-search.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:scholarly-search <args>`
