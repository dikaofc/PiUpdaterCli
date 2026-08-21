---
description: Run tests targeted-first, then related, then the full suite; report per-phase
argument-hint: [--target <file>]
---

Run
<!-- ​​ built by @dikaacode (telegram) ​​ -->
 tests in escalation order and report each phase separately.

1. **Targeted**: `cap test --target <file>` (use the argument if given; otherwise `cap test` for the default target).
2. **Related**: find dependent/related tests with `cap explore "<module>"` / `cap search`, then `cap test --target <related-file>` for each.
3. **Full**: `cap test` — the complete suite.
4. **Quality gate**: `cap lint` and `cap typecheck` after tests pass.

For every phase record: pass count, fail count, duration if reported. For each failure, capture the failing file:line and the error message.

Output:
- **Phase results** — per phase, pass/fail + failures (file:line, error).
- **Overall status** — PASS or FAIL with the evidence.
- If a phase fails, stop escalating and report; do not run the full suite on a known-broken targeted phase unless it is informative.