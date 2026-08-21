---
name: ssl-check
description: Audit TLS configuration — certificate chain, protocol versions, cipher suites, and config files.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18); needs network/openssl access only when endpoints must be probed — repo config review works offline.
metadata:
  category: security
  tags: [tls, ssl, certificates, ciphers]
---

# TLS / SSL C
<!-- built by @dikaacode (telegram) -->
heck

## Objective
Audit the TLS configuration of every service endpoint defined in the repository —
web servers, proxies (nginx/caddy/traefik/HAProxy), load balancers, internal
microservice TLS, and client TLS options — for certificate handling, protocol
versions, cipher suites, and config-file correctness. Findings are classified
confirmed / probable / possible / false-positive and fixed by editing config or code;
live probing is optional and clearly labeled.

## Preconditions
- TLS-relevant config/code exists in the repo (server creation, reverse-proxy
  configs, `tls:` blocks, cert paths) and is indexed (`cap index --refresh`).
- Certificates may be private material — do not copy their contents into the report.

## Workflow
1. Run `cap status` and `cap index --refresh`; find TLS surfaces with `cap search` for `https|listen 443|ssl_certificate|tls:|scheme:"https|createServer\(|requestCert|rejectUnauthorized|keyFile|certFile|certificates|ALPN|h2` and `cap explore` the server bootstrap.
2. Protocol versions: `cap show` each TLS config; verify TLS 1.2 and 1.3 are enabled, TLS 1.0/1.1 and SSLv2/SSLv3 are absent. Absent version pins on old platforms (Node < 10 / nginx < 1.11) default to insecure — flag as confirmed.
3. Cipher suites: check `ciphers`/`ssl_ciphers` lists for `RC4`, `DES`, `3DES`, `NULL`, `EXPORT`, `aNULL`, `CBC`-only suites for TLS 1.2, keys < 2048 bits RSA / < 256 bits ECC; verify TLS 1.3 suites are left to defaults. Weak-cipher config = confirmed; weak default when config absent = probable.
4. Certificate handling: `cap search` for cert paths and verification flags. Server side: chain completeness (leaf + intermediates), correct key match, expiry reminders (no fixed expiry config check — flag missing monitoring as LOW). Client side: `rejectUnauthorized: false`, `NODE_TLS_REJECT_UNAUTHORIZED=0`, custom verify callbacks that return `true`, or http instead of https for credentials = confirmed; `cap search` for those exact flags.
5. Config-file correctness: `cap show` nginx/caddy/traefik/HAProxy `server` blocks; check `ssl_protocols`, `ssl_ciphers`, `ssl_certificate`/`ssl_certificate_key` pairing, redirect from HTTP (301 to https), HSTS (`Strict-Transport-Security`) header, and `ssl_verify_client` where mutual TLS is required. OCSP stapling (`ssl_stapling`) present = good, absent = INFO.
6. Classify every finding (confirmed / probable / possible / false-positive per docs/review-engine.md) and fix: pin TLS 1.2+, modern cipher list, `rejectUnauthorized: true` for clients, chain/key fixes, HSTS with `IncludeSubDomains`; then `cap lint`, `cap typecheck`, `cap test`, `cap verify`, `cap diff` scope check.
7. Optional live probe (`openssl s_client -connect <host>:443` or `cap build`-produced service): label probe results as environment evidence, not repo facts; never store the probe output with private key material.

## Verification
- [ ] Every TLS surface inventoried (server, proxy, clients).
- [ ] Protocol versions and cipher suites checked per surface; TLS 1.2+/1.3 confirmed or flagged.
- [ ] Client `rejectUnauthorized:false` / `NODE_TLS_REJECT_UNAUTHORIZED` occurrences accounted for, each classified.
- [ ] Cert chain/key pairing verified or flagged; nothing of the cert body is reported.
- [ ] HTTP→HTTPS redirect and HSTS present on public entry points or flagged.
- [ ] Applied fixes pass `cap lint`, `cap typecheck`, `cap test`, `cap verify`; `cap diff` clean.

## Failure Handling
- If config for a surface is absent: state the default-version risk, classify probable unless a modern default is verifiable.
- If a live probe is impossible: mark those checks unverified rather than guessing at versions.
- If a legacy client depends on TLS 1.0: escalate the compatibility constraint instead of silently weakening defense.
- If mutual TLS is required but unconfigured: classify per the threat model and escalate if authentication depends on it.

## Output Format
Report: TLS surface inventory, per-surface verdict table (file, line, check:
versions/ciphers/certs/redirect/HSTS, classification, severity, evidence, fix),
applied config/code changes, optional probe results (labeled as external evidence),
and verification results.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap search`, `cap show`, `cap explore`, `cap test`, `cap verify`, `cap diff`.
- docs/review-engine.md §5 classification rules.