# ULTRA CVE INTELLIGENCE ENGINE

A defensive CVE intelligence and vulnerability-analysis subsystem for
**ULTRA BUG HUNTER**. It turns raw CVE/advisory data into evidence-based,
reachability-aware, prioritized findings about *your* project — never into an
attack playbook.

## The golden rule

> **"CVE exists" ≠ "project is vulnerable".**

A CVE in a lockfile is *static evidence (E1)*. A project is vulnerable only
when the affected component is present **and** the vulnerable functionality is
applicable (version/platform/config) **and** reachable (imported, called, fed
by attacker-influenceable input, executing in the deployed configuration).

Everything in this engine exists to enforce that distinction, and to keep
`UNKNOWN` an honest first-class answer whenever evidence is missing.

## Scope and non-goals

- **Defensive only.** Identify vulnerable dependencies, explain mechanics,
  inspect source, reproduce bugs in isolated fixtures you control, write
  regression tests, recommend patches, verify remediation.
- **Not a pentest tool.** No live exploitation of third-party systems, no
  exfiltration, no exploit development, no attack playbooks.
- **Not a CVE database.** This repo does not contain every CVE. It contains
  the *engine* to ingest, normalize, correlate, triage, validate, and
  remediate against CVE data — any CVE ID from 1999 to the future is
  supported, and data updates are continuous and incremental.
- **Offline-capable.** Analysis runs against local caches. Network is an
  update path, never a query-time dependency. Missing data → `UNKNOWN`,
  never fabrication.

## Architecture

```
cve/
├── README.md            ← this file
├── CVE_INDEX.md         ← 95 skills, 9 areas (generated)
├── CVE_SCHEMA.md        ← record formats: cve, cpe, cvss, advisory, package
├── CVE_ROUTER.md        ← how to route a CVE question to the right skill
├── CVE_WORKFLOW.md      ← end-to-end pipeline: ingest → ... → remediate
├── CVE_TRIAGE.md        ← priority model and triage rules
├── CVE_VALIDATION.md    ← validation gates: CVSS, CWE, consistency, FP engine
├── CVE_REMEDIATION.md   ← fix/upgrade/backport guidance
├── CVE_FALSE_POSITIVES.md ← the FP filter stack
├── _build/              ← generator + data parts (95 skills)
├── skills/              ← 95 generated skill files in 9 areas
│   ├── discovery/       ├── ingestion/       ├── dependency/
│   ├── applicability/   ├── reachability/    ├── triage/
│   ├── validation/      ├── remediation/     └── correlation/
├── schemas/             ← 5 JSON schemas (cve, cpe, cvss, advisory, package)
├── sources/             ← source priority + per-source guidance (7 files)
├── templates/           ← cve-report.md
├── databases/           ← runtime data: nvd, cve.org, cisa-kev, vendor, osv
├── indexes/             ← by-cve, by-cwe, by-package, by-vendor, ...
├── mappings/            ← cve-cwe, cve-cpe, cve-package, cve-advisory, cve-fix
├── advisories/          ← vendor, github, ecosystem, framework
└── vulnerability-data/  ← raw → normalized → processed → cache
```

## The pipeline at a glance

| Stage | Area | Question answered |
|---|---|---|
| 1. Inventory | discovery | What components (and versions) exist? |
| 2. Ingest | ingestion | Import & normalize CVE/advisory data (idempotent). |
| 3. Match | dependency / applicability | Is the component version inside an affected range? |
| 4. Applicability | applicability | Version, platform, config, feature, deployed? |
| 5. Reachability | reachability | Can the vulnerable path actually execute? |
| 6. Triage | triage | How urgent, with what evidence? |
| 7. Validate | validation | CVSS/CWE/data consistency, false positives. |
| 8. Remediate | remediation | Exact fix version, upgrade plan, backport, verify. |
| 9. Correlate | correlation | CVE ↔ CWE ↔ package ↔ vendor ↔ skill ↔ timeline. |

## Golden rules (enforced throughout)

1. **Evidence before verdict.** Reachability classifications require evidence
   levels (E0–E5). A verdict without its required evidence reverts to
   `UNKNOWN`.
2. **Reachability classes are final and standard:** `DIRECTLY_REACHABLE`,
   `TRANSITIVELY_REACHABLE`, `PRESENT_BUT_UNUSED`, `CONDITIONALLY_REACHABLE`,
   `UNREACHABLE`, `UNKNOWN`.
3. **KEV raises priority, never auto-exploitability.** Known in-the-wild
   exploitation is a *triage input*; reachability decides the project verdict.
4. **`UNKNOWN` is a finding state.** Absence of data is not safety.
5. **Never fabricate.** No CVE, version, vector, range, or date is invented.
   Offline or gapped → `UNKNOWN` with a "no data anywhere" note where true.
6. **Source priority:** vendor advisory > CVE.org > NVD > CISA KEV > OSV >
   GitHub > ecosystem/distro trackers (details in `sources/README.md`).
7. **Idempotent ingestion.** Re-runs converge; merges preserve provenance and
   per-field conflicts.

## Quick start

```bash
# regenerate skills + CVE_INDEX + placeholders from the 12 data parts
node cve/_build/cve-gen.js

# then follow CVE_WORKFLOW.md for an audit
```

See `CVE_WORKFLOW.md` for the full procedure, `CVE_ROUTER.md` for routing,
and `templates/cve-report.md` for the report shape.
