---
name: python-unittest
description: Port or migrate Python tests to unittest/pytest conventions with measured coverage.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) with `cap test` wired to the project's Python test runner (pytest or unittest).
metadata:
  category: testing
  tags: [python, pytest, unittest, coverage]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Python Unittest

## Objective
Migrate a Python codebase's tests to one consistent convention (unittest, pytest, or pytest collecting unittest-style classes), naming and fixture conventions included, while keeping behavior coverage at least as good as before. Coverage is measured before and after the port; the migration lands with a coverage baseline recorded for regressions.

## Preconditions
- `cap repo` detects the Python test tooling (pytest.ini/pyproject `[tool.pytest]`, `setup.cfg`, or unittest discovery layout).
- A baseline `cap test` run and a baseline coverage measurement exist (recorded via `cap memory add`).
- The target convention is decided; pytest `unittest.TestCase` support means a full rewrite is optional when unittest classes already work.

## Workflow
1. Run `cap status` and `cap repo` to confirm tooling; read the test config with `cap show pytest.ini` / `cap show pyproject.toml`.
2. Inventory test files with `cap search "unittest|TestCase|def test_|assertRaises|self\.assert"` and group them by module under test via `cap explore`.
3. Measure baseline coverage: `cap test` with the configured coverage runner and record the per-module percentages with `cap memory add`.
4. Port files in dependency order: rename to `test_<module>.py`, convert `assertEqual/assertTrue` to pytest `assert` where pytest-native style is chosen, and map fixtures to pytest `fixture`/`tmp_path` (or keep unittest `setUp` when the repo standard stays unittest).
5. Convert assertion error paths explicitly — `assertRaises` → `pytest.raises` context manager, `assertRaisesRegex` → `match=` — and check `cap explore` so no test silently stops asserting (the silent-pass trap).
6. After each module, run `cap test --target test_<module>.py` and `cap coverage` if configured; fix ported tests before moving on.
7. Run the full `cap test` suite, then measure post-port coverage; any drop below the baseline must be explained or the missing branch re-tested.
8. Run `cap lint` and `cap verify`, then `cap diff` to confirm only test files (and minimal support files) changed; record conventions with `cap memory add`.

## Verification
- [ ] All tests follow one convention; no mixed idioms in a single file (`cap search` shows zero legacy assertions in ported files).
- [ ] Baseline test count == post-port count (or the delta is documented, e.g. parametrization expands count).
- [ ] Post-port coverage >= baseline coverage per module.
- [ ] No silent-pass tests: every ported case still asserts (verified by `cap explore` on each ported file).
- [ ] `cap test`, `cap lint`, `cap verify` all green; `cap diff` contains only test-side changes.

## Failure Handling
- Coverage drops: `cap risk` the diff, find the untested branch with the coverage report, and add a targeted test rather than reverting the port.
- A ported test passes without its assertion (e.g. `pytest.raises` mis-scoped): fix the scope immediately; treat a passing-but-not-asserting test as a failure, not a success.
- unittest-only features have no pytest equivalent: keep that file unittest-style and note the exemption with a comment; never fake a port.
- Fixtures diverge between test files: extract the shared fixture into `conftest.py` (pytest) or a `BaseTestCase` (unittest) and re-run the suite.

## Output Format
Final report:
- Files ported, with old → new naming and idiom mapping applied per file.
- Baseline vs. post-port coverage table (per module) and test counts.
- Convention decisions recorded (fixture style, assertions, param style) and exemptions kept.
- `cap test`/`cap lint`/`cap verify` results and final `cap diff` summary.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap search`, `cap explore`, `cap show`, `cap test`, `cap lint`, `cap verify`, `cap diff`, `cap risk`, `cap memory add`.