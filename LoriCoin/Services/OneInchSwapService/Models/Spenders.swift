//
//  Spenders.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 8/15/21.
//

import EthereumKit

struct Spender {
    let address: EthereumKit.Address

    init(address: EthereumKit.Address) {
        self.address = address
    }

}
