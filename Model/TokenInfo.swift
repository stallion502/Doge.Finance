//
//  TokenInfo.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/4/21.
//

import Foundation

struct TokenInfo: Codable {
    let address: String?
    let name: String?
    let symbol: String?
    var usdtPrice: Double?
    var priceInBnb: Double?
    var marketCap: Double?
    let supply: Double?
    var liquidityInUsdt: Double?
    var liquidityInBnb: Double?
    var dayPriceChange: Double?
    var dayVolumeChange: Double?
}

struct TokenSocketModel: Codable {
    let priceInBnb: Double?
    let priceInUsdt: Double?
    let token: String?
    let supply: Double?
    let marketCap: Double?
    let dayChange: Double?
    let liquidityInUsdt: Double?
    let liquidityInBnb: Double?
    let dayPriceChange: Double?
    let dayVolumeChange: Double?
}
