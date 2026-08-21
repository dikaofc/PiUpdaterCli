# Skill: Entry Point Discovery

## Purpose

Find every way external input reaches the system: HTTP routes, RPCs, resolvers, CLI args, queue consumers, cron, file processors, auth callbacks, webhooks.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: entry point, routes, handlers, inputs.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Grep for route registration (Express/Flask/Django/Spring/Rails/Gin/axum/ASP.NET attributes, etc.) and framework routers.
2. List CLI command parsers (argparse, cobra, clap, commander) and their subcommands.
3. Find queue/task consumers (Celery, Sidekiq, BullMQ, Kafka consumers, workers).
4. Find scheduled jobs (cron, APScheduler, Cloud Scheduler, GitHub Actions schedules).
5. Find webhook endpoints and auth callbacks (OAuth redirect, SSO assertion consumers).
6. Find file intake: upload handlers, email ingestion, batch import scripts.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A numbered list of entry points, each with source file, input fields, auth requirement (from code/config), and data-flow start.

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

Use only repositories/projects you own or have written authorization to inspect. Run discovery against local clones and localhost services; never against third-party systems.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

N/A — discovery skill.

## Impact

Missed entry points are the classic blind spot in security reviews.

## Remediation

Maintain an API/entry-point manifest; add routes only through centralized registration.

## Regression Test

A test asserting every handler is registered through a central registry or documented in a manifest.

## Common False Positives

Registering library-internal routes as app entry points; ignoring entry points behind feature flags.

## Related Skills

- endpoint-discovery.md
- project-surface-mapping.md
- backend-entrypoint-analysis.md

## References

- OWASP ASVS V1 (architecture, inventory)
- CWE-1007

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
