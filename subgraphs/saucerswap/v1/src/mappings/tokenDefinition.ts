import {
  Address,
  BigInt,
} from "@graphprotocol/graph-ts"

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
    let tokenWHBAR = new TokenDefinition(
      Address.fromString('0x0000000000000000000000000000000000163b5a'),
      'WHBAR',
      'Wrapped HBAR Token',
      BigInt.fromI32(8)
    )
    staticDefinitions.push(tokenWHBAR)

    // Add DAI
    let tokenDAI = new TokenDefinition(
      Address.fromString('0x0000000000000000000000000000000000101af5'),
      'DAI',
      'Dai Stablecoin',
      BigInt.fromI32(8)
    )
    staticDefinitions.push(tokenDAI)

    // Add USDC Briged
    let tokenUSDCBridged = new TokenDefinition(
      Address.fromString('0x0000000000000000000000000000000000101ae3'),
      'USDC',
      'USDC HTS',
      BigInt.fromI32(6)
    )
    staticDefinitions.push(tokenUSDCBridged)

    // Add USDC Native
    let tokenUSDCNative = new TokenDefinition(
      Address.fromString('0x0000000000000000000000000000000000101ae3'),
      'USDC',
      'USDC',
      BigInt.fromI32(6)
    )
    staticDefinitions.push(tokenUSDCNative)

    // Add USDT
    let tokenUSDT = new TokenDefinition(
      Address.fromString('0x0000000000000000000000000000000000101af0'),
      'USDT',
      'Tether USD',
      BigInt.fromI32(6)
    )
    staticDefinitions.push(tokenUSDT)

    // Add LINK
    let tokenLINK = new TokenDefinition(
      Address.fromString('0x0000000000000000000000000000000000101b07'),
      'LINK',
      'Chainlink Token',
      BigInt.fromI32(8)
    )
    staticDefinitions.push(tokenLINK)

    // Add WBTC
    let tokenWBTC = new TokenDefinition(
      Address.fromString('0x0000000000000000000000000000000000101afb'),
      'WBTC',
      'Wrapped Bitcoin',
      BigInt.fromI32(8)
    )
    staticDefinitions.push(tokenWBTC)

    // Add WETH
    let tokenWETH = new TokenDefinition(
      Address.fromString('0x000000000000000000000000000000000008437c'),
      'WETH',
      'WETH HTS',
      BigInt.fromI32(8)
    )
    staticDefinitions.push(tokenWETH)

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