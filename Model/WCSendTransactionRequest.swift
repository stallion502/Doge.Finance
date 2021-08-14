//
//  WCSendTransactionRequest.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/17/21.
//

import Foundation
import Web3

// https://docs.walletconnect.org/json-rpc-api-methods/ethereum#eth_sendtransaction
struct WCSendTransactionRequest: Decodable {
    let from: AddressString
    let to: AddressString?
    let gas: UInt256String?
    let gasPrice: UInt256String?
    let value: UInt256String?
    let data: DataString
    let nonce: UInt256String?
}
