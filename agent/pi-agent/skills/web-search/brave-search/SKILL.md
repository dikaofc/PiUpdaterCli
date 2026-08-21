---
name: brave-search
description: Web search and content extraction via the Brave Search API. Use for searching documentation, facts, current events, or any web content, and optionally extracting readable page text.
license: MIT
compatibility: "Node.js >= 20 (global fetch, stdlib only). No npm install required."
source: https://brave.com/developers/ https://api.search.brave.com/res/v1/web/search
metadata:
  category: web-search
  language: bash
  tags: [search, scrape, web, brave]
---

# Brave Search

Search the web and extract page content via the [Brave Search API](https://brave.com/developers/).

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
export BRAVE_API_KEY="your-key-here"        # or: pi config env BRAVE_API_KEY
```

(Optional, for full-text extraction:)

```bash
export READABILITY_URL="http://localhost:5050/api/text"
```

## Usage

| Command | Description |
|---------|-------------|
| `./scripts/search.ts typescript async iterators` | Plain search, 10 hits |
| `./scripts/search.ts "openapi 3.1 spec" --content` | Search + extract page bodies |
| `./scripts/search.ts "rust serde derive" --save results.json` | Save JSON to `results.json` |
| `./scripts/search.ts -h` | Full help |

### Argument reference

```
<query...>        search query (words are joined)
--content        also fetch readable text for each result URL
--save <file>     write JSON results to <file>
-n, --count <N>   number of results (default 10, max 20)
-h, --help        show help
```
