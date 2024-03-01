# Saucerswap V2 Subgraph

### Subgraph Endpoint 

Synced at: https://mainnet-thegraph.swirldslabs.com/subgraphs/name/saucerswap-v2?selected=playground

### Transitioning to Saucerswap V2: Key Adjustments

The Saucerswap V2 subgraph is originally a fork of Uniswap v3 subgraph, but with some modifications to support Saucerswap V2.
- All references to ETH and WETH have been replaced with HBAR and WHBAR respectively.
- Token static definitions have been replaced with popular tokens on Hedera and Saucerswap.
- Factory contract address has been updated to Saucerswap V2 factory contract address.
- NFT Manager contract address has been updated to Saucerswap V2 NFT Manager contract address.
- Abis have been updated to Saucerswap V2 abis, since the Saucerswap V2 contracts have different function signatures in some cases. Smart contracts to generate ABI files can be found in their respective repositories.
    - NFT Position Manager: https://github.com/saucerswaplabs/saucerswaplabs-v2-periphery
    - Factory and Pool: https://github.com/saucerswaplabs/saucerswaplabs-v2-core
