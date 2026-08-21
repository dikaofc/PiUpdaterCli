# Skill: WordPress-to-Webshell Audit

## Purpose

Defensively audit WordPress deployments for chains that typically lead to webshells: upload filters, plugin/theme vulnerabilities, file-write gadgets, and eval filters.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: wordpress, wp, webshell, plugin audit, upload.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Inventory the WordPress install: core version, plugins, themes, must-use plugins; cross-check advisories (wpscan/Wordfence) as triggers only.
2. Audit upload paths: wp_handle_upload, media handlers, plugin upload logic — check file-type validation, MIME checks, and storage location (executable dirs).
3. Find file-write gadgets: update processes writing PHP, admin-ajax actions accepting paths, plugin auto-update flows, eval-style filters (create_function, preg_replace /e, assert).
4. Trace who can reach each gadget (admin-only vs subscriber) and what input controls written content.
5. Check hardening: wp-config permissions, disabled file editing, .htaccess execution rules in uploads, backup exposure.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local reproduction (standalone WordPress sandbox or code trace) showing a reachable write/eval path, with the plugin/theme code cited and advisory status noted.

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

Use a local test app with deliberately vulnerable routes, or browser automation against a sandbox instance you control.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Vulnerable third-party code (plugins/themes) or unsafe upload/eval patterns in custom code reachable at low privilege.

## Impact

Webshell installation → site takeover, defacement, data theft, pivot into hosting infrastructure.

## Remediation

Update core/plugins/themes, remove unused plugins, enforce strict upload validation + non-executable storage, disable file editing, restrict admin access, tested backups.

## Regression Test

Tests asserting uploads cannot be stored as executable content and admin-file-write actions enforce role checks; a scan gate in CI.

## Common False Positives

Known CVEs without a reachable path in the installed versions/configuration; uploads stored with execution denied; admin-only gadgets with strong MFA.

## Related Skills

- file-upload-security.md
- command-injection.md
- dependency-audit.md
- admin-function-protection.md

## References

- Wordfence/WPScan advisories
- OWASP File Upload Cheat Sheet
- CWE-434

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
