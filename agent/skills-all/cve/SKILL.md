---
name: cve
description: Known-CVE hunting playbook — fingerprint the exact product/version (banners, headers, hashes, distinctive assets), then match against public advisories and test the exact CVE PoC with a real request. Use when the target shows a versioned product (nginx, Apache, OpenSSL, WordPress + plugins, Jenkins, Confluence, GitLab, Laravel, Express, Apache Tomcat, etc.) and you want to turn a version banner into a proven finding instead of a guess.
allowed-tools:
  - http
  - shell
  - web_search
  - web_fetch
  - file_write
---

# Known-CVE hunting playbook

Goal: turn version fingerprints into matched, reproduced CVEs. Never report a CVE on version match alone — reproduce it (or a safe verification) before `confirm_finding`.

## 1. Fingerprint the stack

```sh
curl -ksS -I "https://TARGET" | grep -iE "server|x-powered-by|x-aspnet|via"
curl -ksS "https://TARGET" | grep -oiE "generator[^>]*|wp-content[^>]*|/?[a-z]+/version|appversion[^>]*" | head
```

Collect: web server + version, framework, CMS + plugins, JS bundle names with hashes, `/robots.txt`, `/sitemap.xml`, error pages, `telnet`/SMTP/SSH banners if non-web ports are in scope. Compute a file hash (e.g. a known unpatched JS asset) if versions are hidden:

```sh
curl -ksS "https://TARGET/assets/app.js" | sha256sum
```

## 2. Match against advisories

Use `web_search` for `<product> <version> CVE <year>` and prefer primary sources: vendor advisory, NVD, official GitHub issue/fix commit. For each candidate extract: vulnerable versions, the exact CVE ID, and a verified PoC URL.

## 3. Reproduce safely

- Prefer the advisory's own PoC or a widely-verified one; adapt it to the exact endpoint/path.
- Avoid destructive payloads (RCE with `id` to prove execution is fine; do not delete data, deploy implants, or scan third parties).
- If the PoC is destructive-only, use a **safe check** instead (version + patch-status leak, response difference for a benign trigger) and say so in the finding.

```sh
# example shape: path-based PoCs like CVE-2021-41773 (path traversal in Apache 2.4.49)
curl -ksS "https://TARGET/cgi-bin/.%2e/%2e%2e/%2e%2e/etc/passwd"
```

## 4. Chain impact

A matched CVE often unlocks the rest of the engagement (RCE → read configs → pivot; SSRF → cloud metadata; SQLi → dump). Note the chain in the finding's impact section.

## 5. Reporting

Evidence: fingerprint (server banner/hash) + the exact request that reproduced the CVE + the response proving it. Impact: describe what the CVE grants at this specific target. Remediation: upgrade to the patched version listed in the advisory (cite it).

When you have a reproduced CVE response (not just a banner), call `confirm_finding`. If all you have is the banner match, report it with a lower severity as a version-exposure note.