# seaport-sol

Solidity helpers for building and testing Seaport 1.6 orders in Foundry. Nothing here is deployed, so source can be reformatted and refactored. It is published to npm as `seaport-sol` and vendored by [seaport](https://github.com/ProjectOpenSea/seaport) as `lib/seaport-sol`, where `test/foundry/new/`, other Foundry tests, and the navigator and order validator helpers import it.

## Rules

- Keep `lib/seaport-core` and `lib/seaport-types` on the release tags that match `package.json` (seaport-core 1.6.6, seaport-types 1.6.3). Bump them together.
- Don't rename or remove public helpers without checking seaport's imports. Its pin moves on its own schedule, but a breaking change blocks the next bump.
- Don't bump `version` or publish from a PR. Publishing runs from a GitHub release.

## Layout

- `src/`: struct libraries (`lib/`), fulfillment and match builders (`fulfillments/`), execution helpers (`executions/`), and `SeaportSol.sol`, which re-exports the common ones.
- `test/`: Foundry tests for the struct libraries.

## Commands

Foundry v1.9.0, submodules checked out recursively.

```bash
forge build
forge test
scripts/install-tools.sh   # pinned Biome, taplo, lefthook, shellcheck, shfmt, actionlint
scripts/lint.sh check
```
