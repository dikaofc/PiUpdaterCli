---
name: api-validation
description: Validate API input/output — schema libs, error messaging, boundary rules, SSRF-safe URL checks. Use before wiring endpoints or when endpoints crash on bad input.
category: Backend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# API Validation

## Choice
- TypeScript: zod (canonical), or TypeBox with Fastify; Python: pydantic (built-in); Go: server-side struct tags or validator v10; keep one pattern per project.

## Rules
- Validate at the trust boundary (HTTP body, query, headers) — never inside services for self-called values.
- Schema == declared contract: request and response both; response validation catches breaking changes at dev time.
- Error output: field-level (`errors[].field` + code + message) mapping to 422; malformed JSON → 400 with generic message (no echo of raw input).
- Coercion end: `"userId": 5` vs "5" — decide once (zod `coerce` or strict `z.string()`); strict for ids (strings) to dodge `5 == "5"` mismatches.
- Limits: body size (e.g. 1mb), string max lengths (prevent memory bombs), pagination caps — all enforced in validation layer.
- Unknown fields: reject (strict) for mutations, ignore for reads (evolvability).
- URL input (fetch targets): validate scheme http(s) + hostname allowlist/denylist — block SSRF (`file://`, `http://localhost`, metadata IPs, DNS rebinding: resolve + re-check).

## Anti-patterns
- Validating in each handler ad hoc (drift); trusting `any` from client JSON; accepting oversized nested arrays (cap array length).

## Checklist
- [ ] Single schema source per endpoint
- [ ] Field-level errors → 422
- [ ] Body/array size caps
- [ ] Strict vs coerce decision documented
- [ ] URL inputs SSRF-checked