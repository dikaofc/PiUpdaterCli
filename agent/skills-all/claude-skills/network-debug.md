---
name: network-debug
description: Debug second-layer network issues — timeout, retry, DNS, proxy, TLS cert — by instrumentation and controlled probes, never guessing.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: debugging
  tags: [network, timeout, dns, tls, proxy]
---

# Network Debug
<!-- built by @dikaacode (telegram) -->

## Objective
Resolve a network failure that outlives first-layer checks (host reachable, port open) by measuring each layer — DNS resolution, connect, TLS handshake, request/response timing — with controlled probes, and fix timeout/retry/DNS/proxy/cert policy from the measured numbers.

## Preconditions
- The failing endpoint, protocol, and the error text are known.
- The app runs in the same environment as the failure, or a probe script can run in it (`cap repo`).
- Repository is indexed (`cap index --refresh`).

## Workflow
1. Run `cap status` and `cap repo`; record the network environment facts: DNS resolver in use, proxy env vars (`HTTP_PROXY`, `HTTPS_PROXY`, `NO_PROXY`), TLS library versions (`cap plugins` for the runtime's TLS stack).
2. Re-read the error as a layer signal: `ETIMEDOUT` ≠ `ECONNREFUSED` ≠ `UNABLE_TO_VERIFY_LEAF_SIGNATURE` ≠ `ENOTFOUND`. Map the error to the layer it names; do not treat all errors as "the network".
3. Probe per layer with one controlled command each (a small script or `cap test --target` probe harness, never a guess-and-retry loop):
   - resolve: check the name against the resolver used by the app;
   - connect: TCP handshake timing to the resolved IP at the target port;
   - TLS: handshake completed, cert chain validity, SNI/authority match (`openssl s_client` or runtime equivalent);
   - request: time-to-first-byte vs. total duration, distinguishing conntrack stall from slow body.
4. Correlate with the app's policy: `cap search <timeout|retry|backoff|keepAlive|agent|maxSockets|retry>` — read the configured timeouts/retries and compare with the measured layer timings from step 3. A timeout is a policy bug when the layer legitimately takes longer than the configured ceiling.
5. Name the failing layer with numbers: e.g., "DNS: 12s stall on first lookup, 0s on cache", "TLS: 1.2s handshake vs. 4s app timeout", "proxy: CONNECT succeeds, payload stalls 30s".
6. Fix policy at the named layer: timeout/retry tuned to measured baselines (retry with backoff only for idempotent requests), DNS cache/TTL handling, keep-alive/connection pool sizing, proxy bypass for internal names, or cert pinning/CA update — one layer per fix. `cap diff` to scope.
7. Re-run identical probes post-fix; timings must now fit the app's policy, and the original failing call must succeed under the same conditions.
8. Run `cap test`, `cap lint`, `cap typecheck`, `cap verify`; `cap memory add` the endpoint's measured layer profile for future regressions.

## Verification
- [ ] DNS/connect/TLS/request probed individually with recorded numbers (no blended "it's slow" claim).
- [ ] Error text mapped to exactly one layer; the fix addresses that layer.
- [ ] Timeouts/retries compared against measured timings — policy numbers match reality post-fix.
- [ ] Original failing call passes under identical conditions (same URL, proxy, certs).
- [ ] Retries only on idempotent operations, with backoff (verified by `cap show` of the retry code).
- [ ] `cap verify` passes; probes re-run cleanly.

## Failure Handling
- Probing locally impossible (prod-only network): build the probe to run in the failing environment's control plane (`cap plan` for a deployable probe), name the layer from the error text alone as the hypothesis, and mark the report as hypothesis-until-probe.
- TLS failure from a corporate/man-in-the-middle proxy: never bypass `NO_PROXY`/verification to make it green — document the cert chain reality, and make the app's trust store the remediation (add CA or use the proxy's CA), reporting the security trade-off explicitly.
- Intermittent timeouts that probes cannot catch: the flake may be concurrent connection exhaustion (`maxSockets`, pool) — `cap search` pool settings and correlate with concurrency; switch evidence gathering to the `race-condition-hunt` method if a pool race is found.
- Endpoint is a third-party API that degrades: fix the client policy (timeout + retry with backoff + circuit breaker) and report the measured service profile; the fix is the client's resilience, not the service.

## Output Format
Report:
- Error text and its layer mapping.
- Probe results per layer with timings/exit status (DNS / connect / TLS / request).
- App policy numbers found (`cap search` results) vs. measured numbers.
- Named layer + policy fix (one layer), scoped `cap diff`.
- Post-fix probe comparison and the passing original call; `cap verify` result; endpooint profile saved to memory.

## References
- CONTRACT.md §2 Skill Format; §1 Tool Layer (`cap search`, `cap show`, `cap diff`, `cap test`).
- CONTRACT.md §7.3: measure each layer; the error text is the first fact, not the conclusion.
- `infinite-loop-debug`/`flaky-test-triage`: shared timing-instrumentation and env-axis methods.