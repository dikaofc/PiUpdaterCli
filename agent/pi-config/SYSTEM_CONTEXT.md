# System Context

## What This Is

`ultra-bug-hunter` is a modular Markdown knowledge and skills system for an AI coding
agent whose primary role is **defensive cyber bug hunting, software debugging, code
review, and security engineering**. It is a reference brain: methodology, skill
files, checklists, templates, patterns, and taxonomies that an agent (or a human
reviewer) loads on demand.

It is **not** an exploit tool. Every investigation procedure in this repository is
authorized, defensive, and reproducible against environments the auditor controls.

## Runtime Context

- The knowledge base lives in a plain directory tree of Markdown files.
- An AI coding agent (e.g., a CLI coding assistant) can read files on demand, follow
  `SKILL_ROUTER.md` to activate the right skills, and consult `templates/` when
  writing reports.
- No code in this repository executes anything; `tools/validate_repo.py` is the only
  script, and it only validates the Markdown itself.

## How the Pieces Fit

```
README.md            — purpose, architecture, usage
AGENTS.md            — how AI agents should operate while using this system
SYSTEM_CONTEXT.md    — this file
OPERATING_MODEL.md   — the agent's standing behavior during an audit
METHODOLOGY.md       — the global investigation sequence and analysis rules
SECURITY_BOUNDARIES.md — trust boundaries and boundary enforcement rules
QUALITY_STANDARD.md  — quality gates for findings, files, and reports
SKILL_INDEX.md       — catalog of every skill
SKILL_ROUTER.md      — observation → skill activation mapping
GLOSSARY.md          — shared vocabulary
context/             — conceptual models (evidence, confidence, severity, FP, ...)
workflows/           — end-to-end audit procedures that compose skills
skills/              — 250 specialized skills in 31 categories
checklists/          — quick verification checklists per concern
templates/           — report and skill authoring templates
patterns/            — secure design/implementation patterns
languages/           — language-aware analysis guides
references/          — taxonomies and matrices
tools/               — validation tooling
```

## Usage Flow for an AI Agent

1. Read `AGENTS.md` and `OPERATING_MODEL.md`.
2. On receiving an audit task, run the matching workflow in `workflows/`.
3. When an observation matches a trigger, activate the mapped skills via
   `SKILL_ROUTER.md`; consult `SKILL_INDEX.md` for the catalog.
4. Follow the investigation method inside each skill; collect evidence per
   `context/evidence-model.md`; classify per `context/confidence-model.md` and
   `context/severity-model.md`; apply false-positive control per
   `context/false-positive-model.md`.
5. Write findings using `templates/vulnerability-report.md`; propose fixes and
   regression tests per `QUALITY_STANDARD.md`.
6. Record outcomes in `CHANGELOG.md` when the knowledge base itself changes.

## Constraints

- Source-code evidence is preferred over assumptions; unknown information is marked
  `UNKNOWN`.
- No destructive workflows, no unauthorized access procedures, no persistence or
  credential-theft content.
- Every confirmed bug must result in a proposed regression test.
