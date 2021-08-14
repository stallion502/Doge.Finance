//
//  Transactions.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 6/30/21.
//

import Foundation

struct TransfersEthereum: Codable {
    let ethereum: TransfersRoot?
}

struct TransfersRoot: Codable {
    let transfers: [Transfer]?
}

struct Transfer: Codable {
    let block: Block?
    let sender: Receiver?
    let receiver: Receiver?
    let amount: Double?
    let currency: Currency?
    let external: Bool?

    enum CodingKeys: String, CodingKey {
        case sender
        case block
        case receiver
        case amount
        case external
        case currency
    }
}

struct Block: Codable {
    let timestamp: TimeStamp?
}

struct TimeStamp: Codable {
    let time: String?
    let second: String?
    let iso8601: String?
}

struct TransactionEth: Codable {
    let hash: String?
    let txFrom: Receiver?
    let to: Receiver?
}

struct Receiver: Codable {
    let address: String?
}
