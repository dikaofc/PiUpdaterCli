---
name: owasp-review-checklist
description: Run an OWASP Top 10 code review — systematic per-category checks for application security review.
category: Security
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# OWASP Top 10 Review Checklist

## Method
Read routes/endpoints, then per-category below; evidence > assumption; note (vuln, file:line, severity, attack scenario).

1. **A01 Broken Access Control**
   - [ ] Each route: auth required? ownership checked on object access (IDOR)?
   - [ ] Batch endpoints check per-item; admin-only actions enforced server-side
   - [ ] File/path traversal blocked (`../`, absolute paths)
   - [ ] CORS scoped; no `*`+credentials

2. **A02 Cryptographic Failures**
   - [ ] TLS everywhere; no cleartext secrets/logs
   - [ ] Argon2id/bcrypt ≥12 for passwords; no MD5/SHA1 for secrets
   - [ ] Data at rest encrypted where required (PII)

3. **A03 Injection**
   - [ ] Parameterized SQL (no concat); NoSQL operator sanitized
   - [ ] No `eval`/`exec`/`child_process` with user input
   - [ ] Templates escape HTML (no dangerous sinks w/o sanitizer)

4. **A04 Insecure Design**
   - [ ] Rate limits on auth/expensive endpoints; locks on money ops
   - [ ] Trust boundaries mapped; validation at each
   - [ ] Defaults safe (no insecure demo config)

5. **A05 Security Misconfiguration**
   - [ ] Verbose errors off in prod; headers set (`web-security-headers`)
   - [ ] Debug/demo endpoints removed; least-privilege roles

6. **A06 Vulnerable Components**
   - [ ] Deps audited (scanner) + pinned; known CVEs mapped to reachability

7. **A07 Identification & Authentication Failures**
   - [ ] Sessions/JWT rules (`authentication-session`); no default/weak creds
   - [ ] Lockout/rate limit; password policies sane

8. **A08 Software/Data Integrity**
   - [ ] Deserialization safe (no pickle/unsafe JSON eval); signed updates
   - [ ] CI supply chain (lockfiles, no unpinned downloads)

9. **A09 Logging & Monitoring**
   - [ ] Authn failures, perm changes, admin actions logged + alerted
   - [ ] No secrets in logs; PII redacted

10. **A10 SSRF**
    - [ ] URL inputs scheme/hostname whitelisted + resolve-checked

## Output format
Findings list: `[A0X] file:line — issue — attack — severity(crit/high/med/low)`. Fixes prioritized by exploitability + reachability, not scanner noise. Re-review after fix to confirm the vector is closed.

## Checklist
- [ ] All 10 categories covered with evidence
- [ ] Findings ranked by severity + reachability
- [ ] Fixes applied + vector re-tested
- [ ] No assumptions left unverified (tested, not claimed)