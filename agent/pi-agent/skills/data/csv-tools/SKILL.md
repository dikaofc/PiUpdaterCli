---
name: csv-tools
description: Inspect, transform, validate, and query CSV files.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://csvkit.readthedocs.io/ https://www.rfc-editor.org/rfc/rfc4180
metadata:
  category: data
  language: bash
  tags: [csv-tools]
---
# CSV Tools

Inspect, transform, validate, and query CSV files.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/csv-tools.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/csv-tools.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:csv-tools <args>`
