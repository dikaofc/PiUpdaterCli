---
name: python-venv
description: Set up and maintain a reproducible Python virtual environment with locked dependencies.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and a Python 3.8+ interpreter on the host; `venv` from the standard library.
metadata:
  category: coding
  tags: [python, venv, pip, reproducibility, dependencies]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Python Venv

## Objective
Create or repair a Python project's virtual environment so every environment is reproducible: an isolated `.venv`, a pinned `requirements.txt` (or a hashed lock), and install steps documented in the repo. The environment is verified by installing a fresh clone of the dependency set into a clean venv and running the test suite.

## Preconditions
- A Python project exists with at least one dependency manifest (`pyproject.toml`, `requirements*.txt`, or `setup.py`/`setup.cfg`).
- `python3` (>= 3.8) is on PATH or `cap repo` finds the project's configured interpreter.
- Any existing `.venv` state is disposable or its contents are backed up.

## Workflow
1. Run `cap status` and `cap repo` to confirm the project layout; read the dependency manifests with `cap show requirements.txt` / `cap show pyproject.toml` to learn current pins and extras.
2. Inventory lock state with `cap search "requirements.*\.txt|pip-tools|uv lock|poetry.lock"` so the chosen lock strategy matches the repo's conventions.
3. Create the venv: `python3 -m venv .venv` (or `uv venv` if the repo standardizes on uv), then record interpreter version with `cap memory add` (`python3 --version` + pip version) for reproducibility notes.
4. Install the declared dependencies into the venv (`.venv/bin/pip install -r requirements.txt` for the current set) and freeze the exact resolved set: `pip freeze` when no lock exists, else refresh the repo's lock tool output. Add full hashes (`pip freeze --all` + `pip hash` entries) where the repo policy demands supply-chain safety.
5. Upgrade in a bounded, risk-mapped pass: list outdated with `pip list --outdated`, then for each candidate run `cap risk` on a proposed pin bump; never bulk-upgrade unrelated packages in one step.
6. Verify reproducibility on a clean venv: create `.venv-beta`, install only from the lock, and run `cap test` inside it; delete the beta venv on success.
7. Run `cap verify` and `cap diff` to confirm only manifest/lock/docs changes; check `cap rules check` on any modified Python files.
8. Record the setup/install sequence as a durable fact set (`cap memory add`) so future sessions reuse the same commands.

## Verification
- [ ] Fresh-venv install from the lock completes with zero warnings/errors and correct interpreter version.
- [ ] Runtime deps vs. dev deps are separated (dev extras never leak into the base lock).
- [ ] `cap test` passes in the beta venv; `cap verify` green.
- [ ] `cap diff` shows only manifest, lock, .gitignore (venv paths), and setup docs changes.
- [ ] No credentials or absolute machine paths appear in the lock (checked via `cap search`).

## Failure Handling
- Install fails on a fresh venv: roll back to the previous lock with `cap rollback --task <id>`, bisect the offending pin by `pip install -r` halves, and re-freeze.
- A package is unbuildable on this Python version: pin to the last compatible release, record the version floor in `cap memory add`, and flag it in the report.
- Lock drift (checksums disagree): regenerate the lock from a clean install with `--require-hashes` enforced, and re-run verification — never edit hashes by hand.
- The interpreter is missing: report the exact required version from `cap repo` detection; do not fall back to a system-wide install without approval.

## Output Format
Final report:
- Venv path, Python/pip versions, and the lock file used (with hash mode).
- Dependencies added/removed/bumped (old → new) and the `cap risk` rationale per bump.
- Clean-install verification result and test counts.
- Reproducibility commands recorded for future sessions.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap show`, `cap search`, `cap risk`, `cap test`, `cap verify`, `cap diff`, `cap rollback`, `cap rules check`, `cap memory add`.