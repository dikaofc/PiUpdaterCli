# Skill: Server Config Review

## Purpose

Review server/runtime configuration: directory listing, default pages, verbose errors, and unnecessary modules.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: server config, directory listing, default page, enabled modules.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find web-server/application config: index pages, static file serving, rewrite rules.
2. Check directory listing enabled on sensitive directories.
3. Check default/example pages and leftover installers (phpinfo, wp-config samples).
4. Check enabled modules/features unused (dangerous modules, CGI).
5. Check error/log config: access logs with sensitive query data, debug verbosity.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- Config review notes with a directory-listing/default-page demonstration on a staged instance.

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

Audit configuration files, IaC templates, and local container setups; never scan other networks without authorization.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Default server packages shipped complete with listing and sample files.

## Impact

Source/config disclosure, dot-file leakage, attack surface expansion.

## Remediation

Disable listing, remove sample files, minimal module set, hardened log policies.

## Regression Test

CI tests asserting no listing/sample files after deploy.

## Common False Positives

Non-sensitive static hosting where listing is intended (public assets).

## Related Skills

- sensitive-data-exposure.md
- network-exposure.md
- source-map-exposure.md

## References

- CIS Benchmarks
- CWE-538 (insertion of sensitive info into exfiltrated files)

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
