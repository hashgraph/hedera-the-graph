# SAUCERSWAP V1 Subgraph

This subgraph dynamically tracks any pair created by the uniswap factory. It tracks of the current state of Uniswap contracts, and contains derived stats for things like historical data and USD prices.

- aggregated data across pairs and tokens,
- data on individual pairs and tokens,
- data on transactions
- data on liquidity providers
- historical data on Uniswap, pairs or tokens, aggregated by day

## Running Locally

Make sure to update package.json settings to point to your own graph account.

## Queries

Below are a few ways to show how to query the uniswap-subgraph for data. The queries show most of the information that is queryable, but there are many other filtering options that can be used, just check out the [querying api](https://thegraph.com/docs/graphql-api). These queries can be used locally or in The Graph Explorer playground.

## Key Entity Overviews

#### UniswapFactory

Contains data across all of Uniswap V2. This entity tracks important things like total liquidity (in ETH and USD, see below), all time volume, transaction count, number of pairs and more.

#### Token

Contains data on a specific token. This token specific data is aggregated across all pairs, and is updated whenever there is a transaction involving that token.

#### Pair

Contains data on a specific pair.

#### Transaction

Every transaction on Uniswap is stored. Each transaction contains an array of mints, burns, and swaps that occured within it.

#### Mint, Burn, Swap

These contain specifc information about a transaction. Things like which pair triggered the transaction, amounts, sender, recipient, and more. Each is linked to a parent Transaction entity.

## Example Queries

### Querying Aggregated Uniswap Data

This query fetches aggredated data from all uniswap pairs and tokens, to give a view into how much activity is happening within the whole protocol.

```graphql
{
  uniswapFactories(first: 1) {
    pairCount
    totalVolumeUSD
    totalLiquidityUSD
  }
}
```

### Subgraph Endpoint 

Synced at for mainnet: https://mainnet-thegraph.swirldslabs.com/subgraphs/name/saucerswap/saucerswap-v1?selected=playground

Synced at for testnet: https://testnet-thegraph.swirldslabs.com/subgraphs/name/saucerswap/saucerswap-v1?selected=playground

### Transitioning to Saucerswap V1: Key Adjustments

The Saucerswap V1 subgraph is originally a fork of Uniswap v2 subgraph, but with some modifications to support Saucerswap V1.
- All references to ETH and WETH have been replaced with HBAR and WHBAR respectively.
- Token static definitions have been replaced with popular tokens on Hedera and Saucerswap.
- Factory contract address has been updated to Saucerswap V1 factory contract address.
- Abis have been updated to Saucerswap V1 abis, since the Saucerswap V1 contracts have different function signatures in some cases. Smart contracts to generate ABI files can be found in their respective repositories.
    - Factory and Pool: https://github.com/saucerswaplabs/saucerswaplabs-core
    - Periphery: https://github.com/saucerswaplabs/saucerswap-periphery

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
