# Workflow: Full Project Audit

## Purpose

Complete end-to-end audit of a project: security vulnerabilities and correctness
bugs, with evidence, severity, remediation, and regression tests. This is the
deepest workflow; use `quick-audit.md` for fast triage and `deep-audit.md` for
targeted deep dives.

## Phase 0 — Preparation

1. Confirm authorization and scope (in-scope components, environments, data).
2. Gather: repository, manifests/lockfiles, configs, CI/CD definitions, runbooks,
   tests, API specs, known issues.
3. Read `../OPERATING_MODEL.md` and `../METHODOLOGY.md`.

## Phase 1 — Discover & Map

1. Inventory repository structure: `repository-structure-analysis.md`.
2. Map architecture: components, layers, data stores, integrations.
3. Enumerate entry points: `entrypoint-discovery.md`, `endpoint-discovery.md`.
4. Identify assets and trust boundaries: `attack-surface-mapping.md`,
   `trust-boundary-discovery.md`, `../context/threat-modeling.md`.
5. Inventory dependencies: `dependency-discovery.md`, `../context/dependency-model.md`.
6. Inventory configuration and secrets surface: `configuration-discovery.md`,
   `secret-surface-discovery.md`.

## Phase 2 — Model

1. Build the threat model (`../context/threat-modeling.md`, `../templates/threat-model.md`).
2. Rank attack paths by impact × likelihood.

## Phase 3 — Trace & Verify (per ranked path)

For each path, activate the mapped skills via `../SKILL_ROUTER.md` and apply the
skill investigation method. Cover at minimum:

- input validation: `input-validation/untrusted-input-analysis.md`
- injection: `injection/*` (SQL, NoSQL, command, template, code, expression)
- web: `web/*` (XSS, CSRF, CORS, clickjacking, open-redirect, headers, CSP)
- files/parsers: `files/*` (SSRF, path traversal, upload, deserialization, XML)
- API: `api/*` (BOLA, BFLA, rate limit, pagination, idempotency, GraphQL, WS)
- auth: `authentication/*`, `session/*` (flows, password, reset, MFA, JWT, OAuth)
- authorization: `authorization/*` (IDOR, privesc, role, ownership)
- business logic: `business-logic/*` (state machines, pricing, replay, quota)
- concurrency: `concurrency/*` (races, TOCTOU, duplicates)
- errors: `errors/*` (stack traces, debug mode, sensitive data, timeouts)
- crypto/secrets: `cryptography/*`, `secrets/*`
- database: `database/*` (access control, transactions, ORM)
- dependencies: `dependencies/*`, `supply-chain/*`
- infrastructure/cloud: `infrastructure/*`, `cloud/*`, `containers/*`
- frontend/backend: `frontend/*`, `backend/*`
- performance/reliability: `performance/*`, `reliability` concerns

## Phase 4 — Classify & Validate

1. Apply false-positive control (`../context/false-positive-model.md`).
2. Reproduce suspicious behavior safely (E3) and confirm root cause (E5).
3. Assign severity (`../context/severity-model.md`) and confidence
   (`../context/confidence-model.md`).

## Phase 5 — Fix & Test

1. Apply fixing mode (`../METHODOLOGY.md`): minimal fix, security test, functional
   test, regression test, review diff, recheck related paths.
2. Run the project's test suite, type checks, and linters around the changes.

## Phase 6 — Report

1. Write findings per `../templates/vulnerability-report.md` (and
   `../templates/bug-report.md` for non-security bugs).
2. Produce `../templates/audit-summary.md` with counts, top risks, and priorities.
3. Prioritize output per AI Response Rules in `../METHODOLOGY.md`.

## Entry / Exit Criteria

- **Entry:** authorization confirmed; scope defined.
- **Exit:** all in-scope entry points covered or waived; every finding has
  evidence level, severity, confidence, root cause, remediation, regression test.

## Related

- `../workflows/deep-audit.md`, `../workflows/quick-audit.md`
- `../workflows/security-review.md`
- `../SKILL_ROUTER.md`
