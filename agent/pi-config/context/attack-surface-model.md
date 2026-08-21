# Attack Surface Model

The attack surface is the union of every entry point through which untrusted data or
control can reach the system. Auditing begins by enumerating it completely.

## Dimensions of the Attack Surface

- **Network surface:** HTTP(S) endpoints, WebSocket, gRPC, RPC, admin ports, debug
  ports, exposed databases/caches, unauthenticated health/status endpoints.
- **Application surface:** every handler, resolver, route, callback, consumer,
  scheduled job, CLI command, file processor, webhook.
- **Parser surface:** every format the app parses (JSON, XML, YAML, multipart,
  archives, images, documents, serialized data) — each parser is an entry point.
- **Dependency surface:** every third-party package, transitive dependency, and the
  build/CI pipeline that produces the artifact.
- **Human surface:** admin consoles, support tools, dashboards, partner APIs.

## Method

1. Enumerate entry points from routes, framework registrations, and config, then
   **verify by grep for handler registration** (never trust a router file alone).
2. For each entry point record: method, auth requirement, input sources, sinks
   reachable, data returned.
3. Determine reachability: is the route mounted? behind auth? feature-flagged?
   versioned out? (`skills/reconnaissance/entrypoint-discovery.md`)
4. Bound the surface: in-scope vs out-of-scope components, documented.
5. Rank entry points by (sensitivity of reachable sinks) × (ease of access).

## Rules

- Unreachable code is not part of the attack surface; reachability must be verified.
- Every entry point in scope must be covered by the audit or explicitly waived.
- Admin/partner/internal endpoints are part of the surface even if "not public" —
  their exposure (port binding, reverse proxy rules, auth) must be verified, not
  assumed.
- Third-party parser surfaces (image/video/archive libs) are frequently the
  highest-risk surface; do not skip them (`skills/files/parser-security.md`).

## Output

An entry-point inventory: path, handler, auth, inputs, sinks, reachability,
sensitivity rank. This feeds `context/threat-modeling.md` and every workflow.

## Related

- `../skills/reconnaissance/entrypoint-discovery.md`
- `../skills/reconnaissance/endpoint-discovery.md`
- `../skills/reconnaissance/attack-surface-mapping.md`
- `../SECURITY_BOUNDARIES.md`
- `../workflows/full-project-audit.md`
