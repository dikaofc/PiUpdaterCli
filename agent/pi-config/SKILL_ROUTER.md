# Skill Router

Maps project observations to the skills that must activate. **Multiple skills
activate simultaneously** for a single observation — e.g., a SQL query activates
`query-safety`, `sql-injection`, `database-access-control`, and
`regression-testing`. When in doubt, consult `SKILL_INDEX.md` for the catalog and
activate the union of matching rows.

## Core Routing Table

| Observation | Skills to activate (in order) |
|---|---|
| SQL query built from data | `query-safety` → `sql-injection` → `database-access-control` → `regression-testing` |
| NoSQL query from user JSON | `nosql-injection` → `query-safety` → `schema-validation` |
| User-controlled URL fetched server-side | `url-validation` → `ssrf-analysis` → `network-exposure` |
| User-controlled URL used for redirect | `url-validation` → `open-redirect` → `canonicalization` |
| Role/permission check | `access-control-analysis` → `server-side-authorization` → `vertical-privilege-escalation` / `role-analysis` |
| Object id from request | `bola-analysis` / `idor-analysis` → `resource-ownership` → `horizontal-privilege-escalation` |
| Admin/privileged endpoint | `bfla-analysis` → `admin-function-protection` → `vertical-privilege-escalation` |
| File upload | `file-upload-security` → `parser-security` → `path-traversal` → `mime-confusion` |
| Filename from user input | `path-traversal` → `canonicalization` → `file-download-security` |
| Archive extraction | `archive-processing` → `path-traversal` → `file-upload-security` |
| JWT usage | `jwt-analysis` → `authentication-flow-analysis` → `token-replay` |
| OAuth/OIDC callback | `oauth-analysis` / `oidc-analysis` → `open-redirect` → `jwt-analysis` |
| Login/register/reset flow | `authentication-flow-analysis` → `password-reset` → `account-enumeration` → `bruteforce-defense` |
| Password storage code | `password-storage` → `weak-hash-analysis` → `cryptographic-usage` |
| Session cookies | `cookie-security` → `session-management` → `session-fixation` → `logout-security` |
| CSRF tokens | `csrf-token-management` → `csrf-analysis` → `cookie-security` |
| XSS-prone rendering | `xss-analysis` → `unsafe-rendering` / `dom-sink-analysis` → `content-security-policy` |
| User content rendered later | `stored-xss` → `unsafe-rendering` → `log-injection` |
| CORS headers | `cors-analysis` → `api-data-exposure` → `csrf-analysis` |
| Host header in URLs | `host-header-analysis` → `cache-poisoning` → `password-reset` |
| Template rendering with user data | `template-injection` → `expression-injection` → `xss-analysis` |
| eval/dynamic execution | `code-injection` → `expression-injection` → `deserialization-analysis` |
| Shell command strings | `command-injection` → `code-injection` → `process-permissions` |
| XML parsing | `xml-security` → `parser-security` → `xpath-injection` |
| Deserialization of untrusted bytes | `deserialization-analysis` → `serialization-security` → `queue-security` |
| Price/quantity fields in requests | `price-integrity` / `quantity-integrity` → `parameter-tampering` → `duplicate-operation` |
| Status/state fields from client | `state-transition-analysis` → `workflow-state-analysis` → `business-rule-analysis` |
| Retries on state-changing calls | `retry-analysis` → `api-idempotency` → `duplicate-operation` → `replay-protection` |
| Shared mutable state | `race-condition` → `atomicity-analysis` → `concurrent-state` / `async-state-analysis` |
| File check-then-open | `toctou-analysis` → `path-traversal` → `filesystem-permissions` |
| Error pages/responses | `stack-trace-exposure` → `debug-mode-analysis` → `sensitive-error-data` → `api-error-handling` |
| Debug flags in config | `debug-mode-analysis` → `configuration-security` → `environment-analysis` |
| Hardcoded secrets | `hardcoded-secret-detection` → `secret-management` → `key-management` |
| Keys in config/env | `environment-secret-analysis` → `secret-management` → `configuration-security` |
| Random tokens | `randomness-analysis` → `token-generation` → `session-management` |
| TLS config | `tls-configuration` → `certificate-validation` → `security-headers` |
| New dependency | `dependency-audit` → `dependency-confusion` → `lockfile-analysis` → `transitive-dependencies` |
| Vulnerable dependency report | `dependency-audit` → `call-graph-analysis` → `transitive-dependencies` → `regression-testing` |
| CI/workflow changes | `ci-security` / `github-actions-security` → `pipeline-permission-analysis` → `supply-chain-risk` |
| Docker/k8s configs | `docker-security` → `container-security` / `container-orchestration` → `image-security` |
| Cloud storage/IAM | `cloud-storage-security` / `cloud-iam-analysis` → `cloud-secret-analysis` → `backup-security` |
| GraphQL endpoint | `graphql-security` → `api-authorization` → `api-data-exposure` → `api-rate-limiting` |
| WebSocket endpoint | `websocket-security` → `api-authentication` → `api-input-boundaries` |
| List endpoint with pagination | `api-pagination` → `api-rate-limiting` → `bola-analysis` → `api-data-exposure` |
| Queue consumer | `queue-security` → `worker-security` → `schema-validation` |
| Background job | `background-job-security` → `worker-security` → `server-side-authorization` |
| Log statements with user data | `logging-security` → `log-injection` → `audit-trail-analysis` |
| Cache usage | `cache-analysis` → `caching-correctness` → `cache-poisoning` → `concurrent-state` |
| Slow/unbounded loops | `algorithmic-complexity` → `cpu-exhaustion` → `infinite-loop-analysis` → `boundary-testing` |
| Resource pools (DB/HTTP) | `connection-leak` → `resource-exhaustion` → `timeout-analysis` → `performance-audit` |
| Fuzzable parser | `fuzzing-strategy` → `fuzz-harness-design` → `corpus-generation` → `crash-triage` |
| Spec-vs-code mismatch | `api-surface-analysis` → `api-schema-validation` → `api-versioning` |
| Error responses differ per state | `account-enumeration` → `api-error-handling` → `exception-analysis` |
| Client-side feature gating | `client-side-authorization` → `frontend-auth-state` → `server-side-authorization` |
| localStorage tokens | `local-storage-security` → `browser-storage` → `frontend-auth-state` |
| Approval workflow | `authorization-workflow` → `state-transition-analysis` → `audit-trail-analysis` |
| Quota/limit features | `quota-bypass-analysis` → `resource-limit-analysis` → `race-condition-database` |
| Payment/order creation | `price-integrity` → `api-idempotency` → `duplicate-operation` → `transaction-integrity` |

## Workflow Entry Points

- Full audit → `workflows/full-project-audit.md`
- Fast triage → `workflows/quick-audit.md`
- API audit → `workflows/api-audit.md`
- Auth audit → `workflows/auth-audit.md`
- Dependency audit → `workflows/dependency-audit.md`
- Config audit → `workflows/configuration-audit.md`
- Performance audit → `workflows/performance-audit.md`
- Incident debugging → `workflows/incident-debugging.md`
- PR review → `skills/code-review/pull-request-review.md`

## Routing Rules

1. Route by the *sink* first, then the *source*; a single observation can fan
   out to 3–8 skills.
2. Activate the umbrella skill and the specific variants together
   (e.g., `xss-analysis` + `stored-xss`).
3. Always include a verification/evidence skill for the final report
   (`confidence-assessment`, `false-positive-analysis`).
4. Language-aware notes live in `languages/`; pick the matching file when
   routing code-level observations.

## Related

- `SKILL_INDEX.md` — full catalog with purposes
- `METHODOLOGY.md` — investigation sequence
- `workflows/*` — composed procedures
