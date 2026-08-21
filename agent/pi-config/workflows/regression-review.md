# Workflow: Regression Review

## Purpose

Verify that a fix actually resolves the defect, did not introduce regressions, and
left the codebase in a reviewable, tested state. Used after any remediation.

## Method

### 1. Restate the Finding

Re-read the original finding: expected behavior, reproduction, root cause,
proposed fix.

### 2. Verify the Fix

- Does the fix address the root cause (not just the symptom)?
- Re-run the reproduction: the failing test now passes (E5 confirmation).
- Is the fix minimal? No unrelated refactors, no new dependencies, no behavior
  changes outside the defect.

### 3. Check for Regressions

- Run the full relevant test suite (unit + integration for the touched area).
- Run type checks and linters.
- Review the diff for side effects on adjacent paths (`skills/code-review/diff-review.md`).
- Manually re-trace related code paths that share the same pattern
  (`skills/reporting/regression-risk-analysis.md`).

### 4. Regression Tests

- Confirm the regression test fails on the old code and passes on the new code.
- Confirm the test also asserts normal behavior still works
  (`skills/testing/regression-testing.md`).
- Add tests for edge cases the fix might miss (boundaries, nulls, concurrency,
  error paths) if the fix touches those.

### 5. Sign Off

Per finding: `VERIFIED FIXED`, `PARTIALLY FIXED`, or `NOT FIXED`, with evidence for
each. Reopen the finding if not fixed.

## Entry / Exit Criteria

- **Entry:** a fix exists for a confirmed finding.
- **Exit:** fix verified, no regressions, regression tests in place, sign-off
  recorded.

## Related

- `../skills/testing/regression-testing.md`
- `../skills/code-review/diff-review.md`
- `../skills/reporting/regression-risk-analysis.md`
- `../templates/regression-test.md`
