# Trust Boundaries

A trust boundary separates a lower-trust context from a higher-trust context. Every
crossing must be justified by explicit controls (validation, authorization,
encoding, canonicalization). The absence of a control at a crossing is the seed of a
vulnerability.

## Common Boundaries

| Boundary | Trust change | Control required |
|---|---|---|
| Client → API | untrusted → semi-trusted | authn, input validation, CSRF, size limits, CORS |
| API → Service | semi-trusted → application logic | authorization re-check, ownership, tenant scoping |
| Service → DB | app → data store | parameterization, least privilege, RLS |
| Service → External | app → third party | egress allow-list, URL validation, timeouts, no secret reuse |
| Tenant A → Tenant B | tenant → tenant | row-level isolation on every query, no global object ids |
| User → Admin | user → privileged | server-side role checks on every privileged op |
| App → OS | app → host | no shell composition, safe file paths, least privilege |
| Container → Host | container → host | read-only fs, no privileged mode, capability limits |
| CI → Deploy | pipeline → production | secrets via secret manager, artifact verification, approvals |
| App → Cloud | app → cloud resource | scoped IAM, no public storage, network policies |

## Analysis Method

1. For each entry point, walk the data until it reaches a sink; record each boundary
   crossed (`context/data-flow-analysis.md`).
2. At each boundary, ask: is there a control? Is it enforced at the right layer?
   Is it bypassable (e.g., control on one code path but not another)?
3. Identify boundaries enforced by convention only — comments, naming, frontend
   checks, "internal use only" — these are the highest-value bug locations.
4. Determine the trust level of each data source at each point of the flow and
   record it in the finding's Data Flow section.

## Rules

- The trust level of data is determined by where it crossed a boundary, not by its
  shape (a JSON field is still untrusted after JSON parsing).
- Re-authorization is required when crossing into a higher-privilege context
  (vertical escalation) or another tenant (horizontal).
- A boundary check that exists in only some code paths is a finding (inconsistent
  enforcement), not a design choice.
- Trust-boundary violations are reported with the specific crossing: name both
  sides and the missing control.

## Related

- `../SECURITY_BOUNDARIES.md`
- `../context/attack-surface-model.md`
- `../skills/reconnaissance/trust-boundary-discovery.md`
- `../skills/authorization/access-control-analysis.md`
