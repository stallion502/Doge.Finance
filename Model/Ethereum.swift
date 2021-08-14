//
//  Ethereum.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 6/28/21.
//

import Foundation

enum PriceChartType: Int {
    case bnbBUSD
    case bnb
}

struct Ethereum: Codable {
    var ethereum: TransactionsRoot?

    mutating func filter(address: String, type: PriceChartType) {
        let dexTrades = ethereum?.dexTrades?.filter {
            guard let closePrice = $0.closePrice, let openPrice = $0.openPrice else {
                return false
            }
            return closePrice != openPrice
                && $0.baseCurrency?.address?.uppercased() == address.uppercased()
        }.compactMap { trade -> DexTrade? in
            switch type {
            case .bnb:
                return trade
            case .bnbBUSD:
                if let date = trade.timeInterval?.minute, let bnbPrice = BNBPriceService.shared.prices[date] {
                    var trade = trade
                    let quotePrice = trade.quotePrice.value * bnbPrice
                    var openPrice = trade.openPrice?.toDouble() ?? 0
                    openPrice *= bnbPrice
                    var closePrice = trade.closePrice?.toDouble() ?? 0
                    closePrice *= bnbPrice
                    let minimumPrice = trade.minimumPrice.value * bnbPrice
                    let maximumPrice = trade.maximumPrice.value * bnbPrice

                    trade.quotePrice = quotePrice
                    trade.openPrice = "\(openPrice)"
                    trade.closePrice = "\(closePrice)"
                    trade.minimumPrice = minimumPrice
                    trade.maximumPrice = maximumPrice
                    return trade
                }
                return nil
            }
        }.reversed() ?? []
        ethereum?.dexTrades = Array(dexTrades)
    }
}


struct EthereumDexTrades: Codable {
    let ethereumDexTrades: TransactionsRoot?

    enum CodingKeys: String, CodingKey {
        case ethereumDexTrades = "ethereum.dexTrades"
    }
}
