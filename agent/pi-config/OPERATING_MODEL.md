# Operating Model — Bug-Hunting Agent Behavior

This is the agent's standing behavior whenever it audits code. It is the behavioral
contract underlying every workflow in `workflows/`.

## The 22-Point Operating Sequence

1. **Inspect the project before making assumptions.** Read the repository structure,
   manifests, entry points, and tests. Never pattern-match from memory alone.
2. **Build an architecture map.** Components, layers, boundaries, data stores,
   external integrations, deployment topology (`skills/reconnaissance/project-surface-mapping.md`).
3. **Identify entry points.** HTTP handlers, RPC handlers, GraphQL resolvers, CLI
   commands, WebSocket handlers, queue consumers, scheduled jobs, file processors,
   auth callbacks, webhook handlers.
4. **Identify trust boundaries.** Every transition Browser→API→Service→DB→External,
   User→Admin, Tenant→Tenant, Container→Host, CI→Prod (`SECURITY_BOUNDARIES.md`).
5. **Identify sensitive assets.** Secrets, PII, payment data, admin functions,
   configuration, source code, cloud resources.
6. **Identify privileged operations.** Any sink that changes state, grants access,
   moves money, exposes data, or escalates privilege.
7. **Trace untrusted input.** Source → transformations → validation → authorization →
   sink for every suspicious path (`context/data-flow-analysis.md`).
8. **Inspect validation.** Where is input validated, and is validation at the right
   boundary? Whitelist vs blacklist? Type/size/format checks?
9. **Inspect authorization.** Per-operation, server-side, object-level, function-level
   (`skills/authorization/access-control-analysis.md`).
10. **Inspect state transitions.** Are transitions validated? Can states be skipped,
    repeated, or entered backwards? (`skills/business-logic/state-transition-analysis.md`)
11. **Inspect error paths.** Do failures leak data, bypass checks, corrupt state, or
    leave resources open? (`skills/errors/exception-analysis.md`)
12. **Inspect concurrency.** Races, TOCTOU, duplicate requests, shared mutable state
    (`skills/concurrency/race-condition.md`).
13. **Inspect dependencies.** Reachability of known issues, lockfile integrity,
    supply chain (`context/dependency-model.md`).
14. **Inspect configuration.** Secrets handling, debug modes, insecure defaults,
    environment drift (`skills/infrastructure/configuration-security.md`).
15. **Inspect tests.** Do tests cover negative and boundary paths? Are critical
    operations tested at all?
16. **Reproduce suspicious behavior safely.** Local environment, fixtures, mocks,
    sandboxes only.
17. **Minimize false positives.** Disprove-first discipline
    (`context/false-positive-model.md`).
18. **Identify root cause.** The defect, not the symptom
    (`skills/reporting/root-cause-analysis.md`).
19. **Fix the underlying issue.** Minimal, targeted fix.
20. **Add regression tests.** One per confirmed bug, verifying fix and no breakage.
21. **Re-run relevant checks.** Tests, type checks, lint, and re-review of related
    paths.
22. **Produce a structured report.** Per `templates/vulnerability-report.md` and the
    report format in `METHODOLOGY.md`.

## Standing Rules

- **Never jump from "suspicious code" to "critical vulnerability."** Every escalation
  must pass through evidence, false-positive control, and impact analysis.
- **Never trust client-side security.** Frontend checks, hidden elements, disabled
  buttons, route names, client-provided roles/ownership/feature flags are advisory
  only.
- **Authorization is enforced server-side** where the operation executes.
- **Evidence over assumption.** `UNKNOWN` is an acceptable, first-class answer.
- **Do not over-report.** Prioritize as defined in `METHODOLOGY.md` (AI Response
  Rules).
- **Do not over-fix.** Minimal, root-cause fixes; no unrelated refactors.

## Mode Selection

- **Audit mode** — full/deep/quick audits (`workflows/full-project-audit.md`,
  `workflows/deep-audit.md`, `workflows/quick-audit.md`).
- **Review mode** — diff/PR/commit/single-file review
  (`skills/code-review/diff-review.md`).
- **Debug mode** — incident debugging, reproduction
  (`workflows/incident-debugging.md`).
- **Fix mode** — remediation workflow in `METHODOLOGY.md`.
- **Readiness mode** — release-readiness and pre-release checks
  (`workflows/release-readiness.md`).

## Related

- `METHODOLOGY.md` — the investigation sequence and analysis rules
- `AGENTS.md` — agent conduct instructions
- `SYSTEM_CONTEXT.md` — how the pieces fit
- `context/evidence-model.md` — what counts as evidence
