# CVE ENGINE SUMMARY

**ULTRA CVE INTELLIGENCE ENGINE** — build report for the CVE intelligence and
vulnerability-analysis subsystem of ULTRA BUG HUNTER.

- **Date:** 2025 (session build)
- **Location:** `ultra-bug-hunter/cve/`
- **Status:** complete and validated

## 1. What was built

A defensive, evidence-based CVE intelligence engine layered on the existing
ULTRA BUG HUNTER knowledge base. It converts raw CVE/advisory data into
prioritized, reachability-aware findings about a specific project.

**Golden rule enforced throughout:**

> "CVE exists" ≠ "project is vulnerable". A CVE in a lockfile is static
> evidence (E1); vulnerability requires applicable + reachable + deployed.

## 2. Inventory

| Component | Count |
|---|---|
| CVE skills | **95** (9 areas) |
| — discovery | 12 |
| — ingestion | 21 |
| — dependency mapping | 4 |
| — applicability | 11 |
| — reachability | 8 |
| — triage | 12 |
| — validation | 8 |
| — remediation | 7 |
| — correlation | 12 |
| Root docs (`cve/*.md`) | 9 (README, CVE_INDEX, CVE_SCHEMA, CVE_ROUTER, CVE_WORKFLOW, CVE_TRIAGE, CVE_VALIDATION, CVE_REMEDIATION, CVE_FALSE_POSITIVES) |
| JSON schemas | 5 (cve, cpe, cvss, advisory, package) |
| Source docs (`cve/sources/`) | 7 (priority + vendor, CVE.org, NVD, CISA KEV, OSV, GitHub) |
| Report template | 1 (`cve/templates/cve-report.md`) |
| Data directories with placeholders | 26 (databases 5, indexes 8, mappings 5, advisories 4, vulnerability-data 4) |
| Generator + data parts | `cve/_build/cve-gen.js` + 12 data parts |
| **Total files** | **156** |

## 3. Core design decisions

1. **Standard reachability taxonomy** with 6 classes:
   `DIRECTLY_REACHABLE`, `TRANSITIVELY_REACHABLE`, `PRESENT_BUT_UNUSED`,
   `CONDITIONALLY_REACHABLE`, `UNREACHABLE`, `UNKNOWN` — every candidate must be
   classified before any exploitability claim.
2. **Evidence-gated verdicts (E0–E5).** A classification without its required
   evidence auto-downgrades to `UNKNOWN`. `UNKNOWN` is a finding state, never
   "clean".
3. **KEV raises priority, never auto-exploitability.** CISA KEV is a triage
   input with dates/due-actions; reachability decides the project verdict.
4. **Source priority:** vendor advisory > CVE.org > NVD > CISA KEV > OSV >
   GitHub > distro/ecosystem trackers — with per-field provenance and conflict
   preservation (never silent overwrites).
5. **Offline-first, fabrication-free.** All analysis runs against local caches;
   missing data → `UNKNOWN` (with "no data anywhere" notes where true).
6. **Idempotent ingestion.** Re-runs converge; merge changelogs and per-field
   source tags make every decision auditable.
7. **False-positive engine** — a 10-filter, evidence-gated stack (incl. KEV
   mismatch filter); FPs are recorded, reversible, never auto-deleted.
8. **Honest coverage.** Knowledge-gap tracking (descriptions/ranges/CWE/
   vectors/exploitation/patches) feeds every report's coverage statement; the
   repo never claims to contain all CVEs — it is an engine that supports
   arbitrary CVE IDs (1999 → future) with continuous incremental updates.

## 4. Validation performed

| Check | Result |
|---|---|
| Generator run (`node cve/_build/cve-gen.js`) | clean, 95 skills / 9 areas |
| ESM syntax on all 12 data parts (`.mjs` check) | all pass (1 apostrophe bug fixed) |
| Duplicate skill filenames | none |
| Category values valid | all 9 defined |
| All 95 skill files written to disk | yes |
| All 12 template sections present per skill | 95/95 |
| CVE_INDEX rows == skill files | 95 == 95 |
| `related[]` refs resolve to real skills | 6 broken refs found and fixed → all resolve |
| 5 JSON schemas parse | all valid |
| No placeholder/TODO tokens in generated content | none |

## 5. Key files to start from

- `cve/README.md` — subsystem overview, golden rules
- `cve/CVE_WORKFLOW.md` — 8-stage end-to-end audit procedure
- `cve/CVE_ROUTER.md` — question → skill routing
- `cve/CVE_INDEX.md` — all 95 skills with purposes
- `cve/templates/cve-report.md` — report shape incl. coverage statement
- `cve/_build/cve-gen.js` — regenerates skills + index + placeholders

## 6. Honest limitations

- Runtime data directories (databases/, indexes/, mappings/, advisories/,
  vulnerability-data/) are placeholder skeletons — they populate when
  ingestion pipelines run against real feeds.
- The engine documents the methodology; live NVD/OSV/KEV fetch clients are not
  shipped (data remains local/cached).
- Skill coverage is a defined 95-skill set, not an exhaustive mapping of every
  CVE — extension is supported via the generator's data parts.
