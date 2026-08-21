# Checklist: Authentication

Verification checklist for authentication flows.

## Flow Coverage

- [ ] Register / login / logout / reset / verify / MFA flows mapped and tested
- [ ] Every protected endpoint actually requires authentication (no gap)
- [ ] Authentication callbacks (OAuth, SAML, webhooks) validate state/nonce and
  redirect URIs
- [ ] Login state machine handles invalid transitions (`login-state-machine.md`)

## Credentials

- [ ] Passwords stored with a strong KDF, unique per user, salted
  (`password-storage.md`)
- [ ] Password policy enforced server-side (`password-policy.md`)
- [ ] No plaintext or reversible password storage; no passwords in logs
- [ ] Credential stuffing defenses: allow-list checks, delay, CAPTCHA
  (`credential-stuffing-defense.md`)
- [ ] Brute-force defense: per-account + per-IP rate limiting, lockout with safe
  unlock (`bruteforce-defense.md`)
- [ ] Account enumeration: login/register/reset responses are indistinguishable
  (`account-enumeration.md`)

## Tokens & Sessions

- [ ] Session tokens random, bound to user, regenerated on privilege change
  (`session-management.md`)
- [ ] No session fixation (`session-fixation.md`)
- [ ] Expiration and idle timeout enforced (`session-expiration.md`)
- [ ] Logout invalidates server-side and all devices (`logout-security.md`)
- [ ] JWT: algorithm allow-listed, signature verified, expiry/audience/issuer
  checked (`jwt-analysis.md`)
- [ ] OTP/MFA: verification rate-limited, no bypass path (`otp-analysis.md`,
  `mfa-analysis.md`)

## Environment

- [ ] MFA available/enforced per risk policy
- [ ] Email verification required before sensitive actions (`email-verification.md`)
- [ ] Password reset tokens single-use, expiring, tied to user
  (`password-reset.md`)

## Related

- `../workflows/auth-audit.md`
- `../skills/authentication/*`, `../skills/session/*`
