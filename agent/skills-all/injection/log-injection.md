# Skill: Log Injection

## Purpose

Find log injection: user input written into logs without sanitization, enabling log forgery, log poisoning, and injection into log-analysis pipelines.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: log injection, log forgery, log poisoning, crlf in logs.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find logging statements that include user-controlled data (request params, headers, filenames, usernames).
2. Check whether newlines and control characters are removed before writing.
3. Check downstream consumption: SIEM parsers, grep pipelines, JSON logs, email alerts — is the log content structured or re-executed?
4. Test locally by feeding CR/LF/ISO-2022 payloads (log4j-style poisoning) into a log-write path and inspecting raw log bytes.
5. Check whether logs embed secrets, tokens, or PII (ties into sensitive-error-data).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test showing a crafted value creates a forged log entry or breaks the structured log format, with the logging line cited.

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

Logging user input verbatim without newline/control-character sanitization or structured (JSON) encoding.

## Impact

Log forgery (false audit trails), SIEM rule evasion, potential stored XSS in log viewers, downstream pipeline attacks.

## Remediation

Sanitize CR/LF/control chars, log as structured JSON, truncate long values, never log secrets or raw credentials.

## Regression Test

Tests asserting newline payloads appear escaped/sanitized in raw log output.

## Common False Positives

Loggers that already quote/escape values; logs not consumed by any parser or alerting system.

## Related Skills

- logging-analysis.md
- sensitive-error-data.md
- crlf-injection.md
- security-headers.md

## References

- OWASP Logging Cheat Sheet
- CWE-117 (improper output neutralization for logs)
- CVE-2021-44228 (log4j)

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
