//
//  ApproveCallData.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 8/15/21.
//

import EthereumKit
import BigInt

struct ApproveCallData {
    let data: Data
    let gasPrice: Int
    let to: EthereumKit.Address
    let value: BigUInt

    init(data: Data, gasPrice: Int, to: EthereumKit.Address, value: BigUInt) {
        self.data = data
        self.gasPrice = gasPrice
        self.to = to
        self.value = value
    }

}

extension ApproveCallData: CustomStringConvertible {

    public var description: String {
        "[ApproveCallData: \nto: \(to.hex); \nvalue: \(value.description); \ndata: \(data.hex)]"
    }

}
