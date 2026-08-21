---
name: portfolio-tracker
description: Compute returns, risk metrics, asset allocation.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://www.investopedia.com/
metadata:
  category: finance
  language: bash
  tags: [portfolio-tracker]
---
# Portfolio Tracker

Compute returns, risk metrics, asset allocation.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/portfolio-tracker.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/portfolio-tracker.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:portfolio-tracker <args>`
