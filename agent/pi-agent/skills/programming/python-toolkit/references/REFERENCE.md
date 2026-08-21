# python-toolkit — Reference

## Commands

| Command | Description |
|---|---|
| `venv [dir]` | create virtualenv (default `.venv`), idempotent |
| `deps` | `pip list` |
| `deps --freeze` | `pip freeze` |
| `deps --install FILE` | `pip install -r FILE` |
| `check <file\|dir>` | syntax check via `python3 -m py_compile` |
| `lint <file\|dir>` | pyflakes → pylint → syntax-check fallback |
| `test [dir]` | pytest if installed, else `unittest discover` |
| `build [dir]` | sdist + wheel via the `build` package |

## Environment

- `PYTHON` — override the python binary (default `python3`).

## Examples

```bash
python-toolkit.sh venv .venv
source .venv/bin/activate
python-toolkit.sh deps --install requirements.txt
python-toolkit.sh check src tests
python-toolkit.sh test .
```

## Notes

- `check` never requires third-party packages.
- `build` needs `pip install build`.
