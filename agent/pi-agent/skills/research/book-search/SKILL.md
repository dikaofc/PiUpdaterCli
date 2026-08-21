---
name: book-search
description: Search books via OpenLibrary, Google Books; fetch metadata + covers.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://openlibrary.org/developers/api
metadata:
  category: research
  language: bash
  tags: [book-search]
---
# Book Search

Search books via OpenLibrary, Google Books; fetch metadata + covers.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/book-search.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/book-search.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:book-search <args>`
