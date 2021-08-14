//
//  TransactionAPI.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/19/21.
//

import Foundation

struct TransactionAPI: Codable {
    let side: Int
    let totalCoins: Double?
    let totalBnb: Double?
    let transactionDate: String?
    let usdtPrice: Double?
    let bnbPrice: Double?
    let totalUsdt: Double?
}
