---
name: summarizer
description: Summarize long docs to N bullet points with key takeaways.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://www.gnu.org/software/gawk/
metadata:
  category: writing
  language: bash
  tags: [summarizer]
---
# Summarizer

Summarize long docs to N bullet points with key takeaways.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/summarizer.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/summarizer.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:summarizer <args>`
