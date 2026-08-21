---
name: learning-path
description: Build curriculum paths from goals and prerequisites.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://en.wikipedia.org/wiki/Curriculum
metadata:
  category: education
  language: bash
  tags: [learning-path]
---
# Learning Path

Build curriculum paths from goals and prerequisites.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/learning-path.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/learning-path.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:learning-path <args>`
