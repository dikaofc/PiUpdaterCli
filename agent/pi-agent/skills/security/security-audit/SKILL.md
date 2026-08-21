---
name: security-audit
description: Static analysis, dependency vulns, secret scanning, SAST/DAST triage.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://owasp.org/www-project-top-ten/ https://github.com/11x256/cloc
metadata:
  category: security
  language: bash
  tags: [security-audit]
---
# Security Audit

Static analysis, dependency vulns, secret scanning, SAST/DAST triage.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/security-audit.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/security-audit.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:security-audit <args>`
