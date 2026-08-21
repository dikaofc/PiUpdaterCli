---
name: cron-parser
description: Parse, validate, describe, and generate cron expressions and schedules.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://en.wikipedia.org/wiki/Cron https://crontab.guru/
metadata:
  category: devops
  language: bash
  tags: [cron-parser]
---
# Cron Parser

Parse, validate, describe, and generate cron expressions and schedules.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/cron-parser.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/cron-parser.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:cron-parser <args>`
