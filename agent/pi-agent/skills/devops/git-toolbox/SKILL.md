---
name: git-toolbox
description: Inspect commits, diffs, branches, run hooks, and audit history.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://git-scm.com/docs
metadata:
  category: devops
  language: bash
  tags: [git-toolbox]
---
# Git Toolbox

Inspect commits, diffs, branches, run hooks, and audit history.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/git-toolbox.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/git-toolbox.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:git-toolbox <args>`
