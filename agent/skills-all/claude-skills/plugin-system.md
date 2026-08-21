---
name: plugin-system
description: Design a safe, discoverable plugin system with contracts and isolation.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: architecture
  tags: [plugin, extensibility, architecture]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Plugin / Extension Architecture

## Objective
Let third parties extend the system without destabilizing the core.

## Preconditions
- `cap repo` run; extension points and current hooks reviewed (`cap explore <plugin|hook|extension>`).

## Workflow
1. Run `cap explore` for existing hooks/extension points and their call sites.
2. Define a stable plugin interface (lifecycle: load, init, dispose) and a manifest schema.
3. Isolate plugins (sandbox/process boundary) where they can run untrusted code.
4. Validate manifests and capabilities; deny-by-default for sensitive APIs.
5. Provide discovery/registration and a clear error boundary per plugin.
6. Record the plugin contract with `cap memory add`.

## Verification
- [ ] Stable lifecycle interface.
- [ ] Manifests validated + capabilities scoped.
- [ ] Unsafe APIs denied by default.
- [ ] Plugin errors isolated.

## Failure Handling
- If plugins crash core, run them out-of-process.
- If API leaks, version the host interface.

## Output Format
Plugin design: interface, manifest, isolation, capability model, and error boundary.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
