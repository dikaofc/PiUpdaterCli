---
name: vuln-scanner
description: Scan hosts/ports, fingerprint services, run basic checks (nikto-like).
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://nmap.org/book/man-briefoptions.html
metadata:
  category: security
  language: bash
  tags: [vuln-scanner]
---
# Vuln Scanner

Scan hosts/ports, fingerprint services, run basic checks (nikto-like).

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/vuln-scanner.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/vuln-scanner.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:vuln-scanner <args>`
