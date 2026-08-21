# Threat Modeling

Structured enumeration of assets, attackers, and attack paths so that auditing effort
is spent where impact is real.

## Method

1. **Scope.** Define the system boundary (components in scope, external systems,
   data flows in/out).
2. **Assets.** List sensitive assets: data (PII, credentials, payment, business
   data), functions (admin, payment, state changes), infrastructure (secrets,
   cloud resources, build pipeline), reputation.
3. **Trust boundaries.** List transitions between trust levels
   (`SECURITY_BOUNDARIES.md`).
4. **Attackers.** Define attacker profiles: unauthenticated remote, authenticated
   low-priv user, tenant user, internal compromised service, supply-chain attacker,
   insider. Each profile has capabilities and goals.
5. **Entry points.** All places each attacker profile can touch the system
   (`context/attack-surface-model.md`).
6. **Attack paths.** For each (attacker, asset) pair, enumerate plausible paths
   across boundaries; each path is a hypothesis to verify.
7. **Rank.** Order paths by (impact × likelihood) using the severity model.
8. **Controls.** Identify existing controls per path; gaps become findings.

## Output

`templates/threat-model.md` — scope, assets, boundaries, attacker profiles, ranked
attack paths, existing controls, gaps, validation status per gap.

## Rules

- Threat modeling produces **hypotheses**, not findings. Every path must be verified
  with evidence before it becomes a finding.
- Revisit the threat model when: new entry points, new trust boundaries, new assets,
  new integrations, or major refactors appear.
- For each ranked path, note which skills to activate (see `SKILL_ROUTER.md`).

## Common Mistakes

- Modeling only unauthenticated attackers (authenticated/tenant/internal attackers
  cause most business-logic and IDOR findings).
- Listing assets but never connecting them to entry points.
- Declaring a path "exploitable" without a trace.
- Forgetting the supply chain (CI/CD, dependencies) as an attacker surface.

## Related

- `../templates/threat-model.md`
- `../context/attack-surface-model.md`
- `../context/trust-boundaries.md`
- `../skills/reconnaissance/attack-surface-mapping.md`
- `../workflows/full-project-audit.md`
