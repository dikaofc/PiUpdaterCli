# Skill: LDAP Injection

## Purpose

Find LDAP query injection: user input embedded in LDAP filters (search filters, bind DNs) without escaping.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: ldap injection, ldap filter, directory injection.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find LDAP operations: search filters, base DN construction, bind with dynamic DN (username/password).
2. Trace user input into filter strings and DN strings.
3. Check escaping of RFC 4515 metacharacters ( ( ) * \ NUL ) in filters.
4. Test locally against an LDAP test server (ApacheDS/OpenLDAP container) with benign filter fragments.
5. Verify whether bind distinguishes "user not found" vs "wrong password" (enable account enumeration tie-in).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local LDAP test showing a crafted filter value changes the result set (or an escaped-value test failing), with the filter construction line cited.

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

User input concatenated into LDAP filters/DNs without RFC 4515 escaping.

## Impact

Filter bypass (return unauthorized entries), authentication bypass for bind-based login.

## Remediation

Use LDAP libraries with safe filter builders (escaping functions), whitelist DN components, and avoid dynamic DNs.

## Regression Test

Tests sending ( ) * \ NUL characters in each LDAP-bound field, asserting literal handling or rejection.

## Common False Positives

Libraries that auto-escape filter values; LDAP usage with hardcoded filters only.

## Related Skills

- sql-injection.md
- authentication-flow-analysis.md
- account-enumeration.md

## References

- OWASP LDAP Injection
- CWE-90 (improper neutralization of special elements in an LDAP query)

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
