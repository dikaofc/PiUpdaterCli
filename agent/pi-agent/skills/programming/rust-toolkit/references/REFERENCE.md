# rust-toolkit — Reference

## Commands

| Command | Description |
|---|---|
| `version` | print `cargo --version` |
| `build [dir] [--release]` | `cargo build` |
| `test [dir]` | `cargo test` |
| `clippy [dir]` | `cargo clippy -- -D warnings` (needs clippy component) |
| `fmt [dir]` | `cargo fmt` (needs rustfmt component) |
| `doc [dir]` | `cargo doc --no-deps` |
| `check [dir]` | `cargo check` |

## Environment

- `CARGO` — override the cargo binary path.

## Examples

```bash
rust-toolkit.sh build . --release
rust-toolkit.sh clippy .
rust-toolkit.sh doc .
```

## Notes

- Component install: `rustup component add clippy rustfmt`.
- Install the toolchain on Termux: `pkg install rust`.
