# Workflow: Deep Audit

## Purpose

Targeted, exhaustive investigation of one surface, subsystem, or candidate finding.
Use when a full audit flagged an area, when a quick audit found something big, or
when a specific surface is high-risk (payments, auth, multi-tenancy, parsers).

## Method

1. **Define the target** precisely: subsystem, entry-point set, or candidate
   finding (e.g., "all endpoints handling refunds", "the multipart upload path",
   "the OAuth callback handler").
2. **Bound the surface** within the target: every handler, branch, state, and data
   path that touches the target. Everything else is out of scope (documented).
3. **Trace exhaustively.** For every entry into the target, build the full data
   flow (`../context/data-flow-analysis.md`). Cover:
   - happy path AND every error path
   - every state transition
   - concurrent access patterns
   - retry/idempotency behavior
4. **Activate all relevant skills** for the target via `../SKILL_ROUTER.md`
   (e.g., refunds: `business-logic/price-integrity.md`,
   `business-logic/duplicate-operation.md`, `concurrency/race-condition.md`,
   `authorization/resource-ownership.md`).
5. **Verify with controlled reproductions** (E3+): unit/integration tests, local
   fixtures, mocks. Confirm root cause (E5).
6. **Check adjacent paths** for the same defect class (pattern re-use, copied
   code, similar endpoints).
7. **Fix and add regression tests** for confirmed findings (fixing mode,
   `../METHODOLOGY.md`).

## Output

- Per-finding reports (`../templates/vulnerability-report.md` /
  `../templates/bug-report.md`).
- A coverage statement: which paths in the target were exhaustively traced, which
  were waived, and why.

## Related

- `../workflows/full-project-audit.md`, `../workflows/quick-audit.md`
- `../context/data-flow-analysis.md`
- `../skills/testing/reproduction-test-design.md`
