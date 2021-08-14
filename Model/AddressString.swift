//
//  AddressString.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/17/21.
//

import Foundation

struct AddressString: Hashable, Codable {
    let address: Address

    static let zero = AddressString(Address.zero)

    var data32: Data {
        return address.data.leftPadded(to: 32)
    }

    init?(_ string: String) {
        guard let value = Address(string) else { return nil }
        address = value
    }

    init(_ address: Address) {
        self.address = address
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        do {
            address = try Address(from: value)
        } catch {
            let message = "Failed to decode address: \(error.localizedDescription): \(value)"
            let context = DecodingError.Context.init(codingPath: container.codingPath, debugDescription: message)
            throw DecodingError.typeMismatch(Address.self, context)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(address.checksummed)
    }
}

extension AddressString: ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        if let v = AddressString(value) {
            self = v
        } else {
            assertionFailure("Invalid literal address: \(value)")
            self = .init(.zero)
        }
    }
}

extension AddressString: CustomStringConvertible {
    var description: String {
        address.checksummed
    }
}
