---
name: typescript-toolkit
description: Type-check, build, test, and inspect TypeScript projects via tsc and npm.
license: MIT
compatibility: "POSIX shell + node. tsc resolved via local/global typescript."
source: https://www.typescriptlang.org/
metadata:
  category: programming
  language: bash
  tags: [typescript, node, npm]
---
# TypeScript Toolkit

Type-check, build, test, and inspect TypeScript projects. Fast
`node --check` syntax validation needs no TypeScript install at all.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

Requires `node` (preinstalled in Termux). For `check`/`build`,
install TypeScript in the project: `npm i -D typescript`.

## Usage

```bash
typescript-toolkit.sh syntax src/index.ts     # fast syntax check
typescript-toolkit.sh check .                 # tsc --noEmit
typescript-toolkit.sh build .                 # tsc emit
typescript-toolkit.sh test .                  # npm test
typescript-toolkit.sh deps .                  # npm ls --depth=0
```

## Notes

- `check` uses local `node_modules/.bin/tsc` first, then global `tsc`.
- `syntax` works everywhere and needs no dependencies.
