# AGENTS.md — Instructions for AI Agents Using This Repository

This file tells AI coding agents how to behave while using this knowledge base.
It complements the user-level operating model in `OPERATING_MODEL.md`.

## Before You Start an Audit

1. Read `SYSTEM_CONTEXT.md`, `OPERATING_MODEL.md`, and `METHODOLOGY.md` once per
   session (they change rarely).
2. Select the matching workflow from `workflows/` (full-audit, quick-audit,
   api-audit, auth-audit, dependency-audit, ...). Workflows tell you which skills to
   load.
3. Inspect the actual project first: build an architecture map, find entry points,
   trust boundaries, sensitive assets, and tests. Do not assume.
4. Never invent files, functions, endpoints, dependencies, configuration, or
   vulnerabilities. If you cannot find something, mark it `UNKNOWN`.

## During the Investigation

- Activate multiple skills simultaneously when an observation matches several triggers
  (`SKILL_ROUTER.md`). E.g., a user-controlled URL activates `url-validation.md` AND
  `ssrf-analysis.md` AND `network-exposure.md`.
- Follow each skill's Investigation Method step by step. Do not skip to "it's a
  vulnerability" from a pattern match.
- Collect evidence against the evidence model (`context/evidence-model.md`): static →
  data-flow → behavioral → impact → root cause.
- Apply false-positive control before reporting (`context/false-positive-model.md`):
  attempt to disprove every candidate.
- Track authorization server-side; never trust frontend checks, hidden UI, disabled
  buttons, route naming, client-provided roles/ownership/flags.

## When Reporting

- Prioritize: confirmed vulnerabilities, then confirmed correctness bugs, then
  high-confidence risks, then architectural weaknesses, then medium-confidence
  findings needing validation, then low-confidence observations.
- Do not dump hundreds of speculative findings.
- Every finding: severity, confidence, evidence, root cause, impact, fix, regression
  test — using `templates/vulnerability-report.md`.
- Separate observed impact (E4) from projected impact. Mark `UNKNOWN` where evidence
  is missing.
- For dependency findings, run the reachability analysis (`context/dependency-model.md`)
  before rating.

## When Fixing

- Follow the fixing mode in `METHODOLOGY.md`: root cause → minimal fix → security
  test → functional test → regression test → review diff → recheck related paths.
- Do not rewrite whole modules, add dependencies without reason, or change unrelated
  behavior. Do not add client-only security controls.

## Knowledge Base Maintenance

- Adding a skill: copy `templates/skill-template.md`, fill every section, add the
  entry to `SKILL_INDEX.md`, add router mappings in `SKILL_ROUTER.md`, and update
  `CHANGELOG.md`.
- Run `python3 tools/validate_repo.py` before declaring changes complete
  (`QUALITY_STANDARD.md`).
- Keep language-specific guidance in `languages/`; keep patterns in `patterns/`.
  Reference files by filename in backticks.

## Rules of Conduct

- Defensive, authorized testing only. All reproduction happens in environments the
  auditor controls (local, fixtures, mocks, sandboxes).
- No destructive exploitation workflows; no persistence, credential theft, malware,
  or unauthorized access procedures.
- Preserve existing project behavior unless a security or correctness fix requires
  changing it.
- Be honest about uncertainty: `UNKNOWN`, `NOT VERIFIED`, `PROJECTED` are first-class
  markers.
