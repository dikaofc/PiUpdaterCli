---
name: news-aggregator
description: Fetch headlines from RSS/Atom feeds and news APIs.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://www.rssboard.org/rss-specification
metadata:
  category: research
  language: bash
  tags: [news-aggregator]
---
# News Aggregator

Fetch headlines from RSS/Atom feeds and news APIs.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/news-aggregator.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/news-aggregator.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:news-aggregator <args>`
