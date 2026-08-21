# Checklist: Infrastructure

Verification checklist for infrastructure, containers, and deployment.

## Network & Exposure

- [ ] Only required ports exposed (`port-exposure.md`, `network-exposure.md`)
- [ ] No debug/admin/management interfaces public (`service-configuration.md`)
- [ ] Reverse proxy rules correct; no path/header smuggling
  (`reverse-proxy-analysis.md`)
- [ ] TLS configured correctly (`tls-configuration.md`)

## Filesystem & Process

- [ ] Filesystem permissions least-privilege (`filesystem-permissions.md`)
- [ ] Process runs as non-root; capabilities limited (`process-permissions.md`)
- [ ] Temp files cleaned; no world-writable dirs used

## Containers

- [ ] Image minimal, pinned, scanned (`docker-security.md`, `container-security.md`)
- [ ] No privileged containers; read-only root fs where possible
- [ ] Secrets not baked into images (`image-security.md`)

## Environment & Config

- [ ] Environment separation; no prod config in dev (`environment-analysis.md`)
- [ ] Config validated at load; insecure defaults overridden
  (`configuration-security.md`)
- [ ] Resource limits set (memory, CPU, descriptors)

## Related

- `../skills/infrastructure/*`, `../skills/containers/*`
- `../checklists/configuration.md`
