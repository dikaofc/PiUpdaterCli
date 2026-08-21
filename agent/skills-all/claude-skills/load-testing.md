---
name: load-testing
description: Define and run load tests to find capacity and breaking points.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: testing
  tags: [load-testing, performance, testing]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Load & Performance Testing

## Objective
Measure throughput, latency, and failure mode under realistic load.

## Preconditions
- `cap repo` run; deploy target and SLOs known.
- A load tool available (`cap explore <load|k6|artillery|locust>`).

## Workflow
1. Run `cap explore` for the critical user journeys to simulate.
2. Script a realistic mix (think time, data) against staging, never prod blindly.
3. Ramp load gradually; watch p50/p95/p99, error rate, and resource saturation.
4. Find the knee: where latency climbs or errors start; record that capacity.
5. Identify the bottleneck (CPU, DB, queue) via metrics (see observability).
6. Record capacity + limits with `cap memory add`.

## Verification
- [ ] Test hits realistic journeys.
- [ ] Capacity (knee) measured, not estimated.
- [ ] Bottleneck identified with metrics.
- [ ] Results reproducible.

## Failure Handling
- If staging differs from prod, note the gap.
- If errors spike, find the limit before pushing further.

## Output Format
Load report: journeys, ramp, p95/error at knee, bottleneck, and capacity number.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
