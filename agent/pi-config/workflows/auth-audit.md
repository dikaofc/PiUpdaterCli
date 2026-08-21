# Workflow: Auth Audit

## Purpose

Focused audit of authentication and authorization: identity flows, session
management, access control, and privilege boundaries. Highest-value surface in most
applications.

## Method

### 1. Map the Auth Architecture

- Identify auth mechanisms: session cookies, tokens (JWT/opaque), OAuth/OIDC,
  SSO, API keys, MFA (`authentication/authentication-flow-analysis.md`).
- Map every protected resource and the enforcement point (middleware, decorators,
  gateways, per-handler).
- List privileged functions and admin surfaces (`authorization/admin-function-protection.md`).

### 2. Authentication Checks

- Flow analysis: register, login, logout, reset, verify, MFA, OAuth callback
  (`skills/authentication/*`, `skills/session/*`).
- Password handling: policy, storage (cost, salt), no plaintext/logs
  (`password-policy.md`, `password-storage.md`).
- Brute force / credential stuffing defenses (`bruteforce-defense.md`,
  `credential-stuffing-defense.md`).
- Account enumeration (login/register/reset differences) (`account-enumeration.md`).
- Session lifecycle: fixation, expiration, revocation, logout everywhere
  (`session/session-management.md`, `session-fixation.md`, `session-expiration.md`,
  `logout-security.md`).
- Tokens: JWT algorithm/expiry/audience validation (`jwt-analysis.md`); token
  storage and replay (`token-replay.md`).
- OAuth/OIDC: redirect URI validation, state/nonce, token leakage
  (`oauth-analysis.md`, `oidc-analysis.md`).
- MFA/OTP: verification, rate limiting, bypass paths (`mfa-analysis.md`, `otp-analysis.md`).

### 3. Authorization Checks

- Function-level: can a lower-privilege caller reach admin functions? (BFLA,
  `bfla-analysis.md`, `vertical-privilege-escalation.md`).
- Object-level: can a caller reach objects they do not own? (IDOR/BOLA,
  `idor-analysis.md`, `bola-analysis.md`, `resource-ownership.md`).
- Roles & permissions: role analysis, permission inheritance, client-supplied
  roles (`role-analysis.md`, `permission-inheritance.md`,
  `client-side-authorization.md`).
- Enforcement location: server-side only (`server-side-authorization.md`).
- Multi-tenancy isolation on every query (`database/database-access-control.md`).

### 4. Verify & Report

- Reproduce each bypass candidate safely (E3) with the lowest privilege that
  should be denied.
- Report per report template; each auth finding must state the exact enforcement
  gap (which check is missing/where).

## Output

- Auth architecture map, enforcement-point inventory, per-check results.
- Findings with evidence, severity, confidence, remediation, regression tests
  (e.g., "unauthenticated request to X returns 401" / "tenant B cannot read
  tenant A object").

## Related

- `../checklists/authentication.md`, `../checklists/authorization.md`
- `../skills/authentication/*`, `../skills/session/*`, `../skills/authorization/*`
- `../workflows/api-audit.md`
