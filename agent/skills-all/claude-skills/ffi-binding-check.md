---
name: ffi-binding-check
description: Verify native/FFI bindings (N-API, ffigen, node-gyp) for platform compatibility, ABI correctness, and call-safety.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18); the check is read-only unless a fix is explicitly requested.
metadata:
  category: review
  tags: [ffi, napi, native, binding, n- api]
---

# FFI / Native Binding Check
<!-- ​​ built by @dikaacode (telegram) ​​ -->

## Objective
Audit native and FFI bindings — N-API (Node), ffigen (Dart), node-gyp, and raw foreign-function declarations — for platform/architecture compatibility, ABI signature correctness, and call-safety (null checks, memory ownership, error propagation). Produce a compatibility matrix and a fix list; do not modify code unless asked.

## Preconditions
- Binding sources located: search for `binding.gyp`, `*.node`, `ffigen_config.yaml`, `@ffi/gen` output, `ffi` declarations (`cap search`).
- The target platforms/architectures to check against are stated (default: current OS/arch plus common CI targets).
- Read-only audit unless a fix is explicitly requested.

## Workflow
1. Run `cap status` and `cap index --refresh` to establish repo state and index the binding sources.
2. Locate all binding artifacts: `cap search` for `binding.gyp`, `prebuilds/`, `*.node`, `ffigen*`, `ffi`/`dart:ffi` imports, `napi_*` calls; record the list with `cap show` reads.
3. Map the ABI surface: for each binding, record the foreign symbol names, signatures (args/return types/sizes), the declared target ABI (N-API version, `node-gyp` config, ffigen `headers`), and the wrapper types used.
4. Platform-matrix check: for each symmetric pair (symbol, target platform `linux/darwin/win32` x `x64/arm64`) verify header availability, `process.arch` / `Platform` version guards, prebuilt-binary presence, and `libc` assumptions; record gaps.
5. ABI correctness: cross-check every C signature against the declaration in the FFI layer — pointer-vs-byte-size arguments, `int` vs `size_t`, string encoding (UTF-8 vs wide), struct layout and alignment (ffigen `struct` sizes, N-API `napi_typeof` expectations). Use `cap explore <symbol>` to trace how each call is invoked from app code.
6. Call-safety pass: for each call site check null-pointer handling, memory ownership (malloc/free pairing, `calloc` vs `free`), buffer lifetime (unfreed allocations on error paths), and error propagation from native status codes to `errno`/exceptions.
7. Runtime probe (optional, if binaries exist for this platform): load the binding in the project's runtime and call a no-op/canonical path under `cap test` or a targeted probe script; record the outcome.
8. Compile the compatibility matrix and findings with severity: blocker (won't link/crash), warning (silent corruption risk), info (style).
9. If fixes are requested: patch the smallest unit (include guard, arch guard, signature cast fix), then run `cap verify` and `cap test` and show `cap diff`.

## Verification
- [ ] All binding artifacts located (gyp/native/ffigen/prebuilt) and inventoried.
- [ ] ABI surface mapped: symbols, signatures, target ABI, wrapper types.
- [ ] Platform matrix filled per (symbol x platform/arch) pair with evidence.
- [ ] Signature/struct-layout cross-check completed against headers or documented ABI.
- [ ] Call-safety pass covers null, ownership, buffers, error propagation.
- [ ] If a runtime probe was run: recorded outcome (pass/fail per probe).
- [ ] If fixes applied: `cap verify` passes and `cap diff` shows only intended edits.

## Failure Handling
- If a target platform cannot be checked (no headers/prebuilts for it): mark UNKNOWN, never assume compatibility.
- If a signature mismatch could corrupt memory (size mismatch, wrong pointer type): elevate to blocker, cite the two declarations, and do not patch without user approval.
- If the runtime probe crashes: isolate the crash to the binding call site, report the stack, and do not retry blindly.
- If `cap verify` fails after a fix: roll back with `cap rollback --task <id>`, re-apply with a narrower patch, and re-verify.

## Output Format
Final report:
- Binding inventory (artifacts, target ABIs, platforms).
- Compatibility matrix: symbol x platform/arch -> OK / UNKNOWN / FAIL with evidence.
- Findings: severity, file:line, the declaration pair in conflict, suggested fix.
- Runtime probe results (if run).
- Verification results (`cap verify`, `cap test`, `cap diff`).

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap index --refresh`, `cap search`, `cap show`, `cap explore`, `cap verify`, `cap test`, `cap diff`, `cap rollback`.