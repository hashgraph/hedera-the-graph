/* eslint-disable prefer-const */
import { BigInt, BigDecimal, Address, dataSource } from '@graphprotocol/graph-ts'

let network = dataSource.network()

export let FACTORY_ADDRESS = ''
export let TOKEN_WHBAR = ''
export let USDC_WETH_PAIR = ''
export let TOKEN_USDC_HTS = ''
export let TOKEN_USDT_HTS = ''
export let TOKEN_DAI_HTS  = ''
export let TOKEN_WBTC_HTS  = ''
export let TOKEN_WETH_HTS  = ''
export let TOKEN_LINK_HTS  = ''
export let TOKEN_SAUCE  = ''
export let TOKEN_XSAUCE  = ''
export let TOKEN_USDC_NATIVE  = ''
export let TOKEN_HBARX  = ''

if(network == 'mainnet') {
    FACTORY_ADDRESS = '0x0000000000000000000000000000000000103780'
    TOKEN_WHBAR = '0x0000000000000000000000000000000000163b5a'
    USDC_WETH_PAIR = '0xdb34c1ef944883f0e5a2fc18b6c1978b088bd31d'
    TOKEN_USDC_HTS = '0x0000000000000000000000000000000000101ae3'
    TOKEN_USDT_HTS = '0x0000000000000000000000000000000000101af0'
    TOKEN_DAI_HTS  = '0x0000000000000000000000000000000000101af5'
    TOKEN_WBTC_HTS  = '0x0000000000000000000000000000000000101afb'
    TOKEN_WETH_HTS  = '0x000000000000000000000000000000000008437c'
    TOKEN_LINK_HTS  = '0x0000000000000000000000000000000000101b07'
    TOKEN_SAUCE  = '0x00000000000000000000000000000000000b2ad5'
    TOKEN_XSAUCE = '0x00000000000000000000000000000000001647e8'
    TOKEN_USDC_NATIVE = '0x000000000000000000000000000000000006f89a'
    TOKEN_HBARX = '0x00000000000000000000000000000000000cba44'

} if(network == 'testnet') {
    FACTORY_ADDRESS = '0x00000000000000000000000000000000000026e7'
    TOKEN_WHBAR = '0x0000000000000000000000000000000000003ad2'
    USDC_WETH_PAIR = '0x87664e55d9606657f049139ff654390a72657667'
    TOKEN_USDC_HTS = '0x0000000000000000000000000000000000001549'
    TOKEN_USDT_HTS = ''
    TOKEN_DAI_HTS  = '0x0000000000000000000000000000000000001599'
    TOKEN_WBTC_HTS  = ''
    TOKEN_WETH_HTS  = ''
    TOKEN_LINK_HTS  = ''
    TOKEN_SAUCE  = '0x0000000000000000000000000000000000120f46'
    TOKEN_XSAUCE = ''
    TOKEN_USDC_NATIVE = '0x0000000000000000000000000000000000001549'
    TOKEN_HBARX = '0x0000000000000000000000000000000000220ced'
}
