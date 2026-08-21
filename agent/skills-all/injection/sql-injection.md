# Skill: SQL Injection

## Purpose

Find SQL injection: user input concatenated into SQL statements or mishandled by ORMs/query builders, in SQL and NoSQL-adjacent contexts.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: sql injection, sqli, query concatenation.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find raw SQL sinks: string queries, stored procedures invoked with concatenation, query builders with raw fragments, "execute/query" calls.
2. Trace user input into those sinks (body, query, params, headers, file contents, queue messages).
3. Check parameterization: placeholders (?) or named params used for every value, or is input interpolated?
4. Check ORM misuse: raw()/rawQuery/execute(sql, args) with string concat, dangerouslySetInnerHTML equivalents in query land, order-by/column-name injection.
5. Verify with a local test DB using benign probes (e.g., quote injection causing an SQL error in a test transaction rolled back).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A data-flow trace into the SQL sink plus a behavioral test (error timing, benign quoting) in a local DB showing unexpected SQL interpretation. Never exploit against live systems.

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

Use local databases (SQLite/Postgres test instance), local shell wrappers, or mock sinks. Verify behavior changes with benign probes; never against live third-party systems.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Input concatenated into SQL syntax or a value inserted into a position the driver does not parameterize.

## Impact

Data exfiltration, authentication bypass, data tampering, DoS depending on DB privileges.

## Remediation

Parameterized queries for all values; allowlists for identifiers (columns/order-by); least-privilege DB accounts.

## Regression Test

Unit/integration tests sending quote/comment payloads to every query entry point, asserting parameterized handling.

## Common False Positives

ORM queries that look raw but are parameterized via placeholders; input that is validated to a safe charset before the query; DB errors in tests without proven user control.

## Related Skills

- query-safety.md
- orm-security.md
- database-access-control.md
- nosql-injection.md

## References

- OWASP SQL Injection Prevention Cheat Sheet
- CWE-89 (SQL injection)
- PortSwigger SQLi cheat sheet

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
