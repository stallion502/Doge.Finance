//
//  Transactions.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 6/28/21.
//

import Foundation

struct TransactionsRoot: Codable {
    var dexTrades: [DexTrade]?
}

struct DexTrade: Codable {
    let trades: Int?
    var maximumPrice: Double?
    let tradeAmount: Double?
    var quotePrice: Double?
    var minimumPrice: Double?
    let baseCurrency: Currency?
    let sellCurrency: Currency?
    let quoteCurrency: Currency?
    let buyCurrency: Currency?
    var openPrice: String?
    var closePrice: String?
    let timeInterval: TimeIntervalModel?
    let count: Int?
    let sellAmount: Double?
    let buyAmount: Double?
    let block: Block?
    let gasValue: Double?
    let exchange: Exchange?
    let transaction: TransactionEth?
    let smartContract: SmartContract?
    let date: TokenDate?
//    let date: TokenDate?

    enum CodingKeys: String, CodingKey {
        case trades
        case maximumPrice = "maximum_price"
        case minimumPrice = "minimum_price"
        case tradeAmount
        case quotePrice
        case baseCurrency
        case quoteCurrency
        case timeInterval
        case count
        case openPrice = "open_price"
        case closePrice = "close_price"
        case sellAmount
        case buyAmount
        case buyCurrency
        case sellCurrency
        case gasValue
        case exchange
        case block
        case transaction
        case smartContract
        case date
    }

    var lowestPrice: Double {
        return minimumPrice ?? 0
    }

    var highestPrice: Double {
        return maximumPrice ?? 0
    }
}

struct TokenDate: Codable {
    let date: String?
}

struct SmartContract: Codable {
    let currency: Currency?
    let address: Receiver?
}

struct Exchange: Codable {
    let fullName: String?
}

struct Currency: Codable {
    let symbol: String?
    let address: String?
    let name: String?
    let decimals: Int?
}

struct TimeIntervalModel: Codable {
    let minute: String?
    let second: String?
}
