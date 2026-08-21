# Skill: Password Policy

## Purpose

Review password policies against current guidance (length > complexity, no composition rules, breach checks) and enforcement points.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: password policy, password strength, breach list.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find the policy implementation: minimum length, composition rules, maximum length, character classes, password reuse.
2. Compare against NIST SP 800-63B guidance: length-first, allow long passphrases, no arbitrary composition or rotation.
3. Check breach-list checking (haveibeenpwned-style) at registration/reset.
4. Check whether the same password is allowed on account changes without re-auth, and whether policy applies to all credential types.
5. Test locally: register and reset with boundary passwords; observe acceptance/rejection.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- The policy code/config cited plus behavioral tests of boundary passwords (min, max, unicode, spaces).

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

Test flows against a local auth service with disposable accounts; never brute-force real accounts.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Outdated composition-based policy or missing enforcement at one credential path.

## Impact

Weak passwords enabling account takeover; usability-driven poor practices.

## Remediation

Length-based policy (min 12, max 64+), no composition requirements, breach-list checks, permit spaces/unicode, enforce at every credential path.

## Regression Test

Tests asserting min/max boundaries and breach-list rejection across registration/reset/change.

## Common False Positives

Documentation describing a policy not enforced in code (check enforcement); policies applied only to web (not API) credential setting.

## Related Skills

- password-storage.md
- credential-stuffing-defense.md
- bruteforce-defense.md
- password-reset.md

## References

- NIST SP 800-63B
- OWASP Authentication Cheat Sheet
- CWE-521 (weak password requirements)

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
