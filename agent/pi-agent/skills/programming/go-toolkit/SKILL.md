---
name: go-toolkit
description: Build, test, vet, format, and tidy Go modules with a single command interface.
license: MIT
compatibility: "POSIX shell + Go toolchain (go >= 1.18)."
source: https://go.dev/doc/
metadata:
  category: programming
  language: bash
  tags: [golang, go, build]
---
# Go Toolkit

Wrap the most common Go development workflows — build, test, vet,
format, module tidying, and coverage — behind one script.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

Requires the Go toolchain:

```bash
pkg install golang     # Termux
# or: https://go.dev/dl/
```

The script exits with a clear message if `go` is not installed.

## Usage

```bash
go-toolkit.sh version
go-toolkit.sh build . --out app
go-toolkit.sh test . --race
go-toolkit.sh vet .
go-toolkit.sh fmt .
go-toolkit.sh tidy .
go-toolkit.sh coverage .
```

## Options

- `--out NAME` — binary name for `build`
- `--race` — enable the race detector for `test`
