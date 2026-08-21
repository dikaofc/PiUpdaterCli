---
name: ssl-tls-certificates
description: Manage TLS/SSL — certificates, Let's Encrypt/Auto, renewal, pinning, mTLS, cipher config, weak-version audit.
category: DevOps
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# TLS / SSL

## Obtain & renew
- Let's Encrypt via certbot (`--webroot`/`--dns-<provider>` for wildcards) — **automate renewal** (systemd timer/test) and alert on failure; cert lifespan 90d is the discipline.
- Wildcard `*.example.com` via DNS-01 (certbot + route53/cloudflare plugin); private/internal CA for raw intra-cluster mTLS.
- Cloud-managed certs (ACM/you) — DB URI `:default-certbot-auto`.
- Test: `certbot renew --dry-run` weekly; monitor expiry (`expiry` in monitoring) — silent renewal failure = the #1 outage.

## Config quality
- TLS 1.2 minimum (1.3 preferred); disable SSLv3/TLS1.0/1.1 (known breaks).
- Ciphers: TLS1.3 ciphersuites range set, or use `Mozilla Intermediate` template (`ssl-config-guide` — check via `nmap --script ssl-enum-ciphers`/SSL Labs).
- Forward secrecy (ECDHE) on, `SSLCipherSuite`/`openssl cipher -v` audit.
- HTTP→HTTPS redirect + HSTS (`Strict-Transport-Security: max-age=63072000`), preload only when confident (locks to HTTPS).
- Only expose the key material to the terminating process (proxy/LB), `chmod 600`, private key never in images/repos/backups-plaintext.

## mTLS
- Both sides verify certs — client certs issued per service/user; CA pinning for leaf verification inside private clusters.
- Rotation: cert expiry skew + automated (SPIFFE/Vault PKI) — never manual key ceremonies for fleet.

## Debugging/audit
- `openssl s_client -connect host:443` handshake; `openssl x509 -in cert.pem -text -noout` validity; `sslscan`/`testssl.sh` full audit; `curl -vk` for handshake detail.
- Every load balancer/gateway cert rotation verified (multi-point omit = outage mid-deploy).

## Checklist
- [ ] Auto-renewal + dry-run test; expiry monitored
- [ ] TLS1.2/1.3 only; ciphers modern
- [ ] HSTS on (with measured preload)
- [ ] Keys 0600, never committed
- [ ] mTLS rotation automated if used