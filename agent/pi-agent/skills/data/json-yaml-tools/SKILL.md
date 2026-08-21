---
name: json-yaml-tools
description: Validate, query (jq), diff, merge JSON and YAML.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://stedolan.github.io/jq/manual/ https://yaml.org/spec/
metadata:
  category: data
  language: bash
  tags: [json-yaml-tools]
---
# JSON/YAML Tools

Validate, query (jq), diff, merge JSON and YAML.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/json-yaml-tools.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/json-yaml-tools.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:json-yaml-tools <args>`
