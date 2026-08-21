---
name: microservices
description: Decompose a monolith into services along bounded contexts with clear contracts.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: architecture
  tags: [microservices, architecture]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Microservices Decomposition

## Objective
Split services where cohesion is high and coupling is low, without creating distributed monoliths.

## Preconditions
- `cap repo` run; module boundaries and shared DB reviewed (`cap explore`, `cap diff` history).

## Workflow
1. Run `cap repo` and `cap explore` to map modules and their dependency edges.
2. Group by bounded context (domain, not technical layer); define each service's single responsibility.
3. Set inter-service contracts (events/API) and choose sync vs async per call.
4. Decide data ownership: each service owns its store; avoid shared DB.
5. Extract one service first (strangler fig); measure before more splits.
6. Record the context map with `cap memory add`.

## Verification
- [ ] Services split by domain, not layer.
- [ ] Contracts explicit (API/event).
- [ ] Each owns its data.
- [ ] One service extracted and verified before scaling.

## Failure Handling
- If coupling forces synchronous calls everywhere, reconsider the boundary.
- If team too small, stop splitting.

## Output Format
Decomposition: context map, service responsibilities, contracts, and the first extraction plan.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
