---
description: Structured debugging — reproduce, gather evidence, hypothesize, verify, fix
argument-hint: <bug description or failing test>
---

Fol
<!-- ​​ built by @dikaacode (telegram) ​​ -->
low the debugging skill workflow. Evidence over guesses, one hypothesis at a time.

1. **Reproduce**: `cap test --target <file>` or run the failing command; capture the exact error output.
2. **Gather evidence**:
   - `cap search "<error message symbols>"` — locate the code path.
   - `cap show <file> --lines a-b` — read the suspicious code with line numbers.
   - `cap diff` — what changed recently (common root cause).
   - `cap audit --limit 10` — related task/change history.
3. **Hypothesize**: form a small set (2–3) of plausible root causes; rank by evidence.
4. **Test hypotheses**: for each, verify against the code (`cap show`) or a targeted `cap test`; choose the one the evidence supports.
5. **Fix**: apply the minimal fix, then `cap test --target <file>` (must pass), then related tests, then `cap lint`/`cap typecheck`.

Output:
- **Symptom** (exact error/failure)
- **Evidence** (file:line entries)
- **Root cause**
- **Fix** (files touched)
- **Verification** (test/lint/typecheck results)