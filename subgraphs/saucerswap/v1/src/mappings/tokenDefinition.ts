import {
  Address,
  BigInt,
} from "@graphprotocol/graph-ts"

import {  
  TOKEN_WHBAR, 
  TOKEN_WETH_HTS, 
  TOKEN_DAI_HTS, 
  TOKEN_USDC_HTS, 
  TOKEN_USDC_NATIVE, 
  TOKEN_USDT_HTS, 
  TOKEN_LINK_HTS, 
  TOKEN_WBTC_HTS 
} from '../utils/constants'

// Initialize a Token Definition with the attributes
export class TokenDefinition {
  address : Address
  symbol: string
  name: string
  decimals: BigInt

  // Initialize a Token Definition with its attributes
  constructor(address: Address, symbol: string, name: string, decimals: BigInt) {
    this.address = address
    this.symbol = symbol
    this.name = name
    this.decimals = decimals
  }

  // Get all tokens with a static defintion
  static getStaticDefinitions(): Array<TokenDefinition> {
    let staticDefinitions = new Array<TokenDefinition>(6)

    // Add WHBAR
    if(TOKEN_WHBAR != '') {
      let tokenWHBAR = new TokenDefinition(
        Address.fromString(TOKEN_WHBAR),
        'WHBAR',
        'Wrapped HBAR Token',
        BigInt.fromI32(8)
      )
      staticDefinitions.push(tokenWHBAR)
    }

    // Add DAI
    if(TOKEN_DAI_HTS != '') {
      let tokenDAI = new TokenDefinition(
        Address.fromString(TOKEN_DAI_HTS),
        'DAI',
        'Dai Stablecoin',
        BigInt.fromI32(8)
      )
      staticDefinitions.push(tokenDAI)
    }

    // Add USDC Briged
    if(TOKEN_USDC_HTS != '') {
      let tokenUSDCBridged = new TokenDefinition(
        Address.fromString(TOKEN_USDC_HTS),
        'USDC',
        'USDC HTS',
        BigInt.fromI32(6)
      )
      staticDefinitions.push(tokenUSDCBridged)
    }

    // Add USDC Native
    if(TOKEN_USDC_NATIVE != '') {
      let tokenUSDCNative = new TokenDefinition(
        Address.fromString(TOKEN_USDC_NATIVE),
        'USDC',
        'USDC',
        BigInt.fromI32(6)
      )
      staticDefinitions.push(tokenUSDCNative)
    }

    // Add USDT
    if(TOKEN_USDT_HTS != '') {
      let tokenUSDT = new TokenDefinition(
        Address.fromString(TOKEN_USDT_HTS),
        'USDT',
        'Tether USD',
        BigInt.fromI32(6)
      )
      staticDefinitions.push(tokenUSDT)
    }

    // Add LINK
    if(TOKEN_LINK_HTS != '') {
      let tokenLINK = new TokenDefinition(
        Address.fromString(TOKEN_LINK_HTS),
        'LINK',
        'Chainlink Token',
        BigInt.fromI32(8)
      )
      staticDefinitions.push(tokenLINK)
    }

    // Add WBTC
    if(TOKEN_WBTC_HTS != '') {
      let tokenWBTC = new TokenDefinition(
        Address.fromString(TOKEN_WBTC_HTS),
        'WBTC',
        'Wrapped Bitcoin',
        BigInt.fromI32(8)
      )
      staticDefinitions.push(tokenWBTC)
    }

    // Add WETH
    if(TOKEN_WETH_HTS != '') {
      let tokenWETH = new TokenDefinition(
        Address.fromString(TOKEN_WETH_HTS),
        'WETH',
        'WETH HTS',
        BigInt.fromI32(8)
      )
      staticDefinitions.push(tokenWETH)
    }

    return staticDefinitions
  }

  // Helper for hardcoded tokens
  static fromAddress(tokenAddress: Address) : TokenDefinition | null {
    let staticDefinitions = this.getStaticDefinitions()
    let tokenAddressHex = tokenAddress.toHexString()

    // Search the definition using the address
    for (let i = 0; i < staticDefinitions.length; i++) {
      let staticDefinition = staticDefinitions[i]
      if(staticDefinition.address.toHexString() == tokenAddressHex) {
        return staticDefinition
      }
    }

    // If not found, return null
    return null
  }

}