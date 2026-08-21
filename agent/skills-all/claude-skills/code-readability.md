---
name: code-readability
description: Audit code readability — naming, dead code, magic numbers — and apply minimal refactors that preserve behavior.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: review
  tags: [readability, naming, dead-code, refactor]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Code Readability Review

## Objective
Produce a readability verdict for a target module or diff: poor variable/function
naming, dead code, magic numbers, and obscure control flow — then apply the smallest
refactors that fix the worst offenders without changing behavior. The outcome is a
scored findings list plus a minimal, verified refactor (or an explicit "no change"
decision when risk outweighs benefit).

## Preconditions
- Repository is indexed (`cap index --refresh`) and the target files are known or
  discoverable via `cap explore`.
- The working tree contains the change under review (for diff-scoped reviews).
- A refactor ceiling is agreed: rename/constant-extraction only unless the user asks
  for more.

## Workflow
1. Run `cap status` and `cap repo` to confirm the repo is clean enough to baseline, and note the git state.
2. Locate the code: `cap explore <module>` for entry points, or `cap explore <file>` for a specific target.
3. Hunt readability smells with targeted greps: `cap search "TODO|FIXME|XXX|HACK"`, `cap search "= [0-9]{4,}"` for magic numbers, and `cap search "used" --json` clues from the index for dead-code candidates.
4. Read each candidate with `cap show <file> [--lines a-b]`; judge naming (`cap show` + manual reading), confirm unreachability for dead code (check cross-references with `cap explore <symbol>`).
5. Classify findings: BLOCKER (misleading name misleads callers, dead branch on hot path), MAJOR (magic number with no context), MINOR (style nit).
6. Run `cap risk --json` to confirm the change surface is small; if risk score is high, skip refactoring and report only.
7. Create the refactor plan: `cap plan "rename X to Y, extract constant Z" --json`.
8. Apply the minimal refactor: renames and constant extraction only. Keep the diff small; no drive-by improvements (guard with `cap diff --base <ref>` before and after).
9. Verify: `cap verify`, then `cap test`,`cap lint`, `cap typecheck`; fix any regressions with `cap rollback --task <id>` if the refactor broke behavior.
10. Register the durable naming convention with `cap memory add` so future code matches.

## Verification
- [ ] `cap risk --json` score did not rise because of the refactor.
- [ ] `cap verify` passes; behavior-preservation confirmed by tests.
- [ ] `cap diff` shows only the intended renames/constants — zero drive-by changes.
- [ ] Every BLOCKER and MAJOR finding resolved or explicitly deferred with reason.
- [ ] No magic number left unexplained on the touched lines.

## Failure Handling
- If `cap risk` reports high risk from the refactor: revert with `cap rollback --task <id>` and deliver the findings list only — readability is not worth a regression.
- If dead-code candidates cannot be confirmed dead (no index hits but dynamic usage suspected): leave the code and mark the finding as UNVERIFIED, never delete on suspicion.
- If `cap verify` fails after refactor: fix the smallest cause; if two attempts fail, roll back and report the blocker.

## Output Format
- Findings table: file:line | severity | smell type | evidence (name, line, pattern).
- Refactor log: rename/constant map (old → new), files touched.
- Verification results (`cap risk`, `cap verify`, `cap test`).
- Deferred items and the explicit reason each was skipped.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap explore`, `cap search`, `cap show`, `cap risk`, `cap plan`, `cap rollback`, `cap verify`.
- CONTRACT.md §5 Rollback rules for reverting a failed refactor.