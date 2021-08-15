//
//  SpenderMapper.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 8/15/21.
//

import Foundation
import EthereumKit
import HsToolKit

struct SpenderMapper: IApiMapper {
    typealias T = Spender

    func map(statusCode: Int, data: Any?) throws -> T {
        guard let map = data as? [String: Any],
              let addressString = map["address"] as? String else {
            throw NetworkManager.RequestError.invalidResponse(statusCode: statusCode, data: data)
        }

        return Spender(address: try EthereumKit.Address(hex: addressString))
    }

}
