---
name: prompt-engineering
description: Chain-of-thought, RAG prompting, few-shot templates, eval prompts.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://docs.anthropic.com/en/docs/advanced-prompting
metadata:
  category: ai-ml
  language: bash
  tags: [prompt-engineering]
---
# Prompt Engineering

Chain-of-thought, RAG prompting, few-shot templates, eval prompts.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/prompt-engineering.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/prompt-engineering.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:prompt-engineering <args>`
