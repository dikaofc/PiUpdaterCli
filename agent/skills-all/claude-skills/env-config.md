---
name: env-config
description: Separate config from code with typed, validated, environment-scoped settings.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [config, environment]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Environment & Config Management

## Objective
Make configuration external, validated, and environment-aware without restarts surprises.

## Preconditions
- `cap repo` run; current config sources reviewed (`cap explore <config|env|settings>`).

## Workflow
1. Run `cap explore` for where config is read and hardcoded.
2. Externalize all env-specific values; keep code free of environment literals.
3. Validate config at startup (schema) and fail fast on missing/invalid values.
4. Layer precedence: defaults < file < env; document each setting.
5. Keep secrets out (see secrets-management); log config shape without values.
6. Record the config schema with `cap memory add`.

## Verification
- [ ] No env literals in code.
- [ ] Startup validation present.
- [ ] Precedence documented.
- [ ] Secrets not logged.

## Failure Handling
- If config invalid mid-run, validate at boot not lazily.
- If too many flags, group into profiles.

## Output Format
Config design: schema, precedence, validation, and the documented settings list.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
