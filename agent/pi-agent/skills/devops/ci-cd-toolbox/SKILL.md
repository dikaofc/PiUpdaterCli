---
name: ci-cd-toolbox
description: Render templates, validate pipelines (GitHub Actions, GitLab, etc.).
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://docs.github.com/actions/using-workflows
metadata:
  category: devops
  language: bash
  tags: [ci-cd-toolbox]
---
# CI/CD Toolbox

Render templates, validate pipelines (GitHub Actions, GitLab, etc.).

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/ci-cd-toolbox.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/ci-cd-toolbox.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:ci-cd-toolbox <args>`
