//
//  Data+InitWithHex.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/17/21.
//

import Foundation
import CryptoSwift

// MARK: - Hex String to Data conversion
public extension Data {

    /// Creates data from hex string, padding to even byte character count from the left with 0.
    /// For example, "0x1" will become "0x01".
    ///
    /// - Parameter ethHex: hex string.
    init(ethHex: String) {
        var value = ethHex
        while value.hasPrefix("0x") || value.hasPrefix("0X") { value = String(value.dropFirst(2)) }
        // if ethHex is not full byte, Data(hex:) adds nibble at the end, but we need it in the beginning
        let paddingToByte = value.count % 2 == 1 ? "0" : ""
        value = paddingToByte + value
        self.init(hex: value)
    }

    init?(exactlyHex hex: String) {
        var value = hex.lowercased()
        if value.hasPrefix("0x") {
            value.removeFirst(2)
        }
        guard value.rangeOfCharacter(from: CharacterSet.hexadecimals.inverted) == nil else {
            return nil
        }
        self.init(hex: hex)
    }

    func toHexStringWithPrefix() -> String {
        "0x" + toHexString()
    }
}
