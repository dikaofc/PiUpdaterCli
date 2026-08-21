---
name: firewall-toolkit
description: Manage iptables/nftables/ufw rules and explain firewall state.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://netfilter.org/documentation/
metadata:
  category: infra
  language: bash
  tags: [firewall-toolkit]
---
# Firewall Toolkit

Manage iptables/nftables/ufw rules and explain firewall state.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/firewall-toolkit.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/firewall-toolkit.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:firewall-toolkit <args>`
