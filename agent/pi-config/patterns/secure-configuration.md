# Pattern: Secure Configuration

## Problem

Configuration must be validated, secret-free, environment-correct, and hardened
against insecure defaults.

## Design

1. **Validate at load.** Config schema validation (required keys, types, ranges);
   fail fast on invalid or missing configuration; never silently fall back to
   insecure defaults (`skills/infrastructure/configuration-security.md`).
2. **Secrets out of config.** Secrets injected at runtime from a secret manager
   (`skills/secrets/secret-management.md`); no secret defaults.
3. **Environment separation.** Separate dev/staging/prod config; drift checks;
   production overrides only in production
   (`skills/infrastructure/environment-analysis.md`).
4. **Hardened framework defaults.** Secure cookies, auto-escaping, CSRF
   protection, strict routing; explicitly disable debug/verbose modes in
   production (`skills/errors/debug-mode-analysis.md`).
5. **Boundary limits configured:** timeouts, max sizes, rate limits, pool sizes
   (`skills/errors/timeout-analysis.md`).
6. **Config changes reviewed like code** (PR review, tests, changelog).

## Verify

- Configuration audit workflow (`../workflows/configuration-audit.md`);
  `../checklists/configuration.md`.

## Anti-Patterns

- `if env == "prod" else insecure_default`; config that disables security
  features by default; committed `.env` files.

## Related

- `../skills/infrastructure/configuration-security.md`
- `../checklists/configuration.md`
