# seaport-sol

[![Version][version-badge]][version-link]
[![npm][npm-badge]][npm-link]

Solidity helpers for building and testing [Seaport][seaport] 1.6 orders in Foundry: struct libraries with fluent setters, order and fulfillment builders, and execution helpers.

The helpers are meant for Forge tests and scripts. They are gas-inefficient and not meant for contracts you deploy.

## Install

As a Foundry submodule:

```bash
forge install ProjectOpenSea/seaport-sol
```

Then add remappings. The library imports `seaport-types` and `seaport-core`, and some helpers import `solady` and `forge-std`. Point these at your own copies if you already have them.

```toml
remappings = [
    "seaport-sol/=lib/seaport-sol/",
    "seaport-types/=lib/seaport-sol/lib/seaport-types/",
    "seaport-core/=lib/seaport-sol/lib/seaport-core/",
    "solady/=lib/seaport-sol/lib/solady/",
]
```

From npm:

```bash
npm install seaport-sol
```

The package ships `src/` and depends on `seaport-core` 1.6.6 and `seaport-types` 1.6.3. It doesn't include solady or forge-std.

## Usage

```solidity
import {
    OrderComponents,
    OrderComponentsLib
} from "seaport-sol/src/SeaportSol.sol";

using OrderComponentsLib for OrderComponents;

OrderComponents memory order = OrderComponentsLib.empty()
    .withOfferer(offerer)
    .withStartTime(block.timestamp);
```

## Develop

Requires Foundry v1.9.0 and submodules checked out recursively.

```bash
git submodule update --init --recursive
forge build
forge test
scripts/install-tools.sh
scripts/lint.sh check
```

## Related repositories

- [seaport][seaport]: the Seaport contracts, tests, and docs
- [seaport-core][seaport-core]: core contracts
- [seaport-types][seaport-types]: types and interfaces

[seaport]: https://github.com/ProjectOpenSea/seaport
[seaport-core]: https://github.com/ProjectOpenSea/seaport-core
[seaport-types]: https://github.com/ProjectOpenSea/seaport-types
[version-badge]: https://img.shields.io/github/package-json/v/ProjectOpenSea/seaport-sol
[version-link]: https://github.com/ProjectOpenSea/seaport-sol/releases
[npm-badge]: https://img.shields.io/npm/v/seaport-sol?color=red
[npm-link]: https://www.npmjs.com/package/seaport-sol
