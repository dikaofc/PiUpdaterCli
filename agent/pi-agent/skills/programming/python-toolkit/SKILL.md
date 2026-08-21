---
name: python-toolkit
description: Create venvs, manage dependencies, syntax-check, lint, test, and build Python projects.
license: MIT
compatibility: "POSIX shell + python3. Optional: pytest, pyflakes, build."
source: https://docs.python.org/3/library/venv.html
metadata:
  category: programming
  language: bash
  tags: [python, venv, pip, pytest]
---
# Python Toolkit

Manage Python environments and run day-to-day dev workflows:
virtualenvs, dependency management, syntax checks, linting, tests,
and package builds.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

Only `python3` is required (preinstalled in Termux). Optional
enhancements: `pip install pytest pyflakes build`.

## Usage

```bash
python-toolkit.sh venv .venv
python-toolkit.sh deps --install requirements.txt
python-toolkit.sh check src/
python-toolkit.sh lint src/
python-toolkit.sh test .
python-toolkit.sh build .
```

## Options

- `--install FILE` — `pip install -r FILE` (with `deps`)
- `--freeze` — print `pip freeze` output (with `deps`)

## Commands

| Command | Description |
|---|---|
| `venv [dir]` | create a virtualenv (default `.venv`) |
| `deps` | list / freeze / install dependencies |
| `check <file\|dir>` | syntax check via `py_compile` (always works) |
| `lint <file\|dir>` | pyflakes or pylint (falls back to syntax check) |
| `test [dir]` | pytest, or `unittest discover` as fallback |
| `build [dir]` | sdist + wheel via the `build` package |
