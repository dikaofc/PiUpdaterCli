# Workflow: Quick Audit

## Purpose

Fast triage of a project under a limited time budget. Finds the highest-value
issues quickly and produces a prioritized list; it is NOT a substitute for
`full-project-audit.md` or `deep-audit.md`.

## Time-Boxed Phases

### 1. Surface Scan (15% of budget)

- `repository-structure-analysis.md` — structure, manifests, configs.
- `entrypoint-discovery.md` — list all handlers/routes.
- `dependency-discovery.md` + `../context/dependency-model.md` — known critical
  dependency issues (reachability-checked).
- `secret-surface-discovery.md` — committed secrets scan.

### 2. High-Value Targets (60% of budget)

Focus on the highest-risk surfaces:

- `authentication/authentication-flow-analysis.md` and `authorization/access-control-analysis.md`
  — auth bypasses and IDOR on every handler (fast, high yield).
- `input-validation/untrusted-input-analysis.md` + `injection/sql-injection.md` +
  `injection/command-injection.md` + `files/path-traversal.md` — classic injection
  sinks.
- `web/xss-analysis.md` + `web/csrf-analysis.md` — web UI exposure.
- `api/bola-analysis.md` + `api/api-authorization.md` — API object/function-level
  access.
- `business-logic/duplicate-operation.md` + `errors/stack-trace-exposure.md` —
  quick correctness/leak wins.
- `configuration/` (config): `infrastructure/configuration-security.md` + debug
  modes (`errors/debug-mode-analysis.md`).

### 3. Validate (20% of budget)

- Reproduce the top 3–5 candidates safely (E3).
- False-positive control on everything (`../context/false-positive-model.md`).
- Assign severity/confidence; mark unvalidated items as MEDIUM/LOW confidence.

### 4. Report (5% of budget)

- `../templates/audit-summary.md`: top risks, counts by severity, explicit list of
  what was NOT covered (so the reader knows residual risk).

## Rules

- Never report E0/E1-only items as vulnerabilities; report them as notes.
- If a quick finding looks HIGH+, escalate to `deep-audit.md` for that path before
  reporting.
- State the time-box and the coverage gaps honestly in the summary.

## Related

- `../workflows/full-project-audit.md`, `../workflows/deep-audit.md`
- `../SKILL_ROUTER.md`
- `../context/false-positive-model.md`
