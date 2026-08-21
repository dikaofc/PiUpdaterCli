# Checklist: Configuration

Verification checklist for application and deployment configuration.

## Insecure Defaults

- [ ] Debug/verbose/dev mode disabled in production
  (`debug-mode-analysis.md`)
- [ ] Framework hardening flags enabled (auto-escape, strict mode, secure
  cookies, CSRF protection)
- [ ] No default credentials or default admin accounts
- [ ] Timeouts and size limits configured for all external boundaries
  (`timeout-analysis.md`)

## Secrets

- [ ] No secrets in config files; env injection via secret manager
  (`secret-management.md`)
- [ ] Config validation at load; invalid config fails fast

## Environment

- [ ] Dev/staging/prod configuration separated and drift-checked
  (`environment-analysis.md`)
- [ ] No prod-only settings accidentally enabled in dev that weaken prod
- [ ] Config changes reviewed like code changes

## Web Config

- [ ] Cookies: HttpOnly, Secure, SameSite (`cookie-security.md`)
- [ ] CORS allow-list restrictive (`cors-analysis.md`)
- [ ] Security headers and CSP configured (`security-headers.md`,
  `content-security-policy.md`)

## Related

- `../skills/infrastructure/configuration-security.md`
- `../workflows/configuration-audit.md`
