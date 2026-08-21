---
name: browser-automation
description: Drive a headless browser (Chromium/Playwright) to screenshot, scrape, fill forms.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://playwright.dev/docs/intro https://pptr.dev/
metadata:
  category: browser
  language: bash
  tags: [browser-automation]
---
# Browser Automation

Drive a headless browser (Chromium/Playwright) to screenshot, scrape, fill forms.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/browser-automation.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/browser-automation.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:browser-automation <args>`
