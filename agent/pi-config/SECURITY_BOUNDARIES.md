# Security Boundaries

Security boundaries are the transitions across which data and control pass from a less
trusted context to a more trusted context. Most vulnerabilities are boundary failures:
data crosses a boundary without validation, authorization, or encoding.

## Boundary Transitions to Track

| From | To | Typical failure |
|---|---|---|
| Browser / client | API | missing input validation, missing auth cookies |
| API | Service layer | missing authorization re-check, mass assignment |
| Service layer | Database | injection, missing row-level filtering |
| Service layer | External API | SSRF, missing allow-list, credential leakage |
| User A | Admin functions | missing privilege checks |
| Tenant A | Tenant B | broken row-level isolation, IDOR |
| Untrusted file | Parser | parser bombs, path traversal, zip slip |
| Untrusted data | Renderer | XSS, template injection |
| Untrusted data | Shell / OS | command injection |
| Untrusted data | Deserializer | gadget chains |
| Container | Host | privilege escalation, volume mishandling |
| CI | Production deploy | secret leakage, supply-chain compromise |
| App | Cloud resource | over-permissioned IAM, exposed storage |

## Rules

1. **Never trust anything from the lower-trust side of a boundary** without explicit
   validation at the boundary itself.
2. **Enforce at the outermost boundary possible and re-verify at each subsequent
   boundary** when the trust level changes (defense in depth).
3. **Never trust client-supplied identity or ownership claims** (roles, ownership ids,
   flags, feature toggles, prices). Authorization is server-side.
4. **Every boundary crossing in a report must be named.** A finding that says "data
   flows from user input to a query" must name the boundary (Browser→API→DB).
5. **A boundary that exists in code but not in enforcement is a finding.** E.g., a
   multi-tenant table without a tenant filter on every query.

## Boundary Inspection Method

1. List all entry points (see `context/attack-surface-model.md`).
2. For each entry point, list the boundaries crossed until the data reaches a sink.
3. For each crossing, answer: validation? authorization? encoding? canonicalization?
4. Identify boundaries enforced by convention only (comments, naming, frontend) — these
   are prime bug locations.
5. Record each crossing in the finding's Data Flow section.

## Boundary-Specific Checklists

- Browser→API: CSRF tokens, content types, size limits, authn cookies, CORS policy.
- API→Service: authorization per operation (not per route only), tenant scoping,
  ownership checks, idempotency keys.
- Service→DB: parameterized queries, row-level security, least-privilege DB account,
  connection isolation.
- Service→External: egress allow-list, URL validation, timeout, no credential reuse.
- File handling: size limits, content sniffing, path canonicalization, archive member
  validation.
- Render: context-aware encoding (HTML, attribute, JS, CSS, URL).
- Config: secrets from secret manager, not environment dumps; validation of config
  values at load.

## Related

- `context/trust-boundaries.md`
- `context/attack-surface-model.md`
- `context/data-flow-analysis.md`
- `skills/reconnaissance/trust-boundary-discovery.md`
- `skills/authorization/server-side-authorization.md`
- `checklists/authentication.md`, `checklists/authorization.md`
