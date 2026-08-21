---
name: systemd-admin
description: Inspect units, logs, timers, and generate service unit files.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://www.freedesktop.org/software/systemd/man/
metadata:
  category: infra
  language: bash
  tags: [systemd-admin]
---
# Systemd Admin

Inspect units, logs, timers, and generate service unit files.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/systemd-admin.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/systemd-admin.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:systemd-admin <args>`
