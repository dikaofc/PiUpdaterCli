---
name: arxiv-scholar
description: Search and fetch arXiv papers + metadata; extract abstracts.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://arxiv.org/help/api/user-manual
metadata:
  category: research
  language: bash
  tags: [arxiv-scholar]
---
# ArXiv Scholar

Search and fetch arXiv papers + metadata; extract abstracts.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/arxiv-scholar.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/arxiv-scholar.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:arxiv-scholar <args>`
