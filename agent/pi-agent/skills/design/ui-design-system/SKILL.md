---
name: ui-design-system
description: Design tokens, color palettes, typography scales, spacing systems.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://www.w3.org/WAI/standards/
metadata:
  category: design
  language: bash
  tags: [ui-design-system]
---
# UI Design System

Design tokens, color palettes, typography scales, spacing systems.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/ui-design-system.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/ui-design-system.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:ui-design-system <args>`
