# Workflow: Security Review

## Purpose

A security-focused review of a change (diff, PR, commit, component) before merge or
release. Lighter than a full audit, but with a strict security lens.

## Method

1. **Scope the change.** Read the diff; identify new/modified entry points, sinks,
   trust boundaries, dependencies, and configuration.
2. **Map the change** to the system: what existing flows does it touch? Which
   components are affected by the same defect class?
3. **Activate skills** by what the change touches:

   - new endpoint → `api/api-surface-analysis.md`, `api/api-input-boundaries.md`
   - auth-related → `authentication/authentication-flow-analysis.md`,
     `session/session-management.md`, `authorization/access-control-analysis.md`
   - data access → `database/query-safety.md`, `authorization/resource-ownership.md`
   - user input → `input-validation/untrusted-input-analysis.md`,
     `injection/*` per sink type
   - files → `files/file-upload-security.md`, `files/path-traversal.md`
   - new dependency → `dependencies/dependency-audit.md`
   - config/secrets → `secrets/secret-management.md`,
     `infrastructure/configuration-security.md`
   - frontend → `frontend/dom-sink-analysis.md`, `web/xss-analysis.md`
4. **Trace** each new data flow from source to sink
   (`../context/data-flow-analysis.md`); verify authorization per operation.
5. **Reproduce** suspicious behavior safely (E3) before classifying.
6. **Review the surrounding context** (not only the diff): the fix must be correct
   in the real codebase, not just in the patch.
7. **Report** per `../templates/security-review.md`, with priorities for
   blocking vs. non-blocking.

## Blocking vs Non-Blocking

- Block merge: CRITICAL/HIGH findings; any auth/authorization bypass; data leaks
  with E3+ evidence.
- Non-blocking: MEDIUM/LOW/INFORMATIONAL items, with owners and deadlines.

## Rules

- Review the change in context; a patch that is locally correct can break
  invariants elsewhere.
- Verify that new tests cover the new behavior and its negative cases
  (`skills/testing/negative-testing.md`).

## Related

- `../skills/code-review/diff-review.md`
- `../skills/code-review/pull-request-review.md`
- `../skills/code-review/security-code-review.md`
- `../checklists/pre-release.md`
