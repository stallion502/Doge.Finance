//
//  Swap.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 8/15/21.
//

import Foundation
import BigInt
import Foundation

public struct Swap {
    public let fromToken: Token
    public let toToken: Token
    public let fromTokenAmount: BigUInt
    public let toTokenAmount: BigUInt
    public let route: [Any]
    public let transaction: SwapTransaction

    public init(fromToken: Token, toToken: Token, fromTokenAmount: BigUInt, toTokenAmount: BigUInt, route: [Any], transaction: SwapTransaction) {
        self.fromToken = fromToken
        self.toToken = toToken
        self.fromTokenAmount = fromTokenAmount
        self.toTokenAmount = toTokenAmount
        self.route = route
        self.transaction = transaction
    }

}

extension Swap: CustomStringConvertible {

    public var description: String {
        "[Swap {\nfromToken:\(fromToken.name) - \ntoToken:\(toToken.name); \nfromAmount: \(fromTokenAmount.description) - \ntoAmount: \(toTokenAmount.description) \ntx: \(transaction.description)]"
    }

}

extension Swap {

    public var amountIn: Decimal? {
        fromTokenAmount.toDecimal(decimals: fromToken.decimals)
    }

    public var amountOut: Decimal? {
        toTokenAmount.toDecimal(decimals: toToken.decimals)
    }

}

extension BigUInt {

    public func toDecimal(decimals: Int) -> Decimal? {
        guard let decimalValue = Decimal(string: description) else {
            return nil
        }

        return decimalValue / pow(10, decimals)
    }

}

