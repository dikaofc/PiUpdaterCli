# CVE_INDEX.md

Total CVE skills: **95** across **9** areas.

## How to use

1. **Discover** what is in the project (manifests, lockfiles, containers, OS packages).
2. **Ingest & normalize** CVE/advisory data (idempotent pipelines; see `CVE_WORKFLOW.md`).
3. **Determine applicability**: version/platform/feature — is the vulnerable code present?
4. **Analyze reachability**: can the vulnerable path actually execute?
5. **Triage**: severity, exploitability, KEV, asset impact → priority.
6. **Validate**: CVSS, CWE, evidence, false positives.
7. **Remediate**: fix version, upgrade risk, patch or backport, regression tests.
8. **Correlate**: CVE ↔ CWE ↔ package ↔ vendor ↔ skill.

The golden rule (see `README.md` in `cve/`):

> "CVE exists" ≠ "project is vulnerable".

## Skills by area

### CVE Ingestion (21)

| Skill | Purpose |
|---|---|
| advisory-correlation.md | Correlate advisories across sources for the same CVE/flaw: vendor, GitHub, OSV, distro, ecosystem. |
| affected-version-extraction.md | Extract affected (vulnerable) version ranges per product/package, normalized and sourced. |
| cisa-kev-ingestion.md | Import the CISA Known Exploited Vulnerabilities catalog: full snapshot and incremental additions, preserving due dates and actions |
| cpe-normalization.md | Normalize CPE 2.3 (WNF) strings and CPE-based affected-version data from NVD configurations. |
| cve-cache-rebuild.md | Rebuild the local CVE caches/databases safely: from raw data, from normalized data, or from scratch — with verification. |
| cve-feed-ingestion.md | Design and drive the generic CVE/advisory ingestion pipeline: fetch → validate → normalize → deduplicate → correlate → index → cac |
| cve-normalization.md | Normalize heterogeneous CVE/advisory inputs into one canonical record shape without inventing data. |
| cve-org-ingestion.md | Import CVE.org records via the CVE Services API (cveawg.mitre.org) and treat them as identity-authoritative. |
| cvss-normalization.md | Normalize CVSS scores/vectors from all sources, preserving the version (v2/v3.0/v3.1/v4) and provenance. |
| cwe-normalization.md | Normalize CWE references from all sources into the canonical CWE-ID form with confidence tagging. |
| duplicate-detection.md | Detect duplicate CVE records across feeds: same CVE via multiple advisories, alias chains, and near-duplicate advisories. |
| ecosystem-advisory-ingestion.md | Import package-ecosystem advisory databases (npm audit, PyPA OSV, Ruby Advisory DB, Alpine/Debian security trackers, ...). |
| fixed-version-extraction.md | Extract and normalize fixed/patched version information from advisories, OSV, GHSA, distro trackers. |
| github-advisory-ingestion.md | Import GitHub Security Advisories (GHSA records) and map them to CVEs, ecosystems, and vulnerable ranges. |
| nvd-ingestion.md | Import NVD (NIST) data correctly: CVE API v2.0 JSON schema, pagination/cursors, and incremental updates. |
| osv-ingestion.md | Import OSV.dev data (all.zip or per-ecosystem queries) and map OSV records to CVEs, affected ranges, and ecosystem packages. |
| patch-extraction.md | Identify and extract the patch (commit/diff) that fixes a CVE, with enough context for patch analysis. |
| record-merging.md | Merge records for the same canonical CVE with explicit, provenance-preserving conflict rules. |
| reference-extraction.md | Extract and classify references from CVE/advisory records: advisories, patches, PoC, vendor pages, NVD tags. |
| vendor-advisory-ingestion.md | Import vendor security advisories (Apache, Microsoft, Spring, WordPress, Red Hat, etc.) and treat them as affected-version authori |
| version-normalization.md | Normalize version strings and ranges across ecosystems (semver, PEP440, Maven, NuGet, RPM, Debian) for safe comparison. |

### CVE Discovery (12)

| Skill | Purpose |
|---|---|
| cve-container-analysis.md | Analyze container images for affected components: base image, OS packages, language layers, binaries — and their provenance. |
| cve-dependency-discovery.md | Resolve the resolved dependency set (direct + transitive, exact versions) and match it against CVE/advisory data. |
| cve-embedded-component-analysis.md | Analyze embedded/vendored components: copied source, submodules, single-version vendored copies, and firmware-embedded software. |
| cve-framework-analysis.md | Determine the frameworks/runtimes/SDKs in use and match their versions to framework-level CVEs and advisories. |
| cve-lockfile-analysis.md | Parse and analyze lockfiles accurately: exact versions, integrity hashes, workspace/hoisting semantics, and deduplication. |
| cve-manifest-analysis.md | Analyze manifest declarations (ranges, constraints) to bound possible versions and detect range-pinning risks. |
| cve-native-library-analysis.md | Identify native libraries (shared objects, static archives, bundled binaries) and match them to CVEs while accounting for distro p |
| cve-os-package-analysis.md | Analyze OS-level packages for CVEs using distribution security trackers (Debian DSA/DLA, Ubuntu USN, Alpine secdb, Red Hat, SUSE). |
| cve-plugin-analysis.md | Identify plugins/extensions/modules (WordPress, browser, IDEs, CI, server modules) and analyze them for CVEs, including active/ina |
| cve-project-inventory.md | Build the authoritative inventory of components in the project under review (source packages, lockfiles, containers, OS packages,  |
| cve-runtime-dependency-analysis.md | Identify dependencies resolved or loaded at runtime that are invisible to static manifests: dynamic requires, plugins, JNI, CDNs. |
| cve-transitive-dependency-analysis.md | Analyze transitive (indirect) dependencies for CVEs: resolution depth, deduplication, and reachability relevance. |

### Dependency Mapping (4)

| Skill | Purpose |
|---|---|
| dependency-graph-build.md | Build the resolved dependency graph (nodes = packages+versions, edges = dependency relations) used by CVE correlation and reachabi |
| ecosystem-registry-map.md | Maintain the canonical map of package ecosystems → registries → advisory sources, extensible to any ecosystem. |
| language-ecosystem-map.md | Map programming languages → ecosystems → package managers → packages → vulnerable versions → CVE/advisory, for correlation and que |
| package-identity-resolution.md | Resolve package identity aliases (name case, scopes, registries, renamed packages) to a canonical key for reliable matching. |

### Applicability Analysis (11)

| Skill | Purpose |
|---|---|
| cve-architecture-matching.md | Determine whether architecture-specific conditions in the CVE (32/64-bit, endianness, ARM, MIPS) match the deployment. |
| cve-configuration-applicability.md | Assess whether the project configuration affects CVE applicability: required config present/absent, or a mitigation in place. |
| cve-cpe-matching.md | Use structured CPE data to decide whether a CVE applies to the project platform/product (part, vendor, product, target_sw/hw). |
| cve-disabled-feature-analysis.md | Determine whether the vulnerable feature is disabled by compile-time or runtime configuration (module off, feature removed). |
| cve-feature-flag-analysis.md | Determine whether feature flags/toggles gate the vulnerable functionality in the project under review. |
| cve-optional-component-analysis.md | Determine whether an optional component (optional dependencies, extras, dev deps in prod) carrying a CVE is actually part of the d |
| cve-platform-matching.md | Determine whether the CVE applies to the deployment platform: OS family, browser, container runtime, mobile OS. |
| cve-range-analysis.md | Analyze affected/fixed ranges in all forms (intervals, lists, ECOSYSTEM ranges, GIT ranges) to canonical intervals. |
| cve-semver-analysis.md | Analyze semver semantics in affected/fixed data: prerelease handling, caret/tilde ranges, and semver-misuse in advisories. |
| cve-version-matching.md | Determine whether the installed version falls inside an affected range for a CVE, with a three-state verdict (affected / not affec |
| cve-vulnerable-code-path.md | Determine whether the specific vulnerable functionality of the dependency is present and used by the project (the applicability co |

### Reachability Analysis (8)

| Skill | Purpose |
|---|---|
| call-graph-analysis.md | Build and analyze the call graph from application entry points to the vulnerable function to prove reachable calls. |
| cve-reachability-engine.md | Operate the complete reachability pipeline for every potentially affected dependency: dependency -> vulnerable functionality -> ap |
| execution-path-analysis.md | Verify the call path can execute in the deployed configuration: entry points enabled, jobs scheduled, routes mounted. |
| import-graph-analysis.md | Analyze which project modules import the vulnerable dependency and its vulnerable entry points. |
| input-source-analysis.md | Identify whether attacker-influenceable input can reach the vulnerable function (taint path analysis). |
| reachability-classification.md | Assign and record the standardized reachability classification for each CVE candidate. |
| reachability-evidence-model.md | Assign evidence levels to reachability verdicts so that claims are graded by the strength of the proof behind them. |
| sensitive-operation-analysis.md | Determine the sensitive operation reachable via the vulnerable path (code execution, data read/write, auth bypass, DoS) to ground  |

### CVE Triage (12)

| Skill | Purpose |
|---|---|
| cve-advisory-severity-validation.md | Validate severity/priority claims from advisories (GHSA, vendor CVSS) against the canonical normalized data and the vector evidenc |
| cve-confidence-model.md | Model and record confidence for every CVE verdict (applicability, reachability, severity, exploitation) with explicit uncertainty. |
| cve-exploitation-status-analysis.md | Determine the exploitation status of a CVE from authoritative sources (KEV, vendor statements, public exploit availability) with p |
| cve-kev-correlation.md | Correlate every ingested CVE record against the CISA KEV catalog: match by CVE ID, track dates, and record known-ransomware signal |
| cve-kev-false-positive-filter.md | Filter false positives that arise from KEV automation: product mismatches, version mismatches, and misattributed exploitation. |
| cve-known-exploitation-priority.md | Incorporate known-exploitation status (CISA KEV, vendor statements, threat intel) into priority while keeping it separate from rea |
| cve-priority-model.md | Define and apply the project-level priority model: how severity, reachability, exploitation status, and asset criticality combine  |
| cve-severity-analysis.md | Select, validate, and contextualize the severity for a CVE: which CVSS version, which source, and what the local context changes. |
| cve-triage-engine.md | Score and rank CVE candidates into a triage queue: exploitability signals, reachability classification, severity, asset criticalit |
| cve-triage-review-workflow.md | Run the human-in-the-loop triage review: queue, assign, analyze, decide, record — with auditable decision records. |
| cvss-v3-analysis.md | Analyze CVSS v3.0/3.1 vectors and scores in detail: parse components, understand metric semantics, and compute/recompute scores. |
| cvss-v4-analysis.md | Analyze CVSS v4.0 vectors: new metrics (AT, VC/VI/VA, SC/SI/SA, MSI/MSA), and v4 semantics including derived metric groups. |

### CVE Validation (8)

| Skill | Purpose |
|---|---|
| cve-cvss-score-normalization.md | Normalize CVSS scores across versions for fair comparison (v2 vs v3 vs v4) with explicit conversion caveats. |
| cve-data-consistency-check.md | Run cross-field consistency checks on the normalized database: ranges, dates, statuses, and referential integrity. |
| cve-data-validation.md | Validate CVE/advisory records against schemas and integrity rules at every stage of the pipeline. |
| cve-false-positive-engine.md | Systematically apply the FP filter stack to remove or downgrade false positives before they enter the report. |
| cve-knowledge-gap-analysis.md | Track and report knowledge gaps in the CVE dataset: missing descriptions, missing ranges, unreviewed records, unenriched data. |
| cve-vector-conflict-detection.md | Detect and explain conflicts between CVSS vectors from different sources for the same CVE. |
| cvss-v3-vector-validation.md | Validate CVSS v3.x vectors: component legality, value enumeration, and score recomputation. |
| cvss-v4-vector-validation.md | Validate CVSS v4.0 vectors: new metric sets, derived metrics, and v4 score recomputation. |

### Remediation (7)

| Skill | Purpose |
|---|---|
| cve-audit-report-generation.md | Generate the CVE audit report from the record set: findings, classifications, evidence, priorities, and the honest coverage statem |
| cve-backport-assessment.md | Assess whether a fix can/should be backported to an older version that cannot upgrade, and whether a backport exists. |
| cve-fix-version-resolution.md | Resolve the precise fix/upgrade target for each affected component: first fixed version per source, per ecosystem, and per deploym |
| cve-patch-analysis.md | Analyze the fixing patch to understand the root cause, confirm the fix actually addresses the vulnerability, and inform backportin |
| cve-remediation-prioritization.md | Order remediation work by combining risk (triage priority) with remediation cost (effort, compatibility, deployment risk). |
| cve-remediation-verification.md | Verify that remediation actually closed the CVE: re-run discovery/applicability/reachability for the new version and confirm the v |
| cve-upgrade-planning.md | Plan the actual upgrade: target version selection, breaking-change assessment, migration steps, and rollback. |

### Correlation (12)

| Skill | Purpose |
|---|---|
| cve-advisory-correlation.md | Correlate the full advisory evidence set for each CVE (vendor, GitHub, OSV, distro, ecosystem) into a single reviewable record. |
| cve-cwe-correlation.md | Correlate CVE records to their CWE(s) with confidence, supporting weakness-based queries and trend analysis. |
| cve-ecosystem-correlation.md | Correlate CVEs at the ecosystem level: cross-package clusters, ecosystem-wide attack patterns, and supply-chain exposure. |
| cve-exploit-correlation.md | Correlate CVEs with public exploit/PoC availability and provenance for risk signals (not exploit creation). |
| cve-fixed-version.md | Correlate CVEs with their fixed/patch versions across sources to support fix queries and upgrade planning. |
| cve-package-correlation.md | Correlate CVEs to packages (ecosystem, package name, affected/fixed versions) to power dependency-match queries. |
| cve-root-cause-analysis.md | Derive and correlate root-cause patterns across CVEs (from patches and descriptions) to spot systemic classes affecting the projec |
| cve-search-engine.md | Operate the conceptual CVE search/index layer: lookup by CVE ID, package, version, CWE, vendor, keyword — always offline-first wit |
| cve-timeline-analysis.md | Analyze CVE timelines: publication, patch availability, NVD enrichment, KEV addition — to reason about exposure windows and data f |
| cwe-family-analysis.md | Analyze CVEs grouped into the 29 tracked CWE families: recognize the family, know the pattern, and route to the family skill. |
| cwe-mapping.md | Maintain the mapping between CWE IDs and the analysis skills that address them, so CVE triage routes to the right skill automatica |
| vendor-correlation.md | Correlate vendors/products across CVEs and advisories: vendor keys, product lines, CNAs, and per-vendor advisory feeds. |

