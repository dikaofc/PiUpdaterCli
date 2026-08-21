---
name: model-eval
description: Benchmark model outputs, compute metrics, build leaderboards.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://huggingface.co/docs/evaluate/ https://truthfulqa.github.io/
metadata:
  category: ai-ml
  language: bash
  tags: [model-eval]
---
# Model Eval

Benchmark model outputs, compute metrics, build leaderboards.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/model-eval.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/model-eval.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:model-eval <args>`
