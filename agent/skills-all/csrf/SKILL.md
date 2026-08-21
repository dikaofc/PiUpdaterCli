---
name: csrf
description: CSRF / anti-CSRF bypass playbook — test state-changing endpoints (password/email change, transfer, settings, admin actions) for missing or bypassable CSRF tokens, same-site cookie protections, and CORS-enabled cross-site requests; chain with login CSRF or XSS if needed. Use when you see state-changing POST/JSON endpoints, or tokens that look static/derivable/shared across users.
allowed-tools:
  - http
  - shell
  - web_fetch
  - file_write
---

# CSRF playbook

Goal: determine whether a state-changing action can be triggered cross-site without the victim's consent, and produce a one-click PoC. Authorized targets only.

## 1. Inventory state-changing requests

Use browser capture or a log of your own session: password/email/phone change, payment/transfer, order states, settings toggles, admin user creation. Classify each:

- **No token at all** → CSRF by default (verify with the PoC below).
- **Token present** → test the bypasses in step 3.
- **JSON endpoints**: if the app accepts `application/json` and doesn't check the Content-Type, a plain form POST may still hit it — or use `form-encoded` variants the server tolerates.

## 2. Prove it with a PoC page

```html
<!-- victim visits this attacker page; submit fires on load -->
<form action="https://TARGET/account/change-email" method="POST" id="x">
  <input name="email" value="attacker@example.com">
</form>
<script>document.getElementById('x').submit()</script>
```

Test the same request with curl, then with `Origin: null` / `Origin: https://evil.com` headers (a CSRF token that is accepted with a mismatched Origin is bypassable):

```sh
curl -ksS -X POST "https://TARGET/account/change-email" \
  -H "Origin: https://evil.com" -d "email=attacker@example.com"
```

If the state change succeeds without a valid token → confirmed.

## 3. Token bypasses to test

- Token sent, not validated: remove it → still 200.
- Token is the session token / static / predictable (same value for all users, or derived from email/username).
- Token bound to session but the check only verifies *a* token is present, not the right one.
- Token in a cookie the browser sends cross-site anyway (no SameSite) + a non-Googlable GET-based token check.
- **Cookie-scoped defenses**: token stored in a cookie with `SameSite=Lax` — bypass with `GET` for top-level navigations (Lax allows GET) if the action accepts GET; or with `rel="noopener"`/`window.open` top-level GET chains.
- Login CSRF: if login itself is CSRF-able and the session cookie lacks `SameSite=Strict`, silently log the victim into the attacker's account.

## 4. Chain (only if the primitive needs it)

- XSS anywhere → full bypass of all CSRF protections (report as XSS with CSRF chaining note).
- CORS misconfig (see cors skill): if `Access-Control-Allow-Origin: <reflecting Origin>` + `Allow-Credentials`, an attacker script can read the token/state and replay it — combine findings.

## 5. Reporting

Evidence: the curl request (with/without token and Origin) that succeeded, or the PoC HTML. Impact: account modification/transfer/password change without consent, admin actions, login CSRF. Remediation: per-request random tokens bound to session, `SameSite=Strict/Lax` cookies, origin validation for JSON, CSRF tokens on all state-changing verbs.

When reproduced with a successful state change, call `confirm_finding`.