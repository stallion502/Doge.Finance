//
//  Etrerium.Address.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/7/21.
//

import Foundation

struct EtheriumAdress: Codable {
    let ethereum: Address?

    struct Address: Codable {
        let address: [BalancesArray]?
    }

}


struct BalancesArray: Codable {
    let address: String?
    let balances: [EtheriumAdressElement]?
}


struct EtheriumAdressElement: Codable {
    let value: Double?
    let currency: Currency?

    func toSearchToken() -> TokenSearch {
        return .init(address: currency?.address, name: currency?.name, symbol: currency?.symbol, usdtPrice: value, isUp: nil)
    }
}
