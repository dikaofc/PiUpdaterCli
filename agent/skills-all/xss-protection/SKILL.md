---
name: xss-protection
description: Prevent XSS — output encoding, CSP, sanitization, DOM sinks, postMessage/XSS in routing. Use when building anything rendering user content.
category: Security
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# XSS Protection

## Model: context-based output encoding
Every place user data lands has a context with its own rule:
- HTML text → encode `<>&` (`&lt;`, `&gt;`, `&amp;`).
- Attribute → encode quotes + `<` (`&quot;`), never `javascript:` schemes.
- URL → whitelist schemes (http/https) before `href`.
- JS string → JSON-encode + never into `innerHTML`/`eval`/`new Function`/`document.write`/`insertAdjacentHTML`/`<script src>`.
- CSS → never user input in `style` values (url()/expression); sanitize if allowed.

## Framework reality
- React/Vue/Svelte escape text nodes by default → defeat is opting into `dangerouslySetInnerHTML`/`v-html`/`{@html}` — those need **sanitizer** (DOMPurify, sanitize-html) with allowlist + config per type (rich-text=micro copy-paste of rules).
- Markdown → render via lib configured to escape raw HTML (or strip `<script>`); re-sanitize output paths.
- URL hash/router: `location.hash`/`location.search` parsed with `URL`, whitelist; `window.open`/`target=_blank` — add `rel="noopener noreferrer"`.

## CSP as backstop (not primary)
- Strict-ish CSP (`script-src 'self'` + nonce for inline) blocks many payload classes even when encoding slips; watch violation reports (`web-security-headers`).
- **XSS in attributes via `<img onerror>`** — blocked by `script-src`, covered by encoding.

## Dangerous sinks checklist (grep)
- `innerHTML`/`outerHTML`/`document.write`/`insertAdjacentHTML`/`eval`/`new Function`/`setAttribute('src'|'href'|'style')` from input/`postMessage` handlers.
- `postMessage`: validate `event.origin` allowlist before acting; never trust event.data into sinks.
- Storage (localStorage/session) content re-rendered → treat as untrusted, same encoding rules.

## Verification
- Test payloads: `<img src=x onerror=alert(1)>`, `"><svg onload=alert(1)>`, `javascript:alert(1)`, `'';!--"<XSS>='&{()}` — grep/search and automated DOM-XSS scanner (semgrep/CodeQL rules).

## Checklist
- [ ] Output encoded per context at every dynamic render
- [ ] dangerouslySetInnerHTML/v-html/{@html} paths sanitized
- [ ] No input into dangerous sinks
- [ ] postMessage origin-checked
- [ ] CSP set + reports monitored