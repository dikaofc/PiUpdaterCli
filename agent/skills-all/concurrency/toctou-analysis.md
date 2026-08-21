# Skill: TOCTOU Analysis

## Purpose

Detect and validate Time-Of-Check To Time-Of-Use races: checking a condition
(file existence, permission, state) then using the resource later, with the
state changing in between.

## Scope

- Included: file check-then-open, permission check-then-act, state check-then-
  update, symlink swaps.
- Excluded: general races (`race-condition.md`).
- Layers: filesystem + logic.

## Trigger Conditions

- `if exists` then open patterns.
- Permission checks before operations.
- Temp file handling.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: check-then-use sequences.
2. Identify trust boundaries: N/A.
3. Track relevant data: checked state vs used state.
4. Identify validation: atomic operations.
5. Identify security-sensitive operations: file/permission actions.
6. Inspect authorization: check bypass.
7. Inspect error handling: N/A.
8. Inspect tests: race-injection tests.
9. Determine exploitability or correctness impact: TOCTOU.
10. Validate the finding: race-injection tests (local, controlled).

## Evidence Requirements

- E1: check/use code.
- E2: window identified.
- E3: test demonstrating state change between check and use.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM–HIGH depending on the resource.

## Safe Reproduction

- Local tests swapping files/states between check and use in a sandbox.

## Root Cause

- Non-atomic check+use; predictable resource paths.

## Impact

- File overwrite/read abuse, permission bypass, symlink attacks.

## Remediation

- Atomic operations (open with flags, stat+open combined); locks; safe temp
  paths.

## Regression Test

- Tests asserting atomic behavior or race-injection resistance.

## Common False Positives

- Single-process sequential flows without attacker interleaving (verify).

## Related Skills

- `race-condition.md`
- `../files/path-traversal.md`
- `../filesystem-permissions` (see `../infrastructure/filesystem-permissions.md`)

## Review Checklist

- [ ] Entry point identified
- [ ] Trust boundary identified
- [ ] Data flow understood
- [ ] Validation checked
- [ ] Authorization checked
- [ ] Runtime behavior verified
- [ ] Evidence collected
- [ ] Severity assigned
- [ ] Root cause identified
- [ ] Remediation proposed
- [ ] Regression test proposed

## References

- OWASP / CWE TOCTOU guidance
- CWE-367
