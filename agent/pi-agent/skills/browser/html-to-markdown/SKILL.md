---
name: html-to-markdown
description: Convert HTML pages to Markdown for readable context windows.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://github.com/sethmlarson/html2markdown
metadata:
  category: browser
  language: bash
  tags: [html-to-markdown]
---
# HTML to Markdown

Convert HTML pages to Markdown for readable context windows.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/html-to-markdown.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/html-to-markdown.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:html-to-markdown <args>`
