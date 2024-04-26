# Saucerswap V2 Subgraph

### Subgraph Endpoint 

Synced at on mainnet: https://mainnet-thegraph.swirldslabs.com/subgraphs/name/saucerswap/saucerswap-v2?selected=playground
Synced at on testnet: https://testnet-thegraph.swirldslabs.com/subgraphs/name/saucerswap/saucerswap-v2?selected=playground

### Transitioning to Saucerswap V2: Key Adjustments

The Saucerswap V2 subgraph is originally a fork of Uniswap v3 subgraph, but with some modifications to support Saucerswap V2.
- All references to ETH and WETH have been replaced with HBAR and WHBAR respectively.
- Token static definitions have been replaced with popular tokens on Hedera and Saucerswap.
- Factory contract address has been updated to Saucerswap V2 factory contract address.
- NFT Manager contract address has been updated to Saucerswap V2 NFT Manager contract address.
- Abis have been updated to Saucerswap V2 abis, since the Saucerswap V2 contracts have different function signatures in some cases. Smart contracts to generate ABI files can be found in their respective repositories.
    - NFT Position Manager: https://github.com/saucerswaplabs/saucerswaplabs-v2-periphery
    - Factory and Pool: https://github.com/saucerswaplabs/saucerswaplabs-v2-core

## Setup

### Pre-requisites
1. yarn
2. thegraph cli
3. nodejs
4. HederaTheGraph Index Server

### Getting Started

The subgraph is able to run on 2 different networks: `mainnet` and `testnet`, for each network there is an example `.env` file, `.env.mainnet` and `.env.testnet` respectively.
You will need to change the `ACCESS_TOKEN` for the correct one for the network you want to run the subgraph on, if you are planning to deploy on your own private node of `HederaTheGraph` instance you don't need to provide a valid one.

1. Clone the project and install dependencies:
    ```bash
    yarn install
    ```

2. Create a `.env` file, you can use the example `.env.mainnet` or `.env.testnet` files as a template.
    ```bash 
        cp .env.mainnet .env
    ```

3. Compile the subgraph    
    ```bash
    npm run compile
    ```

4. Create the subgraph
    ```bash
    npm run create
    ```

5. Deploy the subgraph
    ```bash
    npm run deploy
    ```
