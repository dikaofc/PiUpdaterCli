---
name: market-data
description: Fetch stock/crypto/FX prices via public market APIs.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://www.alphavantage.co/ https://www.coingecko.com/en/api
metadata:
  category: finance
  language: bash
  tags: [market-data]
---
# Market Data

Fetch stock/crypto/FX prices via public market APIs.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/market-data.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/market-data.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:market-data <args>`
