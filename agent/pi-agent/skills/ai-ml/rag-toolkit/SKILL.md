---
name: rag-toolkit
description: Chunking, embeddings, vector search, citation grounding pipelines.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://python.langchain.com/docs/integrations/vectorstores
metadata:
  category: ai-ml
  language: bash
  tags: [rag-toolkit]
---
# RAG Toolkit

Chunking, embeddings, vector search, citation grounding pipelines.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/rag-toolkit.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/rag-toolkit.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:rag-toolkit <args>`
