---
name: spaced-repetition
description: Generate spaced-rep cards, schedules, Anki import/export.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://apps.ankiweb.net/
metadata:
  category: education
  language: bash
  tags: [spaced-repetition]
---
# Spaced Repetition

Generate spaced-rep cards, schedules, Anki import/export.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/spaced-repetition.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/spaced-repetition.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:spaced-repetition <args>`
