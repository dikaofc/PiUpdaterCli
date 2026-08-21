---
name: bug-hunter
description: Systematic bug hunting — reproduce first, form evidence-based hypotheses, apply the smallest patch, verify under tests. Use when something is broken, misbehaving, or suspicious in the current codebase.
---

# Bug Hunter

Hunt bugs like a debugger, not a guesser. The golden rule: **reproduce before you fix.** A patch without a repro is a guess.

## Workflow

1. **Reproduce.** Find the smallest input/state that triggers the bug. If you can't reproduce, say so explicitly — do not patch blind.
2. **Locate.** Narrow to the file + function. Use `grep`/`explore` for symbols, not hunches.
3. **Hypothesize (evidence-based).** State the root cause with the line that proves it. Rank hypotheses by likelihood.
4. **Smallest patch.** Fix the root cause only. No refactors, no scope creep. Avoid backwards-compat shims.
5. **Verify.** Re-run the repro. Run the project test suite (`cap test` / `npm test` / `pytest`). Confirm the bug is gone and nothing regressed.
6. **Report.** One-line root cause + the fix + how you verified.

## Common bug patterns to grep first

When the failure is vague, scan for these high-yield smells:

```sh
# unhandled async / swallowed errors
grep -rnE "await [a-zA-Z_]+\(|try \{|catch \(e\) \{[^}]*console" --include="*.ts" --include="*.js" .

# null/undefined deref
grep -rnE "\.\w+\(\)" --include="*.ts" . | grep -vE "if \(|?\.|\.map|\.filter" | head

# hardcoded paths / env not read
grep -rnE "/data/data|/usr/lib|/Users/|C:\\\\" --include="*.ts" --include="*.sh" .

# console.log left in library code
grep -rnE "console\.(log|debug|warn)" --include="*.ts" src/ agent/ 2>/dev/null

# shell: unquoted $var (word-splitting), missing set -e, rm -rf on var
grep -rnE "rm -rf \$\w|for f in \$\w|\$\w+[^*]" --include="*.sh" . | head
```

## Rules

- **Never** fix by adding a try/catch that swallows the error — that hides bugs.
- **Never** edit dist files of third-party packages; report them instead.
- Prefer `edit` (surgical) over `write` (rewrite).
- If the root cause is non-obvious, stop and report findings — do not shotgun patches.
- On flaky/non-deterministic bugs, reproduce 3x before concluding.

## Anti-patterns (do NOT do)

- Patching the symptom (e.g. `if (x === null) return;` at the call site) instead of the source.
- Adding a fallback default that masks the real failure.
- Rewriting working code "while I'm in here".
