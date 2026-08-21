# Pattern: Secure Authentication

## Problem

Users must be identified reliably, credentials must not be guessable, stealable, or
reversible, and authentication must not be bypassable.

## Design

1. **Server-side verification only.** Authentication state is established and
   verified server-side; the client never asserts identity.
2. **Password storage:** use a strong adaptive KDF (Argon2id, scrypt, bcrypt with
   cost ≥ 10); unique random salt per user; never reversible/plaintext/encrypted
   passwords (`skills/authentication/password-storage.md`).
3. **Session tokens:** cryptographically random (CSPRNG), server-side state (or
   signed tokens with strict validation), bound to user and device, HttpOnly +
   Secure + SameSite cookies (`skills/session/session-management.md`).
4. **Login hardening:** server-side rate limiting per account/IP, delay on failure,
   CAPTCHA when needed, credential-stuffing checks (have-i-been-pwned style
   allow-lists) (`skills/authentication/bruteforce-defense.md`).
5. **Account enumeration prevention:** uniform responses and timing for
   login/register/reset (`skills/authentication/account-enumeration.md`).
6. **MFA:** TOTP or passkeys for privileged actions; MFA not bypassable via
   alternate flows (`skills/authentication/mfa-analysis.md`).
7. **Password reset:** single-use expiring tokens, tied to user, no user-controlled
   account switching during reset (`skills/authentication/password-reset.md`).
8. **OAuth/OIDC:** validate redirect URIs, state/nonce, audience/issuer, PKCE
   (`skills/session/oauth-analysis.md`).

## Verify

- Negative tests: wrong password, disabled account, expired session, wrong OTP,
  replay of reset token.
- Enumerate checklists: `../checklists/authentication.md`.

## Anti-Patterns

- Client-side auth flags; storing secrets in localStorage; plaintext passwords;
  timing-leaking responses; infinite session lifetime.

## Related

- `../skills/authentication/*`, `../skills/session/*`
- `../checklists/authentication.md`
