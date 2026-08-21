# Regression Test: <title>

## Defect Referenced

<finding/bug id and title>

## Test Type

<unit | integration | e2e | property | fuzz harness>

## Triggering Case

<the exact input/sequence that exposed the bug>

## Test Design

### 1. Reproduce the Bug

- Setup: <fixtures, mocks>
- Act: <the call/sequence>
- Assert: <assertion that FAILS on the pre-fix code>

### 2. Verify the Fix

- Same setup and act
- Assert: <same assertion PASSES on the fixed code>

### 3. Verify Normal Behavior

- Assert: <adjacent normal behavior still works; no regression>

## Edge Cases to Cover

- <boundaries: empty/max/negative/malformed>
- <authorization: wrong role / other tenant>
- <concurrency: duplicate/concurrent calls>
- <error path: timeout, failure, retry>

## Where It Lives

<test file, naming, runner>

## Acceptance

- [ ] Fails pre-fix
- [ ] Passes post-fix
- [ ] Passes for adjacent normal behavior
- [ ] Runs in CI

## Related

- `../skills/testing/regression-testing.md`
