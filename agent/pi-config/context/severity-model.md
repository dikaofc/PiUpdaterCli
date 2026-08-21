# Severity Model

Severity expresses the **real-world impact** of a confirmed or probable defect. It is
assigned from a combination of factors, never from appearance or from the name of the
defect class.

**Severity is separate from confidence.** A critical-looking defect in an unreachable
path is LOW severity in practice until reachability is shown; a minor leak proven by a
test is still LOW severity even though it is CONFIRMED.

## Rating Factors

Severity is a function of these factors. Consider each explicitly and record the
reasoning.

1. **Impact** — what an attacker (or a bug) can actually achieve: confidentiality,
   integrity, availability, money, safety, regulatory exposure.
2. **Exploitability** — how easily the defect can be triggered: no auth required vs.
   deep privileges; trivial request vs. complex sequence; attacker-controlled input vs.
   fixed input.
3. **Required Privileges** — what privilege level is already needed to reach the flaw
   (unauthenticated, any user, tenant user, admin, internal service, local).
4. **Required Interaction** — does exploitation require user interaction (click, CSRF
   chain, social engineering) or can it happen without any interaction?
5. **Affected Scope** — does the impact stay in one tenant/user/context, or does it
   cross trust boundaries (tenant→tenant, user→admin, app→host, CI→prod)?
6. **Persistence** — is the effect one-shot or does it persist (stored data
   corruption, persistent backdoor-like state, lasting reputation damage)?
7. **Data Sensitivity** — the sensitivity of data affected: PII, credentials, payment
   data, health data, source code, internal config, public data.

## Severity Levels

### CRITICAL

- Direct, reliable compromise of a high-value asset with low required privilege:
  e.g., unauthenticated remote code execution, unauthenticated full database
  disclosure, cross-tenant data access at scale, CI compromise leading to supply-chain
  impact, credential compromise with no interaction required.
- Requires: unauthenticated or near-unauthenticated reach, no meaningful mitigating
  control, high-value scope.

### HIGH

- Significant impact with moderate exploitability: authenticated data disclosure at
  scale, server-side request forgery to internal services, stored cross-site scripting
  affecting many users, direct object reference/IDOR on sensitive resources, command
  injection behind a normal user action, availability loss of a core service.
- Requires: meaningful impact demonstrated (E4) and a realistic reachable path.

### MEDIUM

- Limited but real impact, or high impact gated behind significant preconditions:
  reflected XSS requiring interaction, CSRF on state-changing non-critical actions,
  low-sensitivity IDOR, information disclosure of non-secret data, rate-limit gaps on
  non-critical functions, dependency issue with reachable-but-limited impact.
- The classic default for "real but not catastrophic."

### LOW

- Minor impact or heavily gated: cosmetic information disclosure, minor header
  misconfiguration without exploitable behavior, hardening gaps with no demonstrated
  impact, dependency issue that is installed but unreachable.

### INFORMATIONAL

- Observations that are not vulnerabilities: coding-style inconsistencies, hardening
  suggestions, best-practice gaps without demonstrated impact, dependency version
  updates with no known issue. Informational items are not vulnerabilities; they are
  recommendations.

## Calibration Rules

1. **Do not call every injection CRITICAL.** A SQL injection behind an admin-only
   endpoint with a strong WAF may be MEDIUM. Severity follows reachability and impact,
   not the injection label.
2. **Do not call every auth issue CRITICAL.** A missing MFA on a low-privilege
   internal tool is not CRITICAL; a missing auth check on an admin API is.
3. **Do not call every outdated dependency HIGH or CRITICAL.** Use the dependency
   reachability analysis (`dependency-model.md`): installed? included? used? reachable?
   mitigated? Only a reachable, exploitable, unmitigated path supports a high rating.
4. **Impact must be evidence-based.** Distinguish observed impact (E4) from projected
   impact. Projected impact supports at most MEDIUM unless the reachability argument is
   airtight and documented.
5. **Scope matters more than volume.** A single cross-tenant read of one record is
   usually MEDIUM; systematic cross-tenant enumeration is HIGH.
6. **Downgrade for required privileges and interaction.** Every precondition (auth,
   specific role, user interaction, specific configuration) lowers the practical
   severity.
7. **Availability counts.** Exhaustion, deadlock, crash loops, and resource leaks are
   real impact and must be rated, not ignored because they are "not security."
8. **When in doubt between two levels, assign the lower one and state what would raise
   it** (e.g., "would be HIGH if reachable without authentication").

## Rating Template

```
Severity:  MEDIUM
Factors:
  Impact:            disclosure of non-sensitive internal data
  Exploitability:    one authenticated request, no interaction
  Required privs:    any authenticated user
  Interaction:       none
  Scope:             single tenant
  Persistence:       one-shot
  Data sensitivity:  low
Rationale: <2-3 sentences>
```

## Related

- `../context/evidence-model.md` — impact claims must be backed by E3/E4
- `../context/confidence-model.md` — severity vs. confidence separation
- `../references/severity-matrix.md` — the matrix form of this model
- `../skills/reporting/severity-assessment.md`
- `../skills/reporting/impact-analysis.md`
