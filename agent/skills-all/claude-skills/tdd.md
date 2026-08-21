---
name: tdd
description: Implement features red-green-refactor: failing test first, minimal code, then clean.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: testing
  tags: [tdd, testing]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Test-Driven Development

## Objective
Drive implementation from a failing test so behavior is specified before code exists.

## Preconditions
- `cap repo` run; test runner confirmed working (`cap test` baseline green).

## Workflow
1. Run `cap repo` and `cap explore <symbol>` to locate where the new behavior belongs.
2. Write the smallest failing test that expresses the desired behavior; confirm it fails for the right reason.
3. Write the minimal production code to make it pass; resist over-building.
4. Run `cap test --target <file>` to confirm green; then `cap verify` for the whole suite.
5. Refactor the implementation (`cap refactor`) keeping tests green; run `cap diff` to keep the change small.
6. Record the behavior contract with `cap memory add`.

## Verification
- [ ] A failing test existed before code (red).
- [ ] Code makes it pass (green) with no extra scope.
- [ ] Refactor kept suite green.
- [ ] Diff contains only intended changes.

## Failure Handling
- If test passes immediately, the test is wrong — tighten it.
- If green requires huge code, split the behavior into smaller TDD cycles.

## Output Format
Report: the failing-then-passing test, the minimal implementation, refactor notes, and final `cap test` result.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
