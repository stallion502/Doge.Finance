//
//  TokenSearch.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/6/21.
//

import Foundation

struct TokenSearch: Codable, Hashable, Equatable {
    let address: String?
    let name: String?
    let symbol: String?
    let usdtPrice: Double?
    let isUp: Bool?

    static func == (lhs: TokenSearch, rhs: TokenSearch) -> Bool {
        return lhs.address == rhs.address
    }

    init(address: String?, name: String?, symbol: String?, usdtPrice: Double?, isUp: Bool?) {
        self.address = address
        self.name = name
        self.symbol = symbol
        self.usdtPrice = usdtPrice
        self.isUp = isUp
    }
}
