# Workflow: Configuration Audit

## Purpose

Audit application, framework, deployment, and environment configuration for
secrets handling, insecure defaults, dangerous flags, and drift between
environments.

## Method

### 1. Collect Configuration

- App config files, env templates, framework configs, deployment manifests,
  CI/CD config, cloud config, container configs
  (`skills/reconnaissance/configuration-discovery.md`).
- Secrets surface: env vars, config values, committed files, secret manager usage
  (`skills/secrets/secret-management.md`, `secret-surface-discovery.md`).

### 2. Check Against a Security Baseline

- Debug/verbose modes off in prod (`errors/debug-mode-analysis.md`).
- Secure defaults: cookies (HttpOnly, Secure, SameSite), CORS, CSP, headers
  (`web/security-headers.md`, `session/cookie-security.md`).
- Framework hardening flags (e.g., auto-escape, strict routing, no auto-reload).
- Timeouts, size limits, rate limits configured (`errors/timeout-analysis.md`).
- Logging level and redaction (`observability/logging-security.md`).
- Error pages do not leak internals (`errors/stack-trace-exposure.md`).

### 3. Secrets Analysis

- Hardcoded secrets in code/config (`secrets/hardcoded-secret-detection.md`).
- Env handling: defaults with real secrets? `.env` committed? key rotation?
  (`secrets/environment-secret-analysis.md`).
- Secret manager usage vs plaintext config (`secrets/key-management.md`).

### 4. Environment Drift

- Compare dev/staging/prod configuration; flag drift that weakens prod
  (`infrastructure/environment-analysis.md`).
- Check infra config: network exposure, ports, permissions
  (`infrastructure/network-exposure.md`, `port-exposure.md`,
  `filesystem-permissions.md`).

### 5. Verify & Report

- Confirm each risky setting in the actual deployed config artifacts (E2+).
- Report per template; each finding names the exact file/key/value and the
  required change.

## Output

- Configuration inventory with per-item security status.
- Findings (hardening + real exposures) with severity and remediation.

## Related

- `../skills/infrastructure/configuration-security.md`
- `../checklists/configuration.md`, `../checklists/secrets.md`
- `../skills/secrets/*`
