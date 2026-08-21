# Glossary

Terms used consistently across this knowledge base. Skill files must use these
definitions.

## Finding Classification

- **Finding** — a reportable defect (security or correctness) meeting the evidence bar.
- **Vulnerability** — a finding with security impact.
- **Bug** — a finding with correctness/reliability impact (may be non-security).
- **False positive** — a candidate finding disproved by investigation
  (`context/false-positive-model.md`).
- **Confirmed / High / Medium / Low confidence / False positive** — the five confidence
  levels (`context/confidence-model.md`).
- **E0–E5** — evidence levels, from "no evidence" to "root cause validated"
  (`context/evidence-model.md`).
- **Critical / High / Medium / Low / Informational** — the five severity levels
  (`context/severity-model.md`).

## Analysis Concepts

- **Entry point** — any place untrusted data or control enters the system (HTTP/RPC
  handler, queue consumer, CLI, file processor, webhook, callback).
- **Sink** — a sensitive operation that consumes the data (query, exec, file write,
  render, deserialize, crypto, privilege change, payment).
- **Source** — origin of data (request parameter, file, external API, untrusted input).
- **Data flow** — the path source → transformations → validation → authorization →
  sink.
- **Trust boundary** — a transition between trust levels
  (`SECURITY_BOUNDARIES.md`).
- **Attack surface** — the union of reachable entry points
  (`context/attack-surface-model.md`).
- **Taint** — data that originates from an untrusted source and is not yet validated.
- **Sanitization** — transformation that removes dangerous content.
- **Encoding** — output-boundary transformation that neutralizes interpretation of
  data (HTML-encoding, parameterization, etc.).
- **Canonicalization** — reducing a value to a single canonical form (path
  normalization, case folding, URL normalization).
- **Mass assignment** — bulk binding of client-supplied properties onto objects.
- **HPP** — HTTP Parameter Pollution.
- **IDOR** — Insecure Direct Object Reference (accessing objects by guessable
  identifier without ownership checks).
- **BOLA** — Broken Object Level Authorization (OWASP API Top 10 #1).
- **BFLA** — Broken Function Level Authorization (OWASP API Top 10 #5).
- **TOCTOU** — Time-Of-Check To Time-Of-Use race.
- **SSRF** — Server-Side Request Forgery.
- **CSRF** — Cross-Site Request Forgery.
- **CORS** — Cross-Origin Resource Sharing.
- **XSS** — Cross-Site Scripting (reflected, stored, DOM).
- **CSP** — Content Security Policy.
- **JWT** — JSON Web Token.
- **OAuth2 / OIDC** — authorization / identity protocols.

## System Concepts

- **Regression test** — a test added to prove a bug is fixed and stays fixed.
- **Minimal reproduction** — the smallest test demonstrating the defect.
- **Root cause** — the underlying defect, not the symptom
  (`templates/root-cause-analysis.md`).
- **Compensating control** — an independent control that mitigates a defect elsewhere.
- **Supply chain** — everything that produces the artifact: packages, build, CI/CD,
  distribution.
- **Lockfile** — pinned dependency manifest (`package-lock.json`, `Cargo.lock`,
  `go.sum`, `poetry.lock`, etc.).
- **SBOM** — Software Bill of Materials.
- **Least privilege** — granting only the minimum permissions required.
- **Threat model** — structured enumeration of assets, attackers, and attack paths
  (`context/threat-modeling.md`).

## Related

- `SKILL_INDEX.md` — every skill with its purpose
- `SKILL_ROUTER.md` — how observations map to skills
- `context/*` — the conceptual models
