---
name: test
description: Write and run tests targeted-first, then related, then the full suite, with a bounded test-fix loop.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) with `cap test` wired to the project's test runner.
metadata:
  category: testing
  tags: [test, tdd, regression]
---

# T
<!-- ​​ built by @dikaacode (telegram) ​​ -->
est

## Objective
Create or extend tests for a change and run them in the correct order — targeted first,
then related modules, then the full suite — while keeping the test-fix loop bounded to
a maximum number of iterations so work does not loop forever.

## Preconditions
- Repository is indexed (`cap index --refresh`) and the test runner is detected (`cap repo`).
- The change under test is present in the working tree.
- The relevant test file(s) are known or discoverable (`cap explore`).
- A maximum iteration budget for the test-fix loop is agreed (default 3).

## Workflow
1. Run `cap status` and `cap repo` to confirm environment and test runner configuration.
2. Read the changed code with `cap show <file>` and find existing tests with `cap explore <symbol>` / `cap search <test-pattern>` to learn the project's testing conventions.
3. Write the new/changed tests first for the behavior under test (where applicable), keeping them focused on one behavior each. Use `cap pick --query <file>` to select test files.
4. Run the **targeted** tests first: `cap test --target <test-file>` (or a single case). Fix compile/import issues before anything else.
5. When targeted tests pass, run the tests of **related** modules (importers/dependents found via `cap explore`) and fix regressions they expose.
6. Finally run the **full suite**: `cap test`. The whole suite must pass (or only pre-existing, documented failures remain).
7. Run `cap lint` and `cap typecheck`, then `cap verify` for the complete pipeline.
8. If any step fails, enter the test-fix loop: fix the smallest cause, re-run the failing target. Count iterations; do not exceed the budget (default 3).
9. When a test needs new fixtures or harness utilities, create them in the existing test conventions (verify with `cap rules check`) and keep them minimal.
10. On success, run `cap diff` to confirm only intended test/code changes, and `cap memory add` any durable testing conventions discovered.

## Verification
- [ ] Targeted tests pass before related tests are run.
- [ ] Related-module tests pass.
- [ ] Full suite passes (or only pre-existing documented failures remain).
- [ ] Test-fix loop iterations <= budget; the loop did not run unbounded.
- [ ] `cap lint` and `cap typecheck` pass.
- [ ] `cap diff` shows only the intended test + implementation changes.
- [ ] New fixtures/utilities (if any) follow existing test conventions (`cap rules check`).

## Failure Handling
- If the test-fix loop hits the iteration budget: stop, restore the last known-good state, and report the blocker with evidence. Do not silently continue looping.
- If a test is flaky (passes/fails intermittently): isolate it, note the flakiness in the report, and do not mask it with retries without evidence.
- If tests pass but the fix seems wrong: re-read the code (`cap show`) and add a stronger assertion; passing tests are only evidence, not proof.
- If the full suite cannot run in this environment: run the maximum subset, state the limitation explicitly, and never claim a full-suite pass.

## Output Format
Final report:
- Tests added/modified (files, cases, and the behavior each covers).
- Run order and results: targeted → related → full suite (pass/fail counts).
- Test-fix loop iterations used vs. budget.
- Verification results (`cap lint`, `cap typecheck`, `cap verify`).
- Any flaky or skipped tests and why.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap test`, `cap verify`, `cap lint`, `cap typecheck`, `cap diff`.
