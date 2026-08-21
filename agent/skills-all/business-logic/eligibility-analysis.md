# Skill: Eligibility Analysis

## Purpose

Audit eligibility gates: discounts, promotions, trials, age/region checks, and invite programs.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: eligibility, promotion abuse, coupon abuse, trial.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. List eligibility rules: promo codes, trial eligibility, student/discount programs, referral rewards, age/geo restrictions.
2. Check each gate: computed server-side from authoritative data?
3. Check abuse paths: repeated trials (new identity), coupon stacking, referral self-invite, geo spoofing.
4. Check one-time semantics: claims enforced by unique constraints?
5. Test locally: attempt each abuse path against a disposable account.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test showing an eligibility gate bypass (e.g., coupon reuse or trial re-farm), with the gate code cited.

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

Understand the intended rule from specs/tests first, then demonstrate violations with a local flow and scripted requests.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Eligibility computed from client input or non-authoritative identity.

## Impact

Promotion/trial/referral abuse, revenue loss, fraud.

## Remediation

Server-side eligibility from authoritative attributes, unique claim constraints, velocity checks on new identities, anomaly detection.

## Regression Test

Abuse-path tests per eligibility rule with fresh accounts.

## Common False Positives

Programs explicitly allowing one-use-per-IP/device (documented); low-value promos with accepted abuse risk.

## Related Skills

- quota-bypass-analysis.md
- account-creation-abuse.md
- price-integrity.md

## References

- OWASP Business Logic
- CWE-840

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
