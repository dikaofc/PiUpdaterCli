---
name: file-upload
description: Unrestricted file upload playbook — test upload endpoints for extension/content-type/magic-byte validation bypass, web-accessible upload paths, and stored XSS via SVG/HTML; escalate a working upload to RCE when the server executes the file. Use when the target has profile pictures, attachments, document, avatar, resume, or file import features.
allowed-tools:
  - http
  - shell
  - file_write
---

# File upload playbook

Goal: turn a file-upload feature into a proven impact (stored XSS → any-user execution, or RCE if the server runs uploads). Only test upload endpoints you are authorized to hit.

## 1. Map the upload path

- Find the upload endpoint (multipart POST), the storage folder from response/errors/JS, and the URL that serves an uploaded file: `/uploads/<id>`, `/media/<name>`, `/static/...`.
- Upload a benign file first (e.g. `pf-<rand>.txt`) to confirm the path is under YOUR control and web-accessible.

## 2. Bypass extension filters

Test one axis at a time and note which check it defeats:

```sh
# case / trailing chars / double ext / polyglot
pf.php, pf.pHp, pf.php5, pf.phtml, pf.php.png, pf.png.php, pf.php%00.png
pf.php/., pf.php\., pf.php + space, pf.php., pf..php
# allowed-ext list: .jpg.php,.php.jpg,.php%00.jpg,.php%0A.jpg,.php#.png
```

Content-type/header tricks: set `Content-Type: image/png` while sending PHP; add `GIF89a` magic bytes before PHP code; multi-part with trailing junk; `filename="pf.php"` vs `filename*=` in the filename param.

## 3. Confirm execution

```sh
# if it executes, prove it non-destructively
curl -ksS "https://TARGET/uploads/pf.php"                      # does it run or download?
curl -ksS "https://TARGET/uploads/pf.php?c=id"                 # only if the shell reads $_GET
```

If it downloads instead of executes, fall back to non-executable impact:

- **Stored XSS** with a polyglot: upload `pf.svg` containing `<svg onload=alert(document.domain)>` or an HTML file with a script — confirm it renders in a victim context (profile view, admin review).
- **Malicious parsing**: crafted image triggering CVE in the image processor / decompression bomb — only if you have a matching advisory.
- **Overwrite/phish**: if upload paths are predictable, test overwriting existing files (avatar of another user) — that is broken access control on uploads (see idor skill).

## 4. Escalation to RCE (authorized labs only)

- Apache: double ext / `.htaccess` upload that maps `.png` to PHP — then backdoor a .png.
- IIS: `.asp`, `.aspx`, `web.config` tricks.
- Nginx+PHP-FPM: upload to a directory with a misconfigured `fastcgi` that executes the uploaded extension; test `.php` in `/uploads`.
- Any feature that *processes* the file server-side (ImageMagick, ffmpeg, document convert) → weaponize the matching CVE if one exists (see cve skill).

## 5. Reporting

Evidence: the upload request, the URL where the file lives, and what happened when you fetched it (executed vs stored XSS renders). Impact: server-side RCE or stored XSS affecting every user who views the file. Remediation: extension allowlist + content sniffing, store outside webroot, serve with `X-Content-Type-Options: nosniff`, sandbox processing.

When you can fetch and demonstrate the result, call `confirm_finding`.