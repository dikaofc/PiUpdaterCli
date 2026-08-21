# Skill Index

Complete catalog of the **336 skill files** in `skills/`, organized by category.
Columns: Skill · Category · Purpose · Triggers · Related Skills · Priority.

Priority: 1 = always during audits; 2 = common; 3 = situational.

## reconnaissance (10)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| project-surface-mapping | Build a project inventory (components, languages, integrations) before analysis | Audit start | repository-structure-analysis, entrypoint-discovery, dependency-discovery, attack-surface-mapping | 1 |
| repository-structure-analysis | Analyze repository layout to scope the audit | Audit start | project-surface-mapping, entrypoint-discovery, attack-surface-mapping | 1 |
| entrypoint-discovery | Enumerate all places untrusted input enters the system | Audit start, new features | endpoint-discovery, attack-surface-mapping, backend-entrypoint-analysis | 1 |
| endpoint-discovery | Enumerate HTTP/API endpoints with auth requirements | API audits, spec review | entrypoint-discovery, api-surface-analysis, backend-entrypoint-analysis | 1 |
| dependency-discovery | Inventory the full dependency set (all languages, transitives, natives) | Dependency audits | dependency-audit, transitive-dependencies, lockfile-analysis | 1 |
| configuration-discovery | Enumerate all configuration surfaces | Config audits, release readiness | configuration-security, secret-surface-discovery, environment-analysis | 1 |
| secret-surface-discovery | Find every place secrets could exist | Config/secret audits | hardcoded-secret-detection, secret-management, environment-secret-analysis | 1 |
| trust-boundary-discovery | Identify trust boundaries in the architecture | Any audit, threat modeling | attack-surface-mapping, access-control-analysis, database-access-control | 1 |
| data-flow-discovery | Inventory major data flows to guide tracing | Audit planning, incident debugging | data-flow-analysis, taint-analysis, project-surface-mapping | 2 |
| attack-surface-mapping | Rank the full attack surface by sensitivity × reachability | Audit kickoff, scope definition | entrypoint-discovery, trust-boundary-discovery, api-surface-analysis | 1 |

## input-validation (10)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| untrusted-input-analysis | Analyze input handling at trust boundaries | Any input→sink path | schema-validation, boundary-validation, sql-injection, api-input-boundaries | 1 |
| type-confusion | Find type-coercion/loose-comparison defects | Coercion-prone comparisons, parsed data | schema-validation, mass-assignment, authentication-flow-analysis | 2 |
| schema-validation | Verify structured input validated against explicit schemas | JSON/form/GraphQL input | untrusted-input-analysis, type-confusion, mass-assignment, api-schema-validation | 1 |
| boundary-validation | Check size/range/count limits on input | Arithmetic, allocation, pagination | schema-validation, algorithmic-complexity, api-pagination | 1 |
| canonicalization | Ensure values canonicalized before comparison/use | Paths, URLs, identifiers, access checks | path-traversal, url-validation, ssrf-analysis, access-control-analysis | 2 |
| encoding-validation | Analyze encoding correctness (double-encoding, wrong-context) | Filters, rendering, charsets | canonicalization, unicode-handling, xss-analysis, header-injection | 2 |
| unicode-handling | Find normalization/case/confusable defects | Identity, dedup, filtering | encoding-validation, canonicalization, account-enumeration | 3 |
| parameter-tampering | Analyze client-controlled security/business fields | Prices, roles, flags in requests | price-integrity, quantity-integrity, client-side-authorization | 1 |
| mass-assignment | Detect bulk binding of client fields onto models | Binding APIs, object spread | schema-validation, parameter-tampering, role-analysis, controller-analysis | 1 |
| http-parameter-pollution | Find parsing inconsistencies across layers | Duplicate/conflicting params | parameter-tampering, request-smuggling, api-input-boundaries | 3 |

## injection (10)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| sql-injection | Detect/validate SQL injection | String-built queries, raw ORM | query-safety, orm-security, database-access-control, regression-testing | 1 |
| nosql-injection | Detect/validate NoSQL operator injection | Query filters from user JSON | sql-injection, query-safety, access-control-analysis | 1 |
| command-injection | Detect/validate OS command injection | Shell strings, exec | code-injection, path-traversal, process-permissions | 1 |
| code-injection | Detect/validate eval/dynamic-dispatch injection | eval, reflection on strings | command-injection, template-injection, expression-injection, deserialization-analysis | 1 |
| template-injection | Detect/validate SSTI | User content in templates | expression-injection, xss-analysis, code-injection, stored-xss | 1 |
| expression-injection | Detect/validate expression-language injection (SpEL/OGNL/jq) | Expression evaluators | template-injection, code-injection, api-schema-validation | 2 |
| ldap-injection | Detect/validate LDAP filter injection | String-built LDAP filters | sql-injection, authentication-flow-analysis, query-safety | 3 |
| xpath-injection | Detect/validate XPath injection | String-built XPath | sql-injection, xml-security, authentication-flow-analysis | 3 |
| header-injection | Detect/validate HTTP header injection (CRLF) | User data into headers | response-splitting, cache-poisoning, log-injection, cookie-security | 2 |
| log-injection | Detect/validate log forging/injection | User data in logs | header-injection, logging-security, audit-trail-analysis, stored-xss | 2 |

## web (18)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| xss-analysis | Umbrella XSS analysis across contexts | Unsafe renders, user data in pages | stored-xss, reflected-xss, dom-xss, content-security-policy | 1 |
| stored-xss | Analyze persistent XSS | Stored user content re-rendered | xss-analysis, unsafe-rendering, log-injection | 1 |
| reflected-xss | Analyze reflected XSS | Params echoed in responses | xss-analysis, open-redirect, content-security-policy | 1 |
| dom-xss | Analyze DOM-based XSS | Client sinks, postMessage | xss-analysis, dom-sink-analysis, unsafe-rendering | 1 |
| csrf-analysis | Analyze CSRF protections | State-changing endpoints | cors-analysis, csrf-token-management, cookie-security | 1 |
| cors-analysis | Analyze CORS misconfigurations | ACAO reflection, credentials | csrf-analysis, cookie-security, api-data-exposure | 2 |
| clickjacking | Analyze framing protections | Sensitive pages frameable | csrf-analysis, security-headers, content-security-policy | 2 |
| open-redirect | Detect/validate open redirects | Redirect parameters | url-validation, oauth-analysis, reflected-xss | 2 |
| request-smuggling | Detect/validate HTTP request smuggling | Proxy/backend parse mismatch | response-splitting, cache-poisoning, http-parameter-pollution | 3 |
| response-splitting | Detect/validate response splitting (CRLF) | CRLF into responses | header-injection, cache-poisoning, request-smuggling | 3 |
| host-header-analysis | Detect Host-header attacks | Host-derived URLs/links | cache-poisoning, open-redirect, password-reset, url-validation | 2 |
| cache-poisoning | Detect web cache poisoning | Unkeyed inputs in cached responses | host-header-analysis, request-smuggling, caching-correctness | 3 |
| mime-confusion | Analyze MIME sniffing/content-type confusion | User content served inline | file-upload-security, security-headers, stored-xss | 2 |
| security-headers | Verify security header presence/correctness | Hardening passes | content-security-policy, clickjacking, mime-confusion, tls-configuration | 2 |
| content-security-policy | Analyze CSP configuration | Permissive/absent CSP | xss-analysis, security-headers, clickjacking | 2 |
| crlf-injection | Audit CR/LF injection into headers, logs, cache keys, email | Newline-capable input into line-structured sinks | header-injection, response-splitting, log-injection, request-smuggling | 2 |
| react2shell | Audit client frameworks (React/Next/Electron/WebView) for XSS→RCE escalation | dangerouslySetInnerHTML, postMessage, nodeIntegration | dom-xss, xss-analysis, unsafe-rendering, frontend-data-exposure | 2 |
| wp2shell | Defensively audit WordPress for upload/eval/file-write chains | WordPress, plugins, upload paths | file-upload-security, command-injection, dependency-audit, admin-function-protection | 2 |

## files (10)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| ssrf-analysis | Detect/validate server-side request forgery | User URLs into clients | url-validation, open-redirect, network-exposure | 1 |
| url-validation | Analyze URL validation logic | URL consumers | ssrf-analysis, open-redirect, canonicalization | 1 |
| path-traversal | Detect/validate path traversal | User paths to filesystem | canonicalization, file-upload-security, archive-processing | 1 |
| file-upload-security | Analyze upload handling security | Upload endpoints | mime-confusion, path-traversal, archive-processing, parser-security | 1 |
| file-download-security | Analyze download serving security | Download endpoints | path-traversal, mime-confusion, file-upload-security, resource-ownership | 2 |
| archive-processing | Analyze archive extraction (zip-slip, bombs) | Archive extraction | path-traversal, file-upload-security, parser-security | 2 |
| parser-security | Analyze parser abuse (bombs, pollution, confusion) | Untrusted parsing | xml-security, deserialization-analysis, schema-validation | 2 |
| xml-security | Analyze XML security (XXE, bombs) | XML parsing | parser-security, xpath-injection | 1 |
| serialization-security | Analyze serialization format limits | Untrusted deserialization | deserialization-analysis, parser-security, schema-validation | 2 |
| deserialization-analysis | Detect unsafe deserialization (gadgets) | pickle/unserialize/readObject | serialization-security, parser-security, code-injection, queue-security | 1 |

## api (15)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| api-surface-analysis | Map the full API surface | API audits | endpoint-discovery, api-authorization, api-versioning | 1 |
| api-authentication | Analyze API authentication coverage | Token/key APIs | api-authorization, authentication-flow-analysis, jwt-analysis | 1 |
| api-authorization | Analyze API authorization per endpoint/object | Endpoint matrix review | bola-analysis, bfla-analysis, access-control-analysis | 1 |
| bola-analysis | Detect Broken Object Level Authorization | Object-id endpoints | api-authorization, idor-analysis, resource-ownership | 1 |
| bfla-analysis | Detect Broken Function Level Authorization | Privileged endpoints | api-authorization, vertical-privilege-escalation, admin-function-protection | 1 |
| api-schema-validation | Verify request payload validation | Payload endpoints | api-input-boundaries, schema-validation, mass-assignment | 1 |
| api-rate-limiting | Analyze rate-limit coverage and bypasses | Sensitive/costly endpoints | bruteforce-defense, resource-exhaustion, api-surface-analysis | 2 |
| api-pagination | Analyze pagination bounds/order/enumeration | List endpoints | api-rate-limiting, resource-exhaustion, bola-analysis | 2 |
| api-idempotency | Analyze retry/duplicate safety | State-changing endpoints | duplicate-operation, replay-protection, transaction-integrity | 2 |
| api-error-handling | Analyze API error leakage/consistency | Error responses | stack-trace-exposure, exception-analysis, account-enumeration | 2 |
| api-versioning | Analyze version exposure/parity | Multiple versions | api-surface-analysis, api-authentication, backend-entrypoint-analysis | 3 |
| api-input-boundaries | Analyze validation across input channels | Multi-channel endpoints | api-schema-validation, untrusted-input-analysis, websocket-security | 2 |
| api-data-exposure | Analyze response over-fetch/sensitive fields | Response schemas | api-schema-validation, cors-analysis, query-safety, graphql-security | 1 |
| graphql-security | Analyze GraphQL introspection/complexity/authz | GraphQL endpoints | api-authorization, api-data-exposure, api-rate-limiting | 2 |
| websocket-security | Analyze WebSocket handshake/message security | WS endpoints | api-authentication, api-input-boundaries, csrf-analysis | 2 |

## authentication (12)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| authentication-flow-analysis | Analyze auth flows end to end | Any auth feature | login-state-machine, session-authentication, password-reset, mfa-analysis | 1 |
| password-policy | Verify server-side password policy | Registration/password changes | password-storage, bruteforce-defense, credential-stuffing-defense | 2 |
| password-storage | Verify strong KDF usage for passwords | Password hashing code | password-policy, weak-hash-analysis, cryptographic-usage | 1 |
| credential-stuffing-defense | Analyze stuffing defenses (breach lists, challenges) | Login at scale | bruteforce-defense, mfa-analysis, password-policy | 2 |
| bruteforce-defense | Analyze brute-force limits/lockout | Login endpoints | credential-stuffing-defense, password-policy, api-rate-limiting | 1 |
| account-enumeration | Detect distinguishable auth responses | Login/register/reset | authentication-flow-analysis, password-reset, api-error-handling | 2 |
| password-reset | Analyze reset token lifecycle | Reset endpoints | authentication-flow-analysis, email-verification, host-header-analysis, token-generation | 1 |
| email-verification | Analyze verification flows | Verify endpoints | password-reset, authentication-flow-analysis, token-generation | 2 |
| mfa-analysis | Analyze MFA enforcement and bypasses | MFA features | otp-analysis, authentication-flow-analysis, session-authentication | 1 |
| otp-analysis | Analyze OTP mechanisms | OTP login/verify | mfa-analysis, bruteforce-defense, token-generation, randomness-analysis | 2 |
| login-state-machine | Analyze login state transitions | Multi-step login | authentication-flow-analysis, mfa-analysis, state-transition-analysis | 2 |
| session-authentication | Analyze identity binding to sessions | Session creation | session-management, session-fixation, authentication-flow-analysis | 1 |

## session (10)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| session-management | Analyze session token lifecycle | Session implementations | session-fixation, session-expiration, logout-security, cookie-security | 1 |
| session-fixation | Detect missing session regeneration | Login flow | session-management, session-authentication | 1 |
| session-expiration | Verify expiry/idle timeout | Long-lived sessions | session-management, logout-security, token-generation | 2 |
| logout-security | Verify server-side logout invalidation | Logout flow | session-management, token-replay, csrf-analysis | 2 |
| cookie-security | Verify cookie attributes | Set-Cookie sites | csrf-token-management, session-management, csrf-analysis | 1 |
| csrf-token-management | Analyze CSRF token lifecycle | Token implementations | csrf-analysis, cookie-security, randomness-analysis | 2 |
| token-replay | Analyze token single-use | Reset/verify/OAuth tokens | replay-protection, jwt-analysis, password-reset | 2 |
| jwt-analysis | Analyze JWT alg/signature/claim validation | JWT auth | token-replay, authentication-flow-analysis, key-management, oauth-analysis | 1 |
| oauth-analysis | Analyze OAuth2 redirect/state/PKCE | OAuth flows | oidc-analysis, jwt-analysis, open-redirect, token-generation | 1 |
| oidc-analysis | Analyze OIDC ID-token validation | OIDC SSO | oauth-analysis, jwt-analysis, authentication-flow-analysis | 2 |

## authorization (10)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| access-control-analysis | Umbrella access-control analysis | Any audit | server-side-authorization, resource-ownership, role-analysis | 1 |
| idor-analysis | Detect insecure direct object references | Id-based lookups | bola-analysis, resource-ownership, horizontal-privilege-escalation | 1 |
| horizontal-privilege-escalation | Detect cross-user/tenant access | Multi-user apps | idor-analysis, resource-ownership, database-access-control, bola-analysis | 1 |
| vertical-privilege-escalation | Detect user→admin escalation | Admin endpoints | bfla-analysis, admin-function-protection, role-analysis | 1 |
| role-analysis | Analyze role definitions/grants | RBAC systems | permission-inheritance, access-control-analysis, admin-function-protection | 2 |
| permission-inheritance | Analyze permission propagation | Nested groups/orgs | role-analysis, access-control-analysis, horizontal-privilege-escalation | 2 |
| resource-ownership | Analyze ownership models | Owner-bearing resources | idor-analysis, horizontal-privilege-escalation, bola-analysis | 1 |
| server-side-authorization | Verify server-side enforcement | Any authorization question | client-side-authorization, access-control-analysis, api-authorization | 1 |
| client-side-authorization | Detect client-side-only gating | UI-hidden features | server-side-authorization, access-control-analysis, frontend-auth-state | 1 |
| admin-function-protection | Analyze admin function protection | Admin surfaces | vertical-privilege-escalation, role-analysis, debug-mode-analysis | 1 |

## cryptography (7)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| cryptographic-usage | Analyze crypto algorithm/mode/IV correctness | Custom crypto | weak-hash-analysis, randomness-analysis, key-management, jwt-analysis | 1 |
| weak-hash-analysis | Detect weak/legacy hash usage | MD5/SHA1 security uses | cryptographic-usage, password-storage, jwt-analysis | 2 |
| randomness-analysis | Verify CSPRNG for security values | Token/session generation | token-generation, cryptographic-usage, session-management | 1 |
| token-generation | Analyze token entropy/lifecycle | Custom token generation | randomness-analysis, token-replay, password-reset | 1 |
| tls-configuration | Analyze TLS protocol/cipher/HSTS config | TLS configs | certificate-validation, security-headers, network-exposure | 2 |
| certificate-validation | Analyze client cert verification | HTTP clients | tls-configuration, ssrf-analysis | 2 |
| key-management | Analyze key storage/rotation/access | Key handling | secret-management, cryptographic-usage, tls-configuration | 1 |

## secrets (3)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| hardcoded-secret-detection | Detect secrets in code/history/artifacts | Secret-pattern matches | secret-management, environment-secret-analysis, secret-surface-discovery | 1 |
| secret-management | Analyze runtime secret handling | Secret sourcing | hardcoded-secret-detection, environment-secret-analysis, configuration-security | 1 |
| environment-secret-analysis | Analyze env-based secrets | .env, env defaults | secret-management, hardcoded-secret-detection, environment-analysis | 1 |

## database (8)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| database-access-control | Analyze DB privileges/isolation | Multi-tenant DB | query-safety, horizontal-privilege-escalation, backup-security | 1 |
| transaction-analysis | Analyze isolation/locking | Read-modify-write | transaction-integrity, race-condition-database, race-condition | 2 |
| transaction-integrity | Analyze atomicity/rollback | Multi-write ops | transaction-analysis, duplicate-operation, atomicity-analysis | 2 |
| race-condition-database | Detect DB-level races | Check-then-act | transaction-analysis, race-condition, duplicate-operation | 2 |
| query-safety | Analyze query construction | All query sites | sql-injection, orm-security, database-access-control | 1 |
| orm-security | Analyze ORM raw usage/mass assignment | ORM queries | query-safety, mass-assignment, horizontal-privilege-escalation | 1 |
| database-error-leakage | Detect DB error leakage | Raw DB errors | stack-trace-exposure, sensitive-error-data, api-error-handling | 2 |
| backup-security | Analyze backup encryption/access | Backup pipelines | cloud-storage-security, database-access-control | 3 |

## business-logic (12)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| business-rule-analysis | Analyze business rule enforcement | Eligibility/entitlements | quota-bypass-analysis, price-integrity, parameter-tampering | 1 |
| workflow-state-analysis | Analyze workflow state consistency | Long-running workflows | state-transition-analysis, duplicate-operation, transaction-integrity | 2 |
| price-integrity | Analyze pricing/total integrity | Price fields, discounts | quantity-integrity, parameter-tampering, duplicate-operation | 1 |
| quantity-integrity | Analyze quantity/stock integrity | Quantity fields, stock | price-integrity, race-condition-database, boundary-validation | 1 |
| duplicate-operation | Detect duplicate-operation defects | State-creating ops | api-idempotency, replay-protection, race-condition-database | 1 |
| replay-protection | Analyze request replay controls | Replayable ops | duplicate-operation, token-replay, api-idempotency | 2 |
| state-transition-analysis | Analyze state machine transitions | Status fields | workflow-state-analysis, authorization-workflow, race-condition | 1 |
| authorization-workflow | Analyze approval workflows | Approval steps | state-transition-analysis, workflow-state-analysis, access-control-analysis | 2 |
| quota-bypass-analysis | Analyze quota bypasses | Quota features | resource-limit-analysis, api-rate-limiting, resource-exhaustion | 2 |
| resource-limit-analysis | Analyze resource limit enforcement | Plan/resource limits | quota-bypass-analysis, race-condition-database, resource-exhaustion | 2 |
| eligibility-analysis | Analyze eligibility/entitlement checks for bypass | Discounts, trials, tiered features | business-rule-analysis, quota-bypass-analysis, authorization-workflow | 2 |
| approval-workflow | Audit multi-step approval chains for privilege/order flaws | Approval processes | authorization-workflow, state-transition-analysis, audit-trail-analysis | 2 |

## concurrency (14)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| race-condition | Detect application race conditions | Shared mutable state | atomicity-analysis, concurrent-state, race-condition-database | 1 |
| toctou-analysis | Detect TOCTOU races | Check-then-use | race-condition, path-traversal, filesystem-permissions | 2 |
| deadlock-analysis | Detect deadlocks | Lock ordering, async locks | lock-analysis, resource-exhaustion, timeout-analysis | 2 |
| lock-analysis | Analyze locking correctness | Manual locking | deadlock-analysis, atomicity-analysis, concurrent-state | 2 |
| atomicity-analysis | Analyze atomic operations | Counters, read-modify-write | race-condition, race-condition-database, lock-analysis | 2 |
| concurrent-state | Analyze cross-request shared state | Globals, shared caches | async-state-analysis, race-condition, cache-analysis | 2 |
| async-state-analysis | Analyze async shared state | Async code | concurrent-state, race-condition, resource-exhaustion | 2 |
| duplicate-request-analysis | Analyze concurrent duplicates | Parallel identical requests | race-condition, duplicate-operation, api-idempotency | 2 |
| race-condition-analysis | Hunt TOCTOU/interleaving races (check-then-act, shared state) | Check-then-act sequences | race-condition, race-condition-database, lock-management | 2 |
| priority-queue-races | Analyze priority-queue/worker races | Competing consumers | worker-security, queue-security, race-condition | 2 |
| lock-management | Audit lock scope, deadlocks, leases, release semantics | Manual/distributed locks | deadlock-analysis, transaction-analysis, race-condition-analysis | 2 |
| backpressure-handling | Analyze backpressure and overload control | Queue/stream overload | resource-exhaustion, api-rate-limiting, queue-security | 3 |
| batch-processing-analysis | Analyze batch jobs for races/partial failures | Batch/ETL jobs | transaction-integrity, worker-security, background-job-security | 2 |
| worker-pool-analysis | Analyze worker pool sizing/drain/failure handling | Worker pools | worker-security, backpressure-handling, resource-exhaustion | 3 |

## errors (11)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| error-boundary-analysis | Analyze error boundaries | Missing central handlers | exception-analysis, api-error-handling, fallback-security | 2 |
| exception-analysis | Analyze exception handling correctness | Empty catches, error paths | error-boundary-analysis, fallback-security, transaction-integrity | 1 |
| stack-trace-exposure | Detect traceback leakage | Error responses | debug-mode-analysis, sensitive-error-data, api-error-handling | 1 |
| debug-mode-analysis | Detect debug modes in prod | Debug flags | stack-trace-exposure, configuration-security, sensitive-error-data | 1 |
| sensitive-error-data | Detect sensitive values in errors/logs | Error payloads | stack-trace-exposure, logging-security, database-error-leakage | 1 |
| fallback-security | Analyze fail-open fallbacks | Fallback paths | exception-analysis, server-side-authorization, secure-error-handling | 1 |
| retry-analysis | Analyze retry bounds/amplification | Retry loops | timeout-analysis, duplicate-operation, api-idempotency | 2 |
| timeout-analysis | Analyze timeout coverage | External calls | retry-analysis, connection-leak, resource-exhaustion | 1 |
| error-handling-analysis | Audit error handling completeness across layers | Error paths, partial failures | exception-analysis, error-boundary-analysis, sensitive-error-data | 1 |
| try-catch-security | Analyze catch-block security (swallowed errors, fail-open) | Empty/silent catches | exception-analysis, fallback-security, fail-open-analysis | 2 |
| fail-open-analysis | Find security checks that default to allow on failure | Auth/ACL/rate-limit gates | fallback-security, exception-analysis, server-side-authorization | 1 |

## dependencies (9)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| dependency-audit | Audit dependencies with reachability | Dependency changes | transitive-dependencies, outdated-dependency-analysis, dependency-model | 1 |
| transitive-dependencies | Analyze transitive resolution | Transitive advisories | dependency-audit, lockfile-analysis, call-graph-analysis | 2 |
| lockfile-analysis | Verify lockfile integrity/sync | Lockfiles | dependency-audit, package-integrity, supply-chain-risk | 2 |
| dependency-confusion | Analyze internal-name/registry collision | Internal packages | package-integrity, supply-chain-risk, ci-security | 2 |
| package-integrity | Verify package hash/signature pinning | Installs | lockfile-analysis, package-provenance, dependency-confusion | 2 |
| outdated-dependency-analysis | Assess outdated/unmaintained deps | Stale packages | dependency-audit, supply-chain-risk, regression-testing | 3 |
| native-dependency-analysis | Analyze OS/native dependencies | Images, FFI | dependency-audit, docker-security, image-security | 2 |
| dependency-analysis | Analyze dependency usage/reachability end to end | Any dependency question | dependency-audit, transitive-dependencies, call-graph-analysis | 1 |
| dependency-integrity | Verify dependency provenance and integrity | Install/update flows | package-integrity, lockfile-analysis, dependency-confusion | 2 |

## supply-chain (5)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| supply-chain-risk | Analyze end-to-end artifact provenance | CI fetches | package-integrity, ci-security, artifact-security, package-provenance | 1 |
| package-provenance | Verify provenance/attestation | Third-party artifacts | supply-chain-risk, package-integrity, artifact-security | 2 |
| license-and-compliance-risk | Assess license/compliance risk | Release readiness | dependency-audit, release-readiness | 3 |
| software-supply-chain | Analyze the full software supply chain (sources→artifacts) | Supply-chain reviews | supply-chain-risk, dependency-audit, artifact-security | 1 |
| postinstall-script-analysis | Audit install-time scripts for malicious behavior | Install scripts, npm postinstall | supply-chain-risk, command-injection, package-integrity | 2 |

## infrastructure (11)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| configuration-security | Analyze config defaults/flags/secrets | Config changes | environment-analysis, secret-management, debug-mode-analysis | 1 |
| environment-analysis | Analyze environment separation/drift | Multi-env deploys | configuration-security, debug-mode-analysis, environment-secret-analysis | 2 |
| docker-security | Analyze Dockerfile/runtime config | Dockerfiles | container-security, image-security, process-permissions | 2 |
| container-security | Analyze container isolation | Runtime configs | docker-security, container-orchestration, process-permissions | 2 |
| filesystem-permissions | Analyze file permission safety | File ops | process-permissions, toctou-analysis, path-traversal | 2 |
| process-permissions | Analyze process privilege/caps | Root services | docker-security, filesystem-permissions | 2 |
| network-exposure | Analyze network reachability | Network configs | port-exposure, reverse-proxy-analysis | 1 |
| port-exposure | Analyze exposed ports | Port configs | network-exposure, service-configuration | 2 |
| service-configuration | Analyze service hardening | Service defaults | configuration-security, port-exposure, debug-mode-analysis | 2 |
| reverse-proxy-analysis | Analyze proxy routing/header rules | Proxy configs | request-smuggling, network-exposure, port-exposure | 2 |
| server-config-review | Review server/host configuration hardening | Server configs | configuration-security, service-configuration, network-exposure | 2 |
| deployment-config-review | Review deployment configuration for drift/security | Deploy configs, IaC | environment-analysis, infrastructure-as-code, configuration-security | 2 |
| infrastructure-as-code | Analyze IaC for secrets, drift, privilege | Terraform/Ansible/CloudFormation | deployment-config-review, cloud-iam-analysis, configuration-security | 2 |

## containers (9)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| docker-security | Analyze Docker configuration | Dockerfiles | container-security, image-security, container-orchestration | 2 |
| container-security | Analyze container runtime isolation | Runtime configs | docker-security, container-orchestration, process-permissions | 2 |
| image-security | Analyze image scanning/signing/secrets | Image builds | docker-security, native-dependency-analysis, package-provenance | 2 |
| container-orchestration | Analyze k8s RBAC/policies/secrets | Orchestration configs | container-security, cloud-iam-analysis, deployment-security | 2 |
| container-image-analysis | Analyze image layers, base images, and embedded secrets | Dockerfiles, image builds | image-security, docker-security, native-dependency-analysis | 2 |
| container-runtime-analysis | Analyze runtime flags, capabilities, and isolation | Runtime configs, docker run | container-security, process-permissions, docker-security | 2 |
| kubernetes-security | Analyze k8s RBAC, NetworkPolicies, admission, secrets | K8s manifests | container-orchestration, cloud-iam-analysis, deployment-security | 2 |
| dockerfile-review | Review Dockerfiles for security anti-patterns | Dockerfiles | docker-security, image-security, container-image-analysis | 2 |
| orchestration-secrets | Analyze secret handling in orchestration | K8s secrets, vault | secret-management, kubernetes-security, environment-secret-analysis | 2 |

## cloud (12)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| cloud-iam-analysis | Analyze cloud IAM/roles/policies | Cloud configs | cloud-storage-security, cloud-secret-analysis | 2 |
| cloud-storage-security | Analyze storage permissions/encryption | Storage configs | cloud-iam-analysis, backup-security, file-upload-security | 2 |
| cloud-secret-analysis | Analyze cloud secret exposure | Cloud configs | secret-management, cloud-iam-analysis, environment-secret-analysis | 2 |
| ci-security | Analyze CI secrets/injection/permissions | CI configs | github-actions-security, pipeline-permission-analysis, supply-chain-risk | 1 |
| github-actions-security | Analyze workflow injection/permissions | Workflows | ci-security, pipeline-permission-analysis, supply-chain-risk | 2 |
| pipeline-permission-analysis | Analyze pipeline credential scope | Pipelines | ci-security, github-actions-security, deployment-security | 2 |
| artifact-security | Analyze artifact integrity/distribution | Releases | package-provenance, deployment-security, package-integrity | 2 |
| deployment-security | Analyze deploy gates/credentials | Deployments | pipeline-permission-analysis, artifact-security, environment-analysis | 2 |
| cloud-config-review | Review cloud configuration for misconfiguration | Cloud consoles/configs | cloud-iam-analysis, cloud-storage-security, cloud-secret-analysis | 1 |
| serverless-security | Analyze serverless functions/permissions/inputs | Lambda/Functions configs | cloud-iam-analysis, api-authorization, backend-entrypoint-analysis | 2 |
| cloud-metadata-analysis | Analyze metadata-service exposure/SSRF risk | SSRF paths, IMDS | ssrf-analysis, network-exposure, cloud-iam-analysis | 2 |
| lambda-permission-analysis | Analyze Lambda/function IAM and triggers | Function policies | serverless-security, cloud-iam-analysis, pipeline-permission-analysis | 2 |

## cicd (5)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| ci-cd-security | Audit CI/CD secret handling, action trust, artifact integrity, triggers | Pipeline configs | build-pipeline-security, software-supply-chain, secret-management | 1 |
| build-pipeline-security | Analyze build steps for injection/secret exposure | Build configs | ci-cd-security, artifact-integrity, ci-security | 2 |
| artifact-integrity | Verify artifact signing/hash verification at build and deploy | Artifact promotion | artifact-security, package-integrity, ci-cd-security | 2 |
| cicd-platform-hardening | Harden the CI/CD platform config (runners, permissions, scopes) | Runner/agent configs | ci-cd-security, pipeline-permission-analysis, github-actions-security | 3 |
| deployment-trigger-analysis | Analyze deploy triggers/gates for abuse | Deploy webhooks, auto-deploys | deployment-security, ci-cd-security, artifact-integrity | 2 |

## frontend (19)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| frontend-data-exposure | Analyze client data exposure | Over-fetched data | api-data-exposure, browser-storage, frontend-source-exposure | 2 |
| browser-storage | Analyze browser storage sensitivity | Storage usage | local-storage-security, cookie-security, xss-analysis | 2 |
| local-storage-security | Analyze localStorage tokens/PII | localStorage | browser-storage, cookie-security, frontend-auth-state | 2 |
| frontend-auth-state | Analyze client auth state as control | Route guards | client-side-authorization, local-storage-security, server-side-authorization | 1 |
| frontend-api-security | Analyze client API credentials | Client keys | api-authentication, frontend-data-exposure, cors-analysis | 2 |
| dom-sink-analysis | Analyze dangerous DOM sinks | innerHTML/eval/location | dom-xss, unsafe-rendering, xss-analysis | 1 |
| unsafe-rendering | Analyze autoescape bypasses | v-html/raw renders | stored-xss, xss-analysis, dom-sink-analysis | 1 |
| frontend-source-exposure | Analyze source maps/bundle leaks | Source maps | frontend-data-exposure, hardcoded-secret-detection | 3 |
| dom-based-xss | Analyze DOM-based XSS via client sinks | Client-side sinks | dom-xss, dom-sink-analysis, xss-analysis | 1 |
| client-side-templating | Analyze client template engines for injection | Client rendering | unsafe-rendering, dom-xss, client-side-validation | 2 |
| extensions-browser-security | Analyze browser extension permissions/messaging | Extension manifests | postmessage-analysis, xss-analysis, frontend-api-security | 3 |
| postmessage-analysis | Analyze postMessage origin/schema validation | postMessage usage | dom-xss, extensions-browser-security, dom-sink-analysis | 2 |
| client-side-validation | Detect client-only validation | Form validation | server-side-authorization, schema-validation, untrusted-input-analysis | 1 |
| iframe-embedding | Analyze embedding/framing risks and postMessage to iframes | iframes, widgets | clickjacking, postmessage-analysis, content-security-policy | 2 |
| client-storage-review | Review all client storage for sensitive data | IndexedDB/localStorage/sessionStorage | local-storage-security, browser-storage, frontend-data-exposure | 2 |
| frontend-security-headers | Verify frontend security headers and CSP delivery | Headers/CSP | security-headers, content-security-policy, clickjacking | 2 |
| mobile-webview | Analyze mobile WebView bridges/JS interfaces | Hybrid apps | react2shell, frontend-api-security, dom-xss | 3 |
| deep-link-validation | Analyze deep-link/universal-link handling | Mobile/desktop links | open-redirect, url-validation, mobile-webview | 3 |
| history-leakage | Analyze sensitive data in URL/history state | Client routing | frontend-data-exposure, browser-storage, dom-xss | 3 |

## backend (21)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| backend-entrypoint-analysis | Analyze backend handlers/consumers | Backend audits | entrypoint-discovery, middleware-analysis, controller-analysis | 1 |
| middleware-analysis | Analyze middleware order/coverage | Middleware wiring | api-authentication, controller-analysis, backend-entrypoint-analysis | 1 |
| service-layer-analysis | Analyze service authorization/rules | Services | controller-analysis, repository-layer-analysis, server-side-authorization | 1 |
| controller-analysis | Analyze controllers | New endpoints | middleware-analysis, service-layer-analysis, mass-assignment | 1 |
| repository-layer-analysis | Analyze data-access scoping | Repositories | service-layer-analysis, query-safety, resource-ownership | 1 |
| background-job-security | Analyze job argument/authz | Background jobs | worker-security, queue-security, server-side-authorization | 2 |
| worker-security | Analyze worker input handling | Workers | queue-security, background-job-security, parser-security | 2 |
| queue-security | Analyze queue message trust | Queues | worker-security, background-job-security, schema-validation | 2 |
| backend-logic-review | Review backend business logic end to end | Backend audits | service-layer-analysis, business-rule-analysis, controller-analysis | 1 |
| service-layer-security | Analyze security controls in the service layer | Services | service-layer-analysis, server-side-authorization, middleware-analysis | 1 |
| trust-boundary-analysis | Analyze trust boundaries within backend components | Component boundaries | trust-boundary-discovery, middleware-analysis, architecture-risk-analysis | 2 |
| framework-security | Analyze framework security features/misuse | Framework upgrades | middleware-analysis, api-authorization, schema-validation | 2 |
| mvc-security | Analyze MVC pattern security (models, validation, filters) | MVC apps | controller-analysis, middleware-analysis, mass-assignment | 2 |
| api-design-security | Analyze API design decisions for security | API design | api-surface-analysis, api-authorization, api-schema-validation | 2 |
| http-method-tampering | Analyze unsafe HTTP method handling | Method overrides, custom verbs | api-authorization, request-smuggling, controller-analysis | 2 |
| response-splitting-break2 | Detect/validate response splitting (CRLF) | CRLF into headers | response-splitting, header-injection, cache-poisoning | 3 |
| backend-template-injection | Detect SSTI in backend templating | Server templates | template-injection, expression-injection, xss-analysis | 2 |
| deserialization-security2 | Detect unsafe deserialization (pickle/unserialize/readObject) | Deserialization of untrusted bytes | deserialization-analysis, serialization-security, code-injection | 1 |
| binary-parsing-security | Analyze binary format parsing for memory/input abuse | Binary parsers | parser-security, memory-safety-analysis, fuzzing-strategy | 2 |
| native-code-review | Review native (C/C++/FFI) code security | Native modules | memory-safety-analysis, code-review, binary-parsing-security | 2 |
| state-sync-analysis | Analyze distributed state sync/caching correctness | Shared caches/state | concurrent-state, caching-correctness, race-condition | 2 |

## memory (2)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| memory-safety-analysis | Audit memory-safety in managed/native code | Unsafe blocks, buffers | binary-parsing-security, native-code-review, resource-leak-analysis | 2 |
| resource-leak-analysis | Detect resource leaks (handles, memory, pools) | Growing usage | connection-leak, file-descriptor-leak, memory-leak-analysis | 2 |

## performance (13)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| memory-leak-analysis | Detect memory leaks | Growing memory | resource-exhaustion, cache-analysis, timeout-analysis | 2 |
| resource-exhaustion | Analyze input-driven exhaustion | Unbounded work | cpu-exhaustion, memory-leak-analysis, connection-leak | 1 |
| cpu-exhaustion | Analyze CPU cost drivers (ReDoS etc.) | Expensive ops | algorithmic-complexity, infinite-loop-analysis, resource-exhaustion | 2 |
| disk-exhaustion | Analyze unbounded disk use | File/log growth | resource-exhaustion, file-upload-security, logging-security | 2 |
| connection-leak | Analyze connection pool leaks | Connections | file-descriptor-leak, resource-exhaustion, timeout-analysis | 2 |
| file-descriptor-leak | Analyze fd leaks | Files/sockets | connection-leak, resource-exhaustion | 2 |
| infinite-loop-analysis | Detect infinite loops/recursion | Loop conditions | cpu-exhaustion, algorithmic-complexity, timeout-analysis | 2 |
| algorithmic-complexity | Analyze superlinear algorithms | Nested loops, N+1 | cpu-exhaustion, query-safety, api-pagination | 2 |
| cache-analysis | Analyze cache bounds/keys | Caches | caching-correctness, memory-leak-analysis, concurrent-state | 2 |
| caching-correctness | Analyze cache invalidation | Cached state | cache-analysis, cache-poisoning, race-condition | 2 |
| dos-via-algorithm | Analyze algorithmic DoS vectors | Superlinear input processing | algorithmic-complexity, cpu-exhaustion, resource-exhaustion | 2 |
| regex-analysis | Analyze regex for ReDoS | User-controlled regex, complex patterns | cpu-exhaustion, algorithmic-complexity, fuzzing-strategy | 2 |
| request-size-limits | Analyze request/body size limits | Uploads, large payloads | boundary-validation, resource-exhaustion, api-pagination | 2 |

## reliability (3)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| reliability-failure-analysis | Analyze failure modes and degradation behavior | Failure reviews | failover-analysis, dependency-failure-handling, error-handling-analysis | 2 |
| failover-analysis | Audit failover/HA paths for control parity | Failover, standby, replicas | reliability-failure-analysis, cloud-config-review, transaction-analysis | 2 |
| dependency-failure-handling | Analyze behavior when dependencies fail | Downstream outages | failover-analysis, retry-analysis, timeout-analysis | 2 |

## testing (12)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| unit-test-security | Security-aware unit tests | Security functions | integration-test-security, security-test-design | 2 |
| integration-test-security | Security-aware integration tests | Flows | unit-test-security, negative-testing, auth-audit | 2 |
| regression-testing | Design regression tests | Every confirmed bug | negative-testing, boundary-testing, reproduction-test-design | 1 |
| negative-testing | Design denial assertions | Denials | boundary-testing, regression-testing, security-test-design | 1 |
| boundary-testing | Design boundary value tests | Limits | negative-testing, property-based-testing, boundary-validation | 2 |
| property-based-testing | Property tests for invariants | Invariants | boundary-testing, fuzzing-strategy, mutation-testing | 2 |
| mutation-testing | Assess test quality via mutations | Thin security tests | unit-test-security, regression-testing, security-test-design | 3 |
| security-test-design | Design tests from threat models | Requirements | negative-testing, reproduction-test-design, threat-modeling | 2 |
| reproduction-test-design | Design minimal reproductions | Findings, incidents | regression-testing, dynamic-behavior-analysis | 1 |
| security-unit-tests | Write security-focused unit tests for controls | Auth/authz/crypto code | unit-test-security, negative-testing, security-test-design | 2 |
| security-test-planning | Plan security test scope/cases from surface | Test planning | security-test-design, attack-surface-mapping, threat-modeling | 2 |
| fuzzing | Apply fuzzing to security-relevant inputs | Parsers, decoders | fuzzing-strategy, fuzz-harness-design, crash-triage | 2 |

## fuzzing (4)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| fuzzing-strategy | Select fuzzing strategies | Parsers/serializers | fuzz-harness-design, corpus-generation, crash-triage | 2 |
| fuzz-harness-design | Design fuzz harnesses | Fuzz targets | fuzzing-strategy, corpus-generation, crash-triage | 2 |
| corpus-generation | Build effective corpora | Fuzz campaigns | fuzzing-strategy, fuzz-harness-design | 3 |
| crash-triage | Triage fuzz findings | Fuzz crashes | fuzzing-strategy, regression-testing | 2 |

## static-analysis (7)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| static-code-analysis | Systematic static analysis | Audit kickoff | taint-analysis, data-flow-analysis, call-graph-analysis | 1 |
| taint-analysis | Trace sources to sinks | Injection audits | data-flow-analysis, static-code-analysis, sql-injection | 1 |
| data-flow-analysis | Model full data flows | Finding validation | taint-analysis, call-graph-analysis, data-flow-analysis (context) | 1 |
| control-flow-analysis | Analyze branches/error paths | Complex logic | static-code-analysis, data-flow-analysis, exception-analysis | 2 |
| call-graph-analysis | Analyze reachability | Reachability questions | dead-code-analysis, taint-analysis, transitive-dependencies | 2 |
| dead-code-analysis | Find unreachable code | Legacy code | call-graph-analysis, entrypoint-discovery, debug-mode-analysis | 2 |
| static-analysis | Umbrella static-analysis workflow (tools + manual review) | Audit kickoff | static-code-analysis, taint-analysis, control-flow-analysis | 1 |

## dynamic-analysis (3)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| dynamic-behavior-analysis | Observe runtime behavior | Finding validation | runtime-instrumentation, reproduction-test-design, runtime-model | 1 |
| runtime-instrumentation | Instrument local runs | Hard-to-observe behavior | dynamic-behavior-analysis, monitoring-coverage, runtime-model | 2 |
| sandbox-execution-analysis | Analyze behavior in sandboxes | Untrusted artifacts | dynamic-behavior-analysis, runtime-model, parser-security | 3 |

## code-review (11)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| security-code-review | Systematic security review | Pre-merge review | diff-review, pull-request-review, dangerous-change-analysis | 1 |
| architecture-code-review | Review architecture-level security | Design review | architecture-risk-analysis, security-code-review | 2 |
| diff-review | Review diffs in context | PRs/commits | pull-request-review, regression-risk-analysis, security-code-review | 1 |
| pull-request-review | Review PRs holistically | Every PR | diff-review, missing-test-analysis, dangerous-change-analysis | 1 |
| dangerous-change-analysis | Classify change risk | PR triage | security-code-review, pull-request-review, security-review (workflow) | 2 |
| regression-risk-analysis | Assess change regression risk | Shared code changes | missing-test-analysis, diff-review, regression-testing | 2 |
| missing-test-analysis | Identify test gaps | Untested logic | regression-risk-analysis, negative-testing, mutation-testing | 2 |
| maintainability-analysis | Assess complexity/testability | Complex code | security-code-review, dead-code-analysis, missing-test-analysis | 3 |
| code-review | Umbrella code-review workflow (diff, PR, commit, release) | Any review | diff-review, pull-request-review, security-code-review | 1 |
| git-history-analysis | Analyze git history for secrets and risky changes | History reviews | hardcoded-secret-detection, change-risk-analysis, secret-surface-discovery | 2 |
| change-risk-analysis | Assess risk of specific changes | Targeted reviews | dangerous-change-analysis, regression-risk-analysis, git-history-analysis | 2 |

## architecture (4)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| architecture-risk-analysis | Analyze systemic architecture risk | Architecture reviews | trust-zone-analysis, dependency-graph-analysis, threat-modeling | 2 |
| trust-zone-analysis | Analyze trust zones and crossings | Boundary questions | architecture-risk-analysis, trust-boundary-discovery, SECURITY_BOUNDARIES | 2 |
| dependency-graph-analysis | Analyze component coupling/cycles | Refactor planning | architecture-risk-analysis, call-graph-analysis | 3 |
| evolution-risk-analysis | Analyze design drift from growth | Mature systems | architecture-risk-analysis, architecture-code-review | 3 |

## observability (5)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| logging-security | Analyze log sensitivity/injection | Log changes | audit-trail-analysis, log-injection, logging (checklist) | 1 |
| audit-trail-analysis | Analyze audit event coverage | Compliance | logging-security, admin-function-protection, logging (checklist) | 2 |
| monitoring-coverage | Analyze detection coverage | Ops review | alerting-correctness, audit-trail-analysis, runtime-instrumentation | 2 |
| alerting-correctness | Analyze alert rule accuracy | Alert review | monitoring-coverage, credential-stuffing-defense | 2 |
| audit-trail-maintenance | Analyze audit log retention/integrity | Compliance/retention | audit-trail-analysis, logging-security, backup-security | 2 |

## reporting (10)

| Skill | Purpose | Triggers | Related | P |
|---|---|---|---|---|
| finding-classification | Classify findings consistently | Every finding | severity-assessment, confidence-assessment, vulnerability-taxonomy | 1 |
| severity-assessment | Assign severity from factors | Every finding | impact-analysis, confidence-assessment, severity-model | 1 |
| confidence-assessment | Assign confidence from evidence | Every finding | finding-classification, confidence-model, evidence-model | 1 |
| root-cause-analysis | Identify underlying defects | Every finding | remediation-analysis, incident-debugging, root-cause-analysis (template) | 1 |
| impact-analysis | Analyze realistic impact | Every finding | severity-assessment, evidence-model, vulnerability-report (template) | 1 |
| remediation-analysis | Design minimal fixes | Every finding | root-cause-analysis, METHODOLOGY, remediation-matrix | 1 |
| false-positive-analysis | Document disproved findings | Every candidate | finding-classification, false-positive-model, evidence-model | 1 |
| security-reporting | Produce security reports | Audit completion | executive-summary, finding-classification, audit-summary (template) | 1 |
| bug-reporting | Produce bug reports | Confirmed bugs | security-reporting, bug-report (template), bug-taxonomy | 1 |
| executive-summary | Produce executive summaries | Audit delivery | security-reporting, audit-summary (template), severity-assessment | 1 |

---

## Totals

| Metric | Count |
|---|---|
| Skill categories | 34 |
| Skill files | 336 |
| Minimum required by spec | 120 |

## Cross-Category Notes

- `data-flow-analysis.md` exists in `context/` (model) and `skills/static-analysis/`
  (technique) — intentional.
- `root-cause-analysis.md` exists in `templates/` (document) and
  `skills/reporting/` (technique) — intentional.
- `dependency-audit.md` exists in `workflows/` (procedure) and
  `skills/dependencies/` (skill) — intentional.
- `security-review.md` exists in `workflows/` (procedure) and `templates/`
  (report) — intentional.
- `docker-security.md` and `container-security.md` exist in both
  `infrastructure/` (host-level) and `containers/` (image/runtime-level) —
  intentional; they cover different layers.
- Some umbrella/general skills complement their specific siblings:
  `static-analysis.md`, `code-review.md`, `fuzzing.md`,
  `dependency-analysis.md`, `error-handling-analysis.md` — intentional.
- All 234 baseline skills are present, plus 102 additional skills covering
  CI/CD, memory, reliability, extended frontend/backend/cloud/container
  concerns, and cross-layer analysis.
- The full inventory on disk (336 files) is the source of truth; when adding
  skills, keep this index in sync.
