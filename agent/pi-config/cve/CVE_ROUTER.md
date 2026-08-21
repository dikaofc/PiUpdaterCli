# CVE_ROUTER.md

Route a CVE-related question to the right skill. The router is organized as
**question → skill path**. All skill files live under `skills/<area>/`.

## 1. "What components are in this project?"

| Question | Route |
|---|---|
| Enumerate manifests/lockfiles/containers/OS packages | `discovery/cve-project-inventory.md` |
| Resolve exact dependency set | `discovery/cve-dependency-discovery.md`, `cve-lockfile-analysis.md` |
| Transitive/nested deps | `discovery/cve-transitive-dependency-analysis.md` |
| Containers and SBOMs | `discovery/cve-container-analysis.md` |
| OS packages (apt/rpm/apk) | `discovery/cve-os-package-analysis.md` |
| Native/embedded/vendored libs | `discovery/cve-native-library-analysis.md`, `cve-embedded-component-analysis.md` |
| Frameworks/plugins/extensions | `discovery/cve-framework-analysis.md`, `cve-plugin-analysis.md` |
| Build the dependency graph | `dependency/dependency-graph-build.md` |
| Resolve package name aliases | `dependency/package-identity-resolution.md` |

## 2. "How do I get/update CVE data?"

| Question | Route |
|---|---|
| Overall ingestion pipeline | `ingestion/cve-feed-ingestion.md` |
| NVD / CVE.org / CISA KEV / OSV / GHSA / vendor / ecosystem | `ingestion/nvd-ingestion.md`, `cve-org-ingestion.md`, `cisa-kev-ingestion.md`, `osv-ingestion.md`, `github-advisory-ingestion.md`, `vendor-advisory-ingestion.md`, `ecosystem-advisory-ingestion.md` |
| Normalize / dedupe / merge records | `ingestion/cve-normalization.md`, `duplicate-detection.md`, `record-merging.md` |
| Version / CPE / CWE / CVSS normalization | `ingestion/version-normalization.md`, `cpe-normalization.md`, `cwe-normalization.md`, `cvss-normalization.md` |
| Extract affected/fixed versions, patches | `ingestion/affected-version-extraction.md`, `fixed-version-extraction.md`, `reference-extraction.md`, `patch-extraction.md` |
| Rebuild caches | `ingestion/cve-cache-rebuild.md` |
| Source priority | `sources/README.md` |

## 3. "Is this CVE applicable to our project?"

| Question | Route |
|---|---|
| Version inside affected range? | `applicability/cve-version-matching.md`, `cve-semver-analysis.md`, `cve-range-analysis.md` |
| CPE/product/platform/architecture match? | `applicability/cve-cpe-matching.md`, `cve-platform-matching.md`, `cve-architecture-matching.md` |
| Feature flags / config / disabled features? | `applicability/cve-feature-flag-analysis.md`, `cve-configuration-applicability.md`, `cve-disabled-feature-analysis.md` |
| Optional/dev components deployed? | `applicability/cve-optional-component-analysis.md` |
| Is the vulnerable code path used? | `applicability/cve-vulnerable-code-path.md` |

## 4. "Can the vulnerability actually be exploited in our app?"

| Question | Route |
|---|---|
| Full reachability pipeline | `reachability/cve-reachability-engine.md` |
| Imports / calls / input sources | `reachability/import-graph-analysis.md`, `call-graph-analysis.md`, `input-source-analysis.md` |
| Deployed execution paths | `reachability/execution-path-analysis.md` |
| Sensitive operation reached | `reachability/sensitive-operation-analysis.md` |
| Assign the standard classification | `reachability/reachability-classification.md` |
| Grade the evidence | `reachability/reachability-evidence-model.md` |

## 5. "How urgent is it?"

| Question | Route |
|---|---|
| Overall triage + scoring | `triage/cve-triage-engine.md`, `cve-priority-model.md` |
| Severity selection/validation | `triage/cve-severity-analysis.md`, `cve-advisory-severity-validation.md` |
| CVSS v3/v4 deep analysis | `triage/cvss-v3-analysis.md`, `triage/cvss-v4-analysis.md` |
| KEV / exploitation status | `triage/cve-known-exploitation-priority.md`, `cve-kev-correlation.md`, `cve-exploitation-status-analysis.md`, `cve-kev-false-positive-filter.md` |
| Confidence/uncertainty | `triage/cve-confidence-model.md` |
| Review workflow + decision records | `triage/cve-triage-review-workflow.md` |

## 6. "Validate the data / kill false positives"

| Question | Route |
|---|---|
| Schema/data validation | `validation/cve-data-validation.md`, `cve-data-consistency-check.md` |
| CVSS vector validation (v3/v4) | `validation/cvss-v3-vector-validation.md`, `cvss-v4-vector-validation.md` |
| Vector conflicts & score normalization | `validation/cve-vector-conflict-detection.md`, `cve-cvss-score-normalization.md` |
| FP engine (full filter stack) | `validation/cve-false-positive-engine.md` |
| Knowledge gaps | `validation/cve-knowledge-gap-analysis.md` |

## 7. "How do we fix it?"

| Question | Route |
|---|---|
| Exact fix version | `remediation/cve-fix-version-resolution.md` |
| Patch analysis | `remediation/cve-patch-analysis.md` |
| Backport assessment | `remediation/cve-backport-assessment.md` |
| Upgrade planning | `remediation/cve-upgrade-planning.md` |
| Prioritize the work | `remediation/cve-remediation-prioritization.md` |
| Verify the fix closed it | `remediation/cve-remediation-verification.md` |
| Generate the audit report | `remediation/cve-audit-report-generation.md` |

## 8. "Correlate / search / trends"

| Question | Route |
|---|---|
| Search by CVE/package/CWE/keyword | `correlation/cve-search-engine.md` |
| CVE ↔ CWE / families | `correlation/cve-cwe-correlation.md`, `cwe-mapping.md`, `cwe-family-analysis.md` |
| CVE ↔ package / fixed version | `correlation/cve-package-correlation.md`, `cve-fixed-version.md` |
| CVE ↔ advisories / vendors / ecosystems | `correlation/cve-advisory-correlation.md`, `vendor-correlation.md`, `cve-ecosystem-correlation.md` |
| Root cause patterns & timelines | `correlation/cve-root-cause-analysis.md`, `cve-timeline-analysis.md` |
| Exploit/PoC availability | `correlation/cve-exploit-correlation.md` |
| Language/ecosystem mapping | `dependency/language-ecosystem-map.md`, `ecosystem-registry-map.md` |

## Routing defaults

- **No CWE in the record** → route by description keywords, tagged *inferred*.
- **Reachability `UNKNOWN`** → rank by severity with a visible caveat; never
  default to reachable.
- **Advisory-only record (no CVE)** → ingest under advisory identity; do not
  mint a fake CVE.
- **Offline / missing data** → `UNKNOWN`, never fabricated.
