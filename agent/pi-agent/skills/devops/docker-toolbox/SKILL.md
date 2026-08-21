---
name: docker-toolbox
description: Build, run, inspect images/containers and scan for secrets.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://docs.docker.com/ https://docs.docker.com/engine/api/
metadata:
  category: devops
  language: bash
  tags: [docker-toolbox]
---
# Docker Toolbox

Build, run, inspect images/containers and scan for secrets.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/docker-toolbox.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/docker-toolbox.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:docker-toolbox <args>`
