---
name: k8s-toolbox
description: Inspect pods, generate manifests, dry-run, and diagnose clusters.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://kubernetes.io/docs/reference/
metadata:
  category: devops
  language: bash
  tags: [k8s-toolbox]
---
# Kubernetes Toolbox

Inspect pods, generate manifests, dry-run, and diagnose clusters.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/k8s-toolbox.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/k8s-toolbox.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:k8s-toolbox <args>`
