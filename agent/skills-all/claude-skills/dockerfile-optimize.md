---
name: dockerfile-optimize
description: Optimize Dockerfiles with multi-stage builds, layer caching, and best practices.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18); `docker` (or `buildah`/`podman`) available for build verification.
metadata:
  category: coding
  tags: [docker, dockerfile, build, layers, multi-stage]
---
<!-- ​​built by @dikaacode (telegram)​​ -->

# Dockerfile Optimize

## Objective
Refactor a project's Dockerfile to build smaller, faster, and more reproducibly: multi-stage builds that keep only production artifacts, dependency layers ordered for cache hits, and best-practice directives (non-root USER, pinned base images, deterministic metadata). Each optimization is verified by a real image build so layer-size and cache claims are measured, not guessed.

## Preconditions
- A Dockerfile exists and `cap repo` identifies its location and the project build entry points.
- Container build tooling is available (docker/podman/buildah) or the build can be delegated to a remote runner.
- The pre-optimization image size and build duration are measured and recorded.

## Workflow
1. Run `cap status` and `cap repo` to confirm the Dockerfile location; read it with `cap show Dockerfile` (or `compose.yaml` overrides).
2. Measure the baseline: build the image, record final size (`docker images`/`podman images`) and duration; store the facts via `cap memory add`.
3. Analyze the current stage layout with `cap search "FROM|RUN|COPY|ADD|RUN --mount"` line inventory; categorize layers as dependency-only, build-only, or production-run-needed.
4. Split into stages: a build stage (toolchains, `go build`/`npm ci && npm run build`/`pip install` wheels) and a runtime stage (`FROM <runtime-base>`), copying only the outputs — never the build toolchain.
5. Reorder for caching: copy dependency manifests (`package.json`+lock, `go.mod`+`go.sum`, `requirements.txt`) and run installs before copying source, so source edits do not invalidate the dependency layer. Prefer `--mount=type=cache` for package caches.
6. Apply best practices: pin base images to digests or a full version tag (no `latest`), add `USER` non-root after installs, set `WORKDIR`, write `EXPOSE` only for real ports, squash metadata (`--label`, `--build-arg` handled explicitly). Verify each against `cap rules check` for the project's container rules.
7. Rebuild and measure: confirm size and layer-count deltas, and prove cache behavior (`docker build --progress=plain` showing cached layers after a source-only change).
8. Run the project's verification pipeline (`cap verify`), and `cap diff` to confirm only Dockerfile/CI-related changes.
9. Record durable facts (`cap memory add`): final image size, base-image pins, and the cache layout contract.

## Verification
- [ ] Final image size is <= baseline (or a documented security/feature reason explains any increase).
- [ ] Build stage and runtime stage are separate; runtime image contains no build toolchain (`cap search "npm ci|go build|pip install"` absent from the runtime stage).
- [ ] Dependency layer is cacheable in isolation: a source-only change reuses it (shown in the plain-mode build log).
- [ ] Base image is pinned (digest or exact tag), non-root user set, and `latest`/`main` tags are absent.
- [ ] `cap verify` green; `cap diff` shows only Dockerfile/CI changes.

## Failure Handling
- Multi-stage split breaks the build: `cap rollback --task <id>` the Dockerfile, re-check missing copied artifacts with `cap show` on the stage list, and retry from that stage.
- A "cached" layer is stale (hash collision or missing `.dockerignore`): add/repair `.dockerignore`, re-run the build with `--no-cache` once to prove correctness, then re-verify caching.
- No container daemon available: deliver the byte-level Dockerfile refactor and a dry-run via `docker build --check`/`hadolint`-style lint only, stating the build/measure limitation explicitly.
- Size increase from a security fix (new base): report the trade-off with before/after numbers; never revert a security pin for size.

## Output Format
Final report:
- Before/after image size, layer count, and build duration (measured).
- Stage layout diagram (text), cache order, and any `--mount=type=cache` additions.
- Best-practice deltas applied (base pin, USER, .dockerignore, metadata) and `cap rules check` result.
- `cap verify` results and the final `cap diff` summary; any build-verification limitations.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap show`, `cap search`, `cap rules check`, `cap verify`, `cap diff`, `cap rollback`, `cap memory add`.