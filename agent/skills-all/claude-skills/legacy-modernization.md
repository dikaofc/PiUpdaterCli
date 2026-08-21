---
name: legacy-modernization
description: Modernize legacy code safely with characterization tests and small refactors.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [legacy, refactor, modernization]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Legacy Code Modernization

## Objective
Improve maintainability without changing behavior, protected by tests.

## Preconditions
- `cap repo` run; `cap test` baseline captured.
- Risk areas identified via `cap explore`/`cap diff` history.

## Workflow
1. Run `cap explore` and `cap search` for dead code, globals, and copy-paste.
2. Add characterization tests around the module before touching it (lock current behavior).
3. Apply the smallest safe refactor (`cap refactor`); keep tests green.
4. Replace deprecated APIs and globals with modern equivalents one at a time.
5. Delete dead code only after tests prove it is unused.
6. Record the modernization map with `cap memory add`.

## Verification
- [ ] Characterization tests pass before/after.
- [ ] Behavior unchanged (tests green).
- [ ] No new deprecation warnings.
- [ ] Dead code removed only when proven unused.

## Failure Handling
- If behavior differs, the test caught a hidden contract — keep it.
- If too risky, split the module first.

## Output Format
Modernization map: tests added, refactors done, APIs replaced, and dead code removed.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
