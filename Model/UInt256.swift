//
//  UInt256.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/17/21.
//

import Foundation
import BigInt

typealias UInt256 = BigUInt
typealias Int256 = BigInt

extension UInt256 {
    var data32: Data {
        Data(ethHex: String(self, radix: 16)).leftPadded(to: 32).suffix(32)
    }
}
