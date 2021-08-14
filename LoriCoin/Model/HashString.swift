//
//  HashString.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/17/21.
//

import Foundation

struct HashString: Hashable, Codable {
    let hash: Data

    enum HashStringError: String, Error {
        case wrongHashLength = "Hash length should be 32 bytes"
    }

    init(_ hash: Data) {
        self.hash = hash
    }

    init(hex: String) throws {
        let data = Data(hex: hex)
        guard data.count == 32 else { throw HashStringError.wrongHashLength }
        self.hash = data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        try self.init(hex: string)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(hash.toHexStringWithPrefix())
    }

}

extension HashString: CustomStringConvertible {
    var description: String {
        hash.toHexStringWithPrefix()
    }
}
