//
//  EthHasher.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/17/21.
//

import Foundation
import CryptoSwift

struct EthHasher {

    static func hash(_ msg: Data) -> Data {
        let result = SHA3(variant: .keccak256).calculate(for: Array(msg))
        return Data(result)
    }

    static func hash(_ msg: String) -> Data {
        hash(msg.data(using: .utf8)!)
    }
}
