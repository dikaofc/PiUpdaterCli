# ethereum-dev — Reference

Query Ethereum state via public JSON-RPC.

## Commands

| Command | Example | Notes |
|---|---|---|
| `balance <addr>` | `ethereum-dev.sh balance 0x742d35Cc6634C0532925a3b844Bc454e4438f44e` | prints ETH + wei |
| `gas` | `ethereum-dev.sh gas` | current gas price in gwei |
| `block` | `ethereum-dev.sh block --number 19000000` | default: latest |
| `tx <hash>` | `ethereum-dev.sh tx 0x9b7a...` | sender, receiver, value, gas |

## Options

- `--rpc URL` — override endpoint (default `https://ethereum.publicnode.com`)
- `--number N` — block number for `block` (hex or decimal)

## Notes

- Uses `eth_getBalance`, `eth_gasPrice`, `eth_getBlockByNumber`, `eth_getTransactionByHash`.
- All values are hex-decoded via python3; ETH amounts are 18-decimal wei.
- If a public endpoint is down, pass another: `--rpc https://eth.llamarpc.com`.

## Dependencies

`curl`, `jq`, `python3` — all available via `pkg install curl jq python`.
