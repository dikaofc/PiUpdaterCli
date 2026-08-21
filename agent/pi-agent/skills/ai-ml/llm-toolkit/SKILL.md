---
name: llm-toolkit
description: Call LLM providers, embed text, manage prompts, token counting, costs.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://platform.openai.com/docs/api-reference https://docs.anthropic.com/
metadata:
  category: ai-ml
  language: bash
  tags: [llm-toolkit]
---
# LLM Toolkit

Call LLM providers, embed text, manage prompts, token counting, costs.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/llm-toolkit.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/llm-toolkit.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:llm-toolkit <args>`
