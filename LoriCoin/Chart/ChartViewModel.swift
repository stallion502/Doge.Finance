//
//  ChartViewModel.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/13/21.
//

import Foundation
import Charts

struct Candle {
    var quote: Double
    var minimum: Double
    var maximum: Double
    var open: Double
    var close: Double
    var date: Date
}

class ChartViewModel {

    private var currentCandle: Candle = .init(quote: 0, minimum: 0, maximum: 0, open: 0, close: 0, date: .init())

    var candleStartDate: Date?
    var lastTransaction: DexTrade? {
        didSet {
            prepareLastDate()
        }
    }
    var rangeType: ChartRange = ._15m
    var onUpdateLast: ((DexTrade) -> Void)?
    var onInsertNew: ((DexTrade) -> Void)?

    func priceReceived(token: TokenSocketModel?) {
        guard let token = token, let price = token.priceInUsdt, price != 0 else { return }
        if shouldResetDate(date: candleStartDate) {
            candleStartDate = Date()
            // Insert new candle action
        } else {
            // Update last candle action
        }
    }

    private func prepareLastDate() {
        if let date = DateFormatterBuilder
            .dateFormatter(.iso8601Z, timeZone: .utc)
            .date(from: lastTransaction?.timeInterval?.minute ?? "") {
            if shouldResetDate(date: date) {
                candleStartDate = Date()
            } else {
                candleStartDate = date
            }
        }
    }

    private func shouldResetDate(date: Date?) -> Bool {
        guard let date = date else {
            return true
        }
        return Date().timeIntervalSince(date) < Double(rangeType.rawValue * 60)
    }
}
