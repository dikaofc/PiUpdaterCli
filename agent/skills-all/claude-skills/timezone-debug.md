---
name: timezone-debug
description: Debug timezone/DST bugs by inspecting the actual tz source, storing/compare/rendering in UTC, and testing offset boundaries.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: debugging
  tags: [timezone, dst, utc, offset]
---

# Timezone Debug
<!-- built by @dikaacode (telegram) -->

## Objective
Pin a wrong-time bug to one of the three time layers — capture, storage, rendering — by inspecting the real tz source (OS tzdata, `Intl`, env `TZ`) for the affected moment and offset, then enforce UTC-at-boundary or offset-explicit rendering, proven by boundary tests around DST transitions.

## Preconditions
- The wrong time is observable (log line, stored value, rendered UI) along with the wall-clock it should have shown.
- The affected zone and instant are known or discoverable from the symptom.
- Repository is indexed (`cap index --refresh`).

## Workflow
1. Run `cap status` and `cap repo`; record the environment's tz source of truth — `cap show` or the shell/env `TZ`, and the runtime's tz database (`Intl.DateTimeFormat().resolvedOptions().timeZone`, `date` output). Never assume the zone from the developer's machine.
2. Establish the facts for the affected instant with the runtime itself: compute the local time, UTC time, offset, and DST flag for the exact moment (`new Date(...)` output vs. ISO string). `cap rules` for any project time contract.
3. Find every time-producing site: `cap search <new Date|Date.|now|setHours|getHours|toISOString|format|strftime|datetime>` and classify capture (making a date), storage (serializing), rendering (formatting for display).
4. Cross-check capture vs. rendering zones: symptom = the layers disagreeing. Typical fingerprints: (a) `getHours/setHours` used = local-zone capture (breaks in non-local servers); (b) string without offset stored/compared = lost zone; (c) rendering with an implicit zone = display drift.
5. Reproduce with a boundary instant: a DST transition in the affected zone (spring-forward gap, fall-back overlap). Extract the transition dates from the runtime tz source, not from memory. Assert what the pipeline produces at `offset-change ± 1 day`.
6. Fix at the layer that owns the error: store/compare in UTC (`toISOString()`/epoch for serialization, UTC getters); render with an explicit zone (IANA name, not the server's local). Keep the fix at the offending layer — never convert a correct UTC store to local for storage. `cap diff` to scope.
7. Add boundary tests: one spring-forward, one fall-back, one zero-offset zone, one half-hour zone (e.g., `Asia/Kolkata`), each asserting the stored UTC and the rendered string.
8. Run `cap test`, `cap lint`, `cap typecheck`, `cap verify`; `cap memory add` the project's zone facts (storage form, render zone, tz source).

## Verification
- [ ] tz source inspected from the environment/runtime, not assumed (recorded).
- [ ] Capture/store/render sites classified with their implicit zones.
- [ ] The DST-boundary instant reproduced the bug before the fix.
- [ ] Storage/comparison is UTC (or offset-explicit, documented); rendering is zone-explicit.
- [ ] Boundary tests (spring/fall/zero/half offsets) pass; `cap verify` passes; diff scoped to the offending layer.

## Failure Handling
- Environment tz data is stale (OS tzdata outdated): `cap plugins` for the runtime; upgrade the tz package if the project controls it, or document that renders differ from current IANA — a stale-db render is a different root cause than a zone-handling bug; report it as such.
- Bug only appears on a server with a different `TZ` than dev: reproduce by setting `TZ` for the test run (`TZ=<zone> cap test --target`); the fix must be insensitive to `TZ` unless `TZ` is explicitly part of the contract.
- Legacy code stores local wall time: do not add offset math everywhere — migrate the boundary to UTC once (store + compare + render), with a documented migration (`cap plan`) and a rollback step in `cap rollback` terms.
- No DST in the project's zones but times still drift: the layer disagreement is plain zone mismatch (UTC vs. local), not DST — the boundary tests then use steady offsets, and the report says so.

## Output Format
Report:
- tz source facts: env `TZ`, runtime timezone, tz database version.
- For the affected instant: wall time, UTC, offset, DST flag as computed by the runtime.
- Layer classification: which sites capture/store/render, each with its implicit zone.
- Reproduced boundary instant and result pre-fix.
- Fix at the offending layer (UTC store/compare, zone-explicit render), scoped `cap diff`.
- Boundary tests (spring/fall/zero/half-hour) and `cap verify` result.

## References
- CONTRACT.md §2 Skill Format; §1 Tool Layer (`cap search`, `cap show`, `cap test`, `cap diff`).
- CONTRACT.md §7.3: compute the offset from the runtime, never from memory.
- `flaky-test-triage`: env-axis triage applies to `TZ`-sensitive tests.