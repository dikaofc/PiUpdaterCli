---
name: docker
description: Write minimal, reproducible Dockerfiles and Compose setups for dev and prod parity.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: devops
  tags: [docker, container, devops]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Dockerization

## Objective
Containerize a service with small images, layer caching, non-root runtime, and a health check.

## Preconditions
- `cap repo` run to know the build/runtime and entrypoint.
- Existing Dockerfile scanned with `cap explore dockerfile` if present.

## Workflow
1. Run `cap repo` and `cap show` the entrypoint/build script to learn the real start command.
2. Choose a multi-stage build: deps stage, build stage, minimal runtime stage (distroless/alpine).
3. Pin base image by digest where feasible; sort and dedupe RUN layers to maximize cache hits.
4. Run as non-root, drop capabilities, and add a `HEALTHCHECK` that probes a real endpoint.
5. Externalize config/secrets via env; never bake secrets into the image.
6. Verify with `cap verify`/`cap build` locally and record the image size budget with `cap memory add`.

## Verification
- [ ] Image builds reproducibly.
- [ ] Runs as non-root with a healthcheck.
- [ ] No secrets in image layers.
- [ ] Dev and prod use the same image (tag differs only by env).

## Failure Handling
- If build is slow, cache dependency installs before source copy.
- If base image unavailable offline, document the registry/mirror requirement.

## Output Format
Dockerfile + Compose: stages, base pins, user/healthcheck, volume/env map, and the local build/run verification result.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
