//
//  BNBPriceService.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/12/21.
//

import Foundation

class BNBPriceService {
    static let shared = BNBPriceService()

    private let bnbAddress = "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c"

    var dexTrades: [DexTrade] = [] {
        didSet {
            dexTrades.forEach {
                if let minute = $0.timeInterval?.minute {
                    prices[minute] = $0.quotePrice
                }
            }
        }
    }

    var prices: [String: Double] = [:]
}
