---
name: rust-toolkit
description: Build, test, clippy, fmt, doc, and check Rust projects with cargo.
license: MIT
compatibility: "POSIX shell + cargo toolchain."
source: https://doc.rust-lang.org/cargo/
metadata:
  category: programming
  language: bash
  tags: [rust, cargo]
---
# Rust Toolkit

Wrap common cargo workflows — build, test, clippy, fmt, doc, and
`cargo check` — behind one script.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

Requires the Rust toolchain:

```bash
pkg install rust        # Termux
# or: https://rustup.rs/
```

`clippy` and `rustfmt` need their components:
`rustup component add clippy rustfmt`.

## Usage

```bash
rust-toolkit.sh version
rust-toolkit.sh build . --release
rust-toolkit.sh test .
rust-toolkit.sh clippy .
rust-toolkit.sh fmt .
rust-toolkit.sh doc .
rust-toolkit.sh check .
```

## Options

- `--release` — build in release mode
