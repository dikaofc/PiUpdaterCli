---
name: web-scraper
description: Recursive site scraping with sitemap/robots compliance and polite delays.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://www.robotstxt.org/ http://www.sitemaps.org/protocol.html
metadata:
  category: browser
  language: bash
  tags: [web-scraper]
---
# Web Scraper

Recursive site scraping with sitemap/robots compliance and polite delays.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/web-scraper.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/web-scraper.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:web-scraper <args>`
