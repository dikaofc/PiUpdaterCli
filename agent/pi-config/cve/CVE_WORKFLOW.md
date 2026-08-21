# CVE_WORKFLOW.md

End-to-end operating procedure for a CVE audit of a project, using the
CVE Intelligence Engine. Each stage names the skills it uses and the
artifacts it produces. The workflow supports arbitrary CVE IDs (1999 →
future) and continuous/incremental updates.

## Stage 0 — Prepare

- Confirm scope: repo, deployed artifacts, environments (prod/staging),
  third-party components in scope, and the offline/data budget.
- Check local data freshness (`databases/`, `vulnerability-data/`). If a
  network update is allowed and needed, run incremental ingestion first
  (Stage 2). Record what was and was not updated.

## Stage 1 — Inventory (discovery)

1. Enumerate manifests, lockfiles, containers, OS packages, native libs,
   frameworks, plugins, embedded/vendored code
   (`cve-project-inventory`, `cve-lockfile-analysis`, `cve-container-analysis`,
   `cve-os-package-analysis`, `cve-native-library-analysis`,
   `cve-framework-analysis`, `cve-plugin-analysis`,
   `cve-embedded-component-analysis`).
2. Build the resolved dependency graph with via-chains
   (`dependency-graph-build`, `cve-transitive-dependency-analysis`).
3. Classify deployment: deployed / build-only / optional / unknown
   (`cve-optional-component-analysis`).

**Artifact:** component inventory `(component × version × ecosystem ×
source × deployed)`.

## Stage 2 — Ingest & normalize (ingestion)

1. Fetch/update sources per `sources/README.md` priority
   (`cve-feed-ingestion`, `nvd-ingestion`, `cve-org-ingestion`,
   `cisa-kev-ingestion`, `osv-ingestion`, `github-advisory-ingestion`,
   `vendor-advisory-ingestion`, `ecosystem-advisory-ingestion`).
2. Normalize, dedupe, merge (`cve-normalization`, `duplicate-detection`,
   `record-merging`; version/CPE/CWE/CVSS normalizers).
3. Extract affected/fixed versions and patches
   (`affected-version-extraction`, `fixed-version-extraction`,
   `reference-extraction`, `patch-extraction`).
4. Validate everything against the schemas (`cve-data-validation`,
   `cve-data-consistency-check`); track gaps (`cve-knowledge-gap-analysis`).

**Artifact:** normalized records + integrity report + gap report.
Re-runs are idempotent; merges preserve provenance.

## Stage 3 — Match (dependency × applicability)

1. Match inventory against normalized records per package+ecosystem
   (`cve-package-correlation`, `cve-search-engine`).
2. Version membership (`cve-version-matching`, `cve-semver-analysis`,
   `cve-range-analysis`).
3. Platform/architecture/CPE/product checks (`cve-cpe-matching`,
   `cve-platform-matching`, `cve-architecture-matching`).
4. Config/feature/flag/disabled checks (`cve-configuration-applicability`,
   `cve-feature-flag-analysis`, `cve-disabled-feature-analysis`).
5. Vulnerable functionality presence + usage (`cve-vulnerable-code-path`).

**Artifact:** candidate list, each with a three-state verdict
(affected / not-affected / unknown) and its evidence.

## Stage 4 — Reachability (reachability)

For every *affected* or *unknown* candidate:

1. Import graph → call graph → input source → execution path →
   sensitive operation (`cve-reachability-engine` and its sub-skills).
2. Assign the standard classification:
   `DIRECTLY_REACHABLE` / `TRANSITIVELY_REACHABLE` /
   `PRESENT_BUT_UNUSED` / `CONDITIONALLY_REACHABLE` / `UNREACHABLE` /
   `UNKNOWN`.
3. Attach the evidence level (E0–E5) (`reachability-evidence-model`);
   downgrade to `UNKNOWN` when the required evidence is missing.

**Artifact:** per-CVE classification table with evidence links.

## Stage 5 — Triage (triage)

1. Score each candidate: severity (validated), reachability class, KEV /
   exploitation status, asset criticality, exposure
   (`cve-triage-engine`, `cve-priority-model`).
2. Apply the rules: KEV raises priority (never auto-exploitability);
   `DIRECTLY_REACHABLE` + KEV is highest; `UNKNOWN` reachability ranks by
   severity with a caveat (`cve-known-exploitation-priority`,
   `cve-kev-correlation`, `cve-exploitation-status-analysis`).
3. Run the human-in-the-loop review and record decisions
   (`cve-triage-review-workflow`).

**Artifact:** ordered triage queue with decomposable scores and decision
records.

## Stage 6 — Validate & filter (validation)

1. CVSS/CWE validation and vector conflict resolution (`cvss-v3-vector-validation`,
   `cvss-v4-vector-validation`, `cve-vector-conflict-detection`,
   `cve-cvss-score-normalization`).
2. Run the FP filter stack with evidence per verdict
   (`cve-false-positive-engine`, `cve-kev-false-positive-filter`).
3. Re-run data consistency; update the gap report.

**Artifact:** validated findings (FPs downgraded or removed with evidence;
nothing auto-deleted).

## Stage 7 — Remediate (remediation)

1. Resolve exact fix versions (`cve-fix-version-resolution`).
2. Prioritize the backlog by risk × cost and batch by component
   (`cve-remediation-prioritization`).
3. Plan upgrades / backports (`cve-upgrade-planning`,
   `cve-backport-assessment`, `cve-patch-analysis`).
4. Verify closure post-change and re-scan (`cve-remediation-verification`).

**Artifact:** remediation plan + verified closures.

## Stage 8 — Report

Generate the audit report per `templates/cve-report.md`
(`cve-audit-report-generation`) including the honest coverage statement:
sources ingested, last update, UNKNOWN/gap counts.

## Continuous operation

- **Incremental ingestion** on a schedule (feeds' since/cursor parameters),
  with change detection triggering re-triage (`cve-timeline-analysis`).
- **KEV updates** re-open affected records (`cve-kev-correlation`).
- **New advisories** for existing components re-run Stages 3–7 for the delta.
- **Cache rebuilds** are scoped, backed up, and verified
  (`cve-cache-rebuild`).
- **Gap closure** is prioritized and tracked (`cve-knowledge-gap-analysis`).

## Verification of the workflow itself

- Re-run idempotency checks per stage.
- Cross-check a sample of verdicts with a second method (tool + manual).
- Confirm the report's coverage statement matches the data state.
