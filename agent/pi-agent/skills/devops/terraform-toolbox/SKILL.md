---
name: terraform-toolbox
description: fmt, validate, plan parsing, state inspection, drift detection.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://developer.hashicorp.com/terraform/cli
metadata:
  category: devops
  language: bash
  tags: [terraform-toolbox]
---
# Terraform Toolbox

fmt, validate, plan parsing, state inspection, drift detection.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/terraform-toolbox.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/terraform-toolbox.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:terraform-toolbox <args>`
