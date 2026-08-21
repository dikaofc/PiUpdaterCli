# test-suite — Reference

## Commands

| Command | Description |
|---|---|
| `run [dir]` | detect framework and run tests |
| `list [dir]` | list discovered test files |

## Framework detection

| Project file | Command |
|---|---|
| `pytest.ini`, `pyproject.toml`, `tox.ini` | `pytest -q` |
| `go.mod` | `go test ./...` |
| `package.json` | `npm test --silent` |
| `Cargo.toml` | `cargo test` |
| `Makefile` | `make test` |

## Test file patterns (list)

- `test_*.py`, `*_test.py`
- `*_test.go`
- `*.test.ts`, `*.test.js`
- `*_test.rs`
- `*Test.java`

Excludes `node_modules`, `.git`, `target`, `__pycache__`.

## Examples

```bash
test-suite.sh run ~/projects/my-api
test-suite.sh list ~/projects/my-api | head
```

## Exit codes

- `0` — tests ran (result shown in output)
- `1` — no framework detected, or tests failed
