# go-toolkit — Reference

## Commands

| Command | Description |
|---|---|
| `version` | print `go version` |
| `build [dir] [--out NAME]` | `go build` (with optional binary name) |
| `test [dir] [--race]` | `go test ./...` (+ race detector) |
| `vet [dir]` | `go vet ./...` |
| `fmt [dir]` | `gofmt` all packages |
| `tidy [dir]` | `go mod tidy` |
| `coverage [dir]` | test with coverage profile, print total |

## Examples

```bash
go-toolkit.sh build . --out server
go-toolkit.sh test ./internal/ --race
go-toolkit.sh coverage .
```

## Environment

- `GO` — override the go binary path if not on PATH.

## Exit codes

- `0` — success
- `1` — go toolchain missing, or go command failed
- `2` — usage error
