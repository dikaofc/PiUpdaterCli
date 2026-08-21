# Reference: Secure Coding Taxonomy

Taxonomy of secure-coding practices and where each is defined.

## Validation & Input

- Validate at trust boundaries → `skills/input-validation/untrusted-input-analysis.md`
- Schema/type validation → `schema-validation.md`
- Boundary/size/range validation → `boundary-validation.md`
- Canonicalization → `canonicalization.md`
- Encoding correctness → `encoding-validation.md`

## Output & Data Handling

- Context-aware encoding → `patterns/secure-api.md`, `skills/web/xss-analysis.md`
- Parameterized queries → `patterns/secure-database.md`,
  `skills/database/query-safety.md`
- Safe filesystem operations → `patterns/secure-file-handling.md`

## Identity & Access

- Secure password storage → `patterns/secure-authentication.md`
- Server-side authorization → `patterns/secure-authorization.md`
- Session/cookie hardening → `skills/session/cookie-security.md`

## Configuration & Secrets

- Secure configuration defaults → `patterns/secure-configuration.md`
- Secret management → `patterns/secure-secrets.md`
- Secure logging → `patterns/secure-logging.md`
- Error handling → `patterns/secure-error-handling.md`

## Lifecycle

- Dependency hygiene → `skills/dependencies/*`, `skills/supply-chain/*`
- CI/CD security → `skills/cloud/*` (ci-security, github-actions-security,
  pipeline-permission-analysis, artifact-security)
- Container/image security → `skills/containers/*`

## Related

- `../patterns/*`
- `../checklists/*`
