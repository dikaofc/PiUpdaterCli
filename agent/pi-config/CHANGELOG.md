# Changelog

All notable changes to this knowledge base are recorded here.

The format follows "Keep a Changelog"; this project does not yet use semantic
versioning for the knowledge base.

## [Unreleased]

### Added (v0.1.0 — initial release)

- Full directory structure: `context/`, `workflows/`, `skills/` (31 categories),
  `checklists/`, `templates/`, `patterns/`, `languages/`, `references/`,
  `tools/`.
- Core operating files: `README.md`, `AGENTS.md`, `SYSTEM_CONTEXT.md`,
  `OPERATING_MODEL.md`, `METHODOLOGY.md`, `SECURITY_BOUNDARIES.md`,
  `QUALITY_STANDARD.md`, `SKILL_INDEX.md`, `SKILL_ROUTER.md`, `GLOSSARY.md`.
- Conceptual models in `context/`: agent role, investigation principles, evidence
  model (E0–E5), confidence model, severity model, false-positive model, secure
  development lifecycle, threat modeling, attack-surface model, trust boundaries,
  data-flow analysis, dependency model, runtime model.
- 13 audit workflows: full-project-audit, quick-audit, deep-audit, security-review,
  bug-hunt, regression-review, incident-debugging, api-audit, auth-audit,
  dependency-audit, configuration-audit, performance-audit, release-readiness.
- 14 checklists: pre-release, authentication, authorization, api, frontend, backend,
  database, infrastructure, dependency, secrets, configuration, logging,
  error-handling, performance, reliability.
- 9 templates including the canonical `skill-template.md`.
- 9 secure-pattern files.
- 16 language-aware analysis files.
- 7 reference files (taxonomies, matrices).
- 250 skill files organized in 31 categories (see `SKILL_INDEX.md`).
- Validation tool `tools/validate_repo.py` (`QUALITY_STANDARD.md`).
