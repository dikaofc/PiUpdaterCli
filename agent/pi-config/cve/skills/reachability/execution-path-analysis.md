# Skill: Execution Path Analysis

## Purpose

Verify the call path can execute in the deployed configuration: entry points enabled, jobs scheduled, routes mounted.

## Trigger Conditions

Activate when reviewing execution path, runtime entry, deployment.

## Investigation Method

1. Map runtime entry points in the deployment: HTTP routes mounted, queue consumers running, cron/schedulers active, event listeners subscribed.
2. Check that the entry point leading to the vulnerable path is enabled in the deployed configuration.
3. Account for runtime context: conditional middleware, environment-specific route mounting, disabled workers.
4. Verdict: path executes in deployment / only in specific configurations / does not execute.
5. Record configuration evidence for the verdict.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Entry-point enablement evidence (routing config, worker list, deployment manifests) tied to the call path.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Static call graph ignoring deployment-time enablement.

## Impact

Reachable-in-code but never-executed vulnerabilities reported as exploitable.

## Remediation

Deployment-aware entry analysis, config evidence, dynamic checks where feasible.

## Regression Test

Fixture deployments asserting path enablement verdicts.

## False Positives

Feature-flagged entries disabled in production but enabled in CI/test config - use production config.

## Related Skills

- cve-reachability-engine.md
- call-graph-analysis.md
- cve-configuration-applicability.md

## References

- deployment manifests, route configs
