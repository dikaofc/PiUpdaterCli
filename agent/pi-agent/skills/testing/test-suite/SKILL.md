---
name: test-suite
description: Auto-detect the test framework in a project and run or list its tests.
license: MIT
compatibility: "POSIX shell. Uses pytest / go test / npm test / cargo test / make test."
source: https://docs.pytest.org/
metadata:
  category: testing
  language: bash
  tags: [testing, pytest, ci]
---
# Test Suite

Point it at any project directory; it detects the test framework
from project files and runs the right command, or lists the test
files it found.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

No installation. Detection is automatic:

| Project file | Framework | Command run |
|---|---|---|
| `pytest.ini` / `pyproject.toml` / `tox.ini` | pytest | `pytest -q` |
| `go.mod` | Go | `go test ./...` |
| `package.json` | Node | `npm test` |
| `Cargo.toml` | Rust | `cargo test` |
| `Makefile` | Make | `make test` |

## Usage

```bash
test-suite.sh run myproject/
test-suite.sh list myproject/
```
