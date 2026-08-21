---
name: matrix-test-check
description: Review the test matrix — coverage gaps, integration vs unit mix, missing edge cases.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: testing
  tags: [tests, coverage, matrix, edge-cases]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Matrix-Based Test Check

## Objective
Review the test suite as a coverage matrix: feature × behavior × layer (unit vs
integration). Identify gaps — untested dimensions, pure-integration suites that
never test units, missing edge/error cases — and deliver a matrix with prioritized
test additions backed by facts, then add the highest-value gap tests.

## Preconditions
- Repository is indexed (`cap index --refresh`) and the test layout is known or discoverable via `cap explore`.
- The feature surface under review is named (module, endpoints, or library functions).

## Workflow
1. Run `cap status` and `cap repo` to detect the test runner and coverage tool.
2. Enumerate the suite: `cap search "\.(test|spec)\."` for test files; note their location relative to source (`test/` vs colocated).
3. Enumerate the feature surface: `cap explore <feature>` for source files and exported functions/branches.
4. Run coverage facts if available: execute the suite (`cap test`) with the project's coverage tool; read the report region with `cap show <coverage-file>`.
5. Build the matrix: rows = source modules/functions, columns = behaviors (happy path, error path, edge cases, boundaries) and layers (unit/integration). Mark each cell COVERED, PARTIAL, or MISSING from test-file listings (`cap show <test-file>`) and coverage output.
6. Classify suite-level issues:
   - OVER-INTEGRATION — tests go through the full stack when the unit is testable alone.
   - UNDER-UNIT — core branches have no direct tests.
   - EDGE GAPS — empty inputs, max bounds, concurrency, idempotency, auth failures untested.
   - FRAGILE — tests coupled to implementation details (snapshot-heavy, timing).
7. Run `cap risk --json` and pick the top MISSING cells on hot paths; cross-check with `cap explore <symbol>` that the branch is reachable.
8. Add the gap tests (e.g., an error-path case for the highest-risk missing cell) following existing conventions (`cap show` an existing test file for the pattern).
9. Verify: `cap test --target <new-test>` then full `cap test`, `cap lint`, `cap typecheck`, `cap verify`; `cap rollback --task <id>` on regression.
10. `cap memory add` the matrix results (confirmed gaps) so future changes fill them.

## Verification
- [ ] Matrix computed from actual test files, not guesses; every MISSING cell has evidence.
- [ ] `cap test` passes after adding tests; new tests fail for the right reason if reverted (spot-check one).
- [ ] New tests follow existing conventions (`cap rules check <file>`).
- [ ] OVER-INTEGRATION / FRAGILE issues reported even if not fixed.
- [ ] `cap diff` shows only test-file changes.

## Failure Handling
- If the coverage tool is unavailable: fall back to manual matrix from `cap show`/`cap search` and state coverage numbers were not machine-measured.
- If a MISSING cell is untestable in this environment (needs an external service): mark it BLOCKED-EXTERNAL with the required fixture/URL, do not mock the whole world.
- If `cap test` fails after adding a test: the new test exposes the gap — fix the source minimally or revert the test with `cap rollback --task <id>` and report the conflict.

## Output Format
- Matrix: module × behavior × layer cells (COVERED/PARTIAL/MISSING).
- Suite-level findings (OVER-INTEGRATION, UNDER-UNIT, EDGE GAPS, FRAGILE) with file:line evidence.
- Tests added (file, case, the gap it covers).
- Verification results (`cap test`, `cap lint`, `cap verify`).

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap search`, `cap explore`, `cap test`, `cap verify`, `cap risk`.
- CONTRACT.md §3 Test rules (tests include the error path).