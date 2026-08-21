# Secure Development Lifecycle

How this knowledge base plugs into a Secure Development Lifecycle (SDL). Every SDL
phase maps to concrete artifacts here, so an agent can perform the right activity at
the right time.

## Phases

### 1. Requirements & Design

- Threat modeling: `context/threat-modeling.md`, `templates/threat-model.md`.
- Attack-surface and trust-boundary definition:
  `context/attack-surface-model.md`, `SECURITY_BOUNDARIES.md`.
- Security requirements derived from data sensitivity and threat model.

### 2. Implementation

- Secure patterns: `patterns/*` (auth, authorization, API, database, file handling,
  logging, configuration, secrets, error handling).
- Language-specific pitfalls: `languages/*`.
- Continuous code review: `skills/code-review/*`.

### 3. Verification (Pre-Merge)

- Security code review: `skills/code-review/security-code-review.md`,
  `workflows/security-review.md`.
- Diff and PR review: `skills/code-review/diff-review.md`,
  `skills/code-review/pull-request-review.md`.
- Negative and boundary testing: `skills/testing/negative-testing.md`,
  `skills/testing/boundary-testing.md`.
- Static analysis and taint review: `skills/static-analysis/*`.

### 4. Verification (Pre-Release)

- Deep audit: `workflows/deep-audit.md`, `workflows/full-project-audit.md`.
- API audit: `workflows/api-audit.md`; auth audit: `workflows/auth-audit.md`.
- Dependency audit: `workflows/dependency-audit.md`; configuration audit:
  `workflows/configuration-audit.md`.
- Pre-release checklist: `checklists/pre-release.md`,
  `workflows/release-readiness.md`.

### 5. Operations

- Incident debugging: `workflows/incident-debugging.md`.
- Runtime/observability review: `skills/observability/*`.
- Logging and audit-trail correctness: `skills/observability/audit-trail-analysis.md`.

### 6. Response & Recovery

- Root-cause analysis: `templates/root-cause-analysis.md`.
- Fixing mode and regression tests: `METHODOLOGY.md` (Fixing Mode),
  `skills/testing/regression-testing.md`.
- False-positive review after fixes: `skills/reporting/false-positive-analysis.md`.

## Lifecycle Rules

1. Every release passes the pre-release checklist
   (`checklists/pre-release.md`) or documents waivers.
2. Every confirmed defect produces a regression test before the fix merges.
3. Threat models are updated when architecture or trust boundaries change.
4. Dependency audit runs on every dependency change
   (`workflows/dependency-audit.md`).
5. High/CRITICAL findings are remediated before release; MEDIUM findings are
   scheduled; LOW/INFORMATIONAL are tracked.

## Related

- `../workflows/release-readiness.md`
- `../checklists/pre-release.md`
- `../patterns/secure-configuration.md`
- `../skills/reporting/security-reporting.md`
