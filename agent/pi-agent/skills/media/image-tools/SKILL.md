---
name: image-tools
description: Convert, resize, caption, OCR images via ImageMagick.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://imagemagick.org/script/command-line-options.php
metadata:
  category: media
  language: bash
  tags: [image-tools]
---
# Image Tools

Convert, resize, caption, OCR images via ImageMagick.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/image-tools.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/image-tools.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:image-tools <args>`
