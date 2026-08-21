# Skill: Database Access Control

## Purpose

Audit DB access: least-privilege accounts, connection security, queryable surface, and separation of services.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: database access, db privileges, least privilege.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Map DB connections: accounts, hosts, networks, and which services use which.
2. Check account privileges: least privilege per service (no admin for app), no shared superuser.
3. Check network exposure: DB not publicly reachable, firewall restricted.
4. Check credentials: from secret manager, not committed.
5. Check query surface: stored procedures vs direct table access, column-level sensitivity.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A DB access map (account × privileges × network) cited from config/IaC; any overprivileged or exposed account is a finding.

Minimum bar: **static evidence (E1)** to open a line of inquiry; **behavioral evidence (E3)** or better for a confirmed report. See `context/evidence-model.md`.

## Confidence

Use one of:

- **CONFIRMED** — behavior reproduced and root cause validated (E3+).
- **HIGH CONFIDENCE** — strong static + data-flow evidence, controlled verification pending.
- **MEDIUM CONFIDENCE** — plausible path but some assumptions remain unverified.
- **LOW CONFIDENCE** — theoretical risk; requires validation.
- **FALSE POSITIVE** — disproven or mitigated after analysis.

Confidence is independent of severity (see `context/confidence-model.md`).

## Severity

Assess severity from actual **impact + exploitability + required privileges + interaction + affected scope + data sensitivity** (see `context/severity-model.md`). Do not automatically label this class CRITICAL. A finding must earn its severity from evidence.

Typical range for this skill: LOW–HIGH depending on reachability and data sensitivity.

## Safe Reproduction

Reproduce query/transaction behavior against a local test database with transaction rollbacks; use synthetic data.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Single powerful account shared across services or default open network rules.

## Impact

SQLi compromise escalates to full DB admin; data breach via exposed DB.

## Remediation

Per-service least-privilege accounts, network isolation, encrypted connections, audit who can change schema.

## Regression Test

IaC tests asserting no public DB exposure and per-service limited grants.

## Common False Positives

Local dev databases using admin accounts (documented, non-prod).

## Related Skills

- query-safety.md
- sql-injection.md
- network-exposure.md
- backup-security.md

## References

- OWASP Database Security
- CWE-250 (execution with unnecessary privileges)

## Review Checklist

- [ ] Entry point identified
- [ ] Trust boundary identified
- [ ] Data flow understood
- [ ] Validation checked
- [ ] Authorization checked
- [ ] Runtime behavior verified
- [ ] Evidence collected (E1–E5 level recorded)
- [ ] Severity assigned (impact-based)
- [ ] Confidence assigned (separate from severity)
- [ ] Root cause identified
- [ ] Remediation proposed
- [ ] Regression test proposed
