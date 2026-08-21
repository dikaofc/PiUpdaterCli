---
name: google-search
description: Google web search via Programmable Search JSON API.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://developers.google.com/custom-search/v1/
metadata:
  category: web-search
  language: bash
  tags: [google-search]
---
# Google Search

Google web search via Programmable Search JSON API.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/google-search.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/google-search.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:google-search <args>`
