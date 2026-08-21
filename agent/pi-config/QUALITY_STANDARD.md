# Quality Standard

This standard applies to every artifact in this repository: skill files, workflows,
reports, and fixes.

## Quality of Findings

A finding is reportable only when it satisfies ALL of:

1. **Traceable** — a concrete source → sink path is documented (or explicitly marked
   `UNKNOWN` where the trace is incomplete).
2. **Evidence-backed** — evidence level E2 minimum for any report; HIGH severity
   requires E3+ (see `context/evidence-model.md`).
3. **Root-cause oriented** — the underlying defect is identified, not just the symptom.
4. **Impact-aware** — realistic impact stated with observed vs. projected clearly
   separated.
5. **Falsifiable** — the report states what test/observation would disprove it.
6. **Remediated** — at least one concrete fix plus a regression test proposal.

## Quality of Skill Files

Every file under `skills/` MUST:

- follow `templates/skill-template.md` section-for-section, in order
- be technically specific: WHAT, WHY, WHERE, HOW TO VERIFY, WHAT EVIDENCE COUNTS,
  WHAT FALSE POSITIVES LOOK LIKE, HOW TO FIX IT, HOW TO TEST THE FIX
- contain no empty sections, no `TODO`, no placeholder text
- reference only files that exist in this repository (by filename)
- contain no fabricated CVEs, CWE numbers, URLs, or vulnerability claims
- contain no destructive testing instructions, no credential material, no hardcoded
  secrets

## Quality of Language

- Prefer concrete API names and code-level detail over generic advice.
- Mark uncertainty explicitly: `UNKNOWN`, `NOT VERIFIED`, `PROJECTED`.
- Never state "check for security issues" or "use best practices" without specifying
  what to check and how.
- Be concise: every sentence should carry information.

## Quality of Reports

Reports produced for a real audit must include: classification (type/severity/
confidence), affected component, root cause, evidence with artifacts, data flow,
impact, safe reproduction, remediation, regression test, related components, and
false-positive considerations (see `templates/vulnerability-report.md`).

## Internal Consistency Rules

- Confidence and severity are always recorded separately.
- Evidence level is always recorded with the confidence.
- Every confirmed bug references a proposed regression test.
- Every HIGH/CRITICAL finding references the boundary it crosses.
- References to skills use existing filenames only.

## Validation

The repository ships with a validation script (`tools/validate_repo.py`) that checks:
- required directories and file counts
- required section headings in every skill file
- no empty files, no placeholder tokens
- duplicate skill names
- internal filename references resolve
- no banned content (secrets patterns, destructive instructions)

Run it before declaring the knowledge base complete:
`python3 tools/validate_repo.py`

## Related

- `context/evidence-model.md`, `context/confidence-model.md`
- `context/severity-model.md`, `context/false-positive-model.md`
- `templates/skill-template.md`
