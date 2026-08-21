---
name: ethereum-dev
description: Query Ethereum balances, gas price, blocks, and transactions via public JSON-RPC.
license: MIT
compatibility: "POSIX shell + curl + jq + python3. No local node required."
source: https://ethereum.org/en/developers/docs/apis/json-rpc/
metadata:
  category: blockchain
  language: bash
  tags: [ethereum, web3, rpc]
---
# Ethereum Dev

Query the Ethereum blockchain through public JSON-RPC endpoints —
no local node or wallet needed.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

No installation required. Uses `curl`, `jq`, and `python3` (all
available in Termux via `pkg install curl jq python`).

## Usage

```bash
ethereum-dev.sh balance 0x742d35Cc6634C0532925a3b844Bc454e4438f44e
ethereum-dev.sh gas
ethereum-dev.sh block --number 19000000
ethereum-dev.sh tx 0x9b7a1d5a1f8e1c9e2e5e7a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d
```

## Options

- `--rpc URL` — use a different JSON-RPC endpoint (default: `https://ethereum.publicnode.com`)
- `--number N` — block number for `block` (default: latest)

## Commands

| Command | Description |
|---|---|
| `balance <address>` | ETH + wei balance of an address |
| `gas` | current gas price in gwei |
| `block [--number N]` | block number, hash, timestamp, tx count |
| `tx <hash>` | transaction sender, receiver, value, gas |
