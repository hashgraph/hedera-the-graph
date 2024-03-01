import {
  Address,
  BigInt,
} from "@graphprotocol/graph-ts"
  
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
    let staticDefinitions = new Array<StaticTokenDefinition>(11)

    // Add WHBAR
    let tokenWHBAR = new StaticTokenDefinition(
      Address.fromString('0x0000000000000000000000000000000000163b5a'),
      'WHBAR',
      'Wrapped HBAR',
      BigInt.fromI32(8)
    )
    staticDefinitions.push(tokenWHBAR)

    // Add HBARX
    let tokenHBARX = new StaticTokenDefinition(
      Address.fromString('0x00000000000000000000000000000000000cba44'),
      'HBARX',
      'HBARX',
      BigInt.fromI32(8)
    )
    staticDefinitions.push(tokenHBARX)
    
    // Add USDC[hts]
    let tokenUSDC = new StaticTokenDefinition(
      Address.fromString('0x0000000000000000000000000000000000101ae3'),
      'USDC',
      'USDC [hts]',
      BigInt.fromI32(6)
    )
    staticDefinitions.push(tokenUSDC)

    // Add USDC Native
    let tokenUSDCNative = new StaticTokenDefinition(
      Address.fromString('0x000000000000000000000000000000000006f89a'),
      'USDC',
      'USDC',
      BigInt.fromI32(6)
    )
    staticDefinitions.push(tokenUSDCNative)
      
    // Add Sauce
    let tokenSauce = new StaticTokenDefinition(
      Address.fromString('0x00000000000000000000000000000000000b2ad5'),
      'SAUCE',
      'SAUCE',
      BigInt.fromI32(6)
    )
    staticDefinitions.push(tokenSauce)

    // Add XSAUCE
    let tokenXSauce = new StaticTokenDefinition(
      Address.fromString('0x00000000000000000000000000000000001647e8'),
      'XSAUCE',
      'XSAUCE',
      BigInt.fromI32(6)
    )
    staticDefinitions.push(tokenXSauce)

    // Add USDT[hts]
    let tokenUSDT = new StaticTokenDefinition(
      Address.fromString('0x0000000000000000000000000000000000101af0'),
      'USDT',
      'USDT [hts]',
      BigInt.fromI32(6)
    )
    staticDefinitions.push(tokenUSDT)

    // Add DAI[hts]
    let tokenDAI = new StaticTokenDefinition(
      Address.fromString('0x0000000000000000000000000000000000101af5'),
      'DAI',
      'DAI [hts]',
      BigInt.fromI32(6)
    )
    staticDefinitions.push(tokenDAI)

    // Add WBTC[hts]
    let tokenWBTC = new StaticTokenDefinition(
      Address.fromString('0x0000000000000000000000000000000000101afb'),
      'WBTC',
      'WBTC [hts]',
      BigInt.fromI32(6)
    )
    staticDefinitions.push(tokenWBTC)

    // Add WETH[hts]
    let tokenWETH = new StaticTokenDefinition(
      Address.fromString('0x000000000000000000000000000000000008437c'),
      'WETH',
      'WETH [hts]',
      BigInt.fromI32(6)
    )
    staticDefinitions.push(tokenWETH)

    // Add LINK[hts]
    let tokenLINK = new StaticTokenDefinition(
      Address.fromString('0x0000000000000000000000000000000000101b07'),
      'LINK',
      'LINK [hts]',
      BigInt.fromI32(6)
    )
    staticDefinitions.push(tokenLINK)

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