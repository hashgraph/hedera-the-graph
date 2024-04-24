import {
  Address,
  BigInt,
} from "@graphprotocol/graph-ts"

import { 
  TOKEN_WHBAR, 
  TOKEN_USDC_HTS, 
  TOKEN_USDT_HTS, 
  TOKEN_DAI_HTS, 
  TOKEN_WBTC_HTS, 
  TOKEN_WETH_HTS, 
  TOKEN_LINK_HTS, 
  TOKEN_SAUCE, 
  TOKEN_XSAUCE, 
  TOKEN_USDC_NATIVE, 
  TOKEN_HBARX 
} from "./constants"
  
// Initialize a Token Definition with the attributes
export class StaticTokenDefinition {
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
  static getStaticDefinitions(): Array<StaticTokenDefinition> {
    let staticDefinitions = new Array<StaticTokenDefinition>()

    // Add WHBAR
    if(TOKEN_WHBAR != '') {
      let tokenWHBAR = new StaticTokenDefinition(
        Address.fromString(TOKEN_WHBAR),
        'WHBAR',
        'Wrapped HBAR',
        BigInt.fromI32(8)
      )
      staticDefinitions.push(tokenWHBAR)
    }

    // Add HBARX
    if(TOKEN_HBARX != '') {
      let tokenHBARX = new StaticTokenDefinition(
        Address.fromString(TOKEN_HBARX),
        'HBARX',
        'HBARX',
        BigInt.fromI32(8)
      )
      staticDefinitions.push(tokenHBARX)
    }

    
    // Add USDC[hts]
    if(TOKEN_USDC_HTS != '') {
      let tokenUSDC = new StaticTokenDefinition(
        Address.fromString(TOKEN_USDC_HTS),
        'USDC',
        'USDC [hts]',
        BigInt.fromI32(6)
      )
      staticDefinitions.push(tokenUSDC)
    }


    // Add USDC Native
    if(TOKEN_USDC_NATIVE != '') {
      let tokenUSDCNative = new StaticTokenDefinition(
        Address.fromString(TOKEN_USDC_NATIVE),
        'USDC',
        'USDC',
        BigInt.fromI32(6)
      )
      staticDefinitions.push(tokenUSDCNative)
    }
      
    // Add Sauce
    if(TOKEN_SAUCE != '') { 
      let tokenSauce = new StaticTokenDefinition(
        Address.fromString(TOKEN_SAUCE),
        'SAUCE',
        'SAUCE',
        BigInt.fromI32(6)
      )
      staticDefinitions.push(tokenSauce)
    }

    // Add XSAUCE
    if(TOKEN_XSAUCE != '') {
      let tokenXSauce = new StaticTokenDefinition(
        Address.fromString(TOKEN_XSAUCE),
        'XSAUCE',
        'XSAUCE',
        BigInt.fromI32(6)
      )
      staticDefinitions.push(tokenXSauce)
    }

    // Add USDT[hts]
    if(TOKEN_USDT_HTS != ''){
      let tokenUSDT = new StaticTokenDefinition(
        Address.fromString(TOKEN_USDT_HTS),
        'USDT',
        'USDT [hts]',
        BigInt.fromI32(6)
      )
      staticDefinitions.push(tokenUSDT)
    }

    // Add DAI[hts]
    if(TOKEN_DAI_HTS != '') {
      let tokenDAI = new StaticTokenDefinition(
        Address.fromString(TOKEN_DAI_HTS),
        'DAI',
        'DAI [hts]',
        BigInt.fromI32(6)
      )
      staticDefinitions.push(tokenDAI)
    }

    // Add WBTC[hts]
    if(TOKEN_WBTC_HTS != ''){
      let tokenWBTC = new StaticTokenDefinition(
        Address.fromString(TOKEN_WBTC_HTS),
        'WBTC',
        'WBTC [hts]',
        BigInt.fromI32(6)
      )
      staticDefinitions.push(tokenWBTC)
    }

    // Add WETH[hts]
    if(TOKEN_WETH_HTS != '') {
      let tokenWETH = new StaticTokenDefinition(
        Address.fromString(TOKEN_WETH_HTS),
        'WETH',
        'WETH [hts]',
        BigInt.fromI32(6)
      )
      staticDefinitions.push(tokenWETH)
    }

    // Add LINK[hts]
    if(TOKEN_LINK_HTS != '') {
      let tokenLINK = new StaticTokenDefinition(
        Address.fromString(TOKEN_LINK_HTS),
        'LINK',
        'LINK [hts]',
        BigInt.fromI32(6)
      )
      staticDefinitions.push(tokenLINK)
    }

    return staticDefinitions
  }

  // Helper for hardcoded tokens
  static fromAddress(tokenAddress: Address) : StaticTokenDefinition | null {
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