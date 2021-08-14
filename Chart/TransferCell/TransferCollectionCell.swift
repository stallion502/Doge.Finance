//
//  TransferCollectionCell.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/4/21.
//

import UIKit

class TransferCollectionCell: UICollectionViewCell {

    @IBOutlet weak var bnbPrice: UILabel!
    @IBOutlet var allLabels: [UILabel]!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var bnbPriceLabel: UILabel!
    @IBOutlet weak var usdtPriceLabel: UILabel!
    @IBOutlet weak var totalCoinsLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    var symbol: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(with transfer: TransactionAPI) {
        symbolLabel.text = symbol

        let totalCoins = transfer.totalCoins.value
        if totalCoins > 1 {
            totalCoinsLabel.text = "\(totalCoins.witoutDecimals)"
        } else {
            totalCoinsLabel.text = "\(totalCoins.fullFormattedWithSeparator)"
        }

        let usdtTotalPrice = transfer.totalUsdt.value
        if usdtTotalPrice == 0 {
            usdtPriceLabel.text = "-"
        }
        else if usdtTotalPrice > 0.1 {
            usdtPriceLabel.text = "\(usdtTotalPrice.percentWithSeparator) $"
        } else if usdtTotalPrice > 0.000001 {
            usdtPriceLabel.text = "\(usdtTotalPrice.medium5) $"
        }
        else {
            usdtPriceLabel.text = "\(usdtTotalPrice.fullFormattedWithSeparator) $"
        }


        let bnbPriceValue = transfer.bnbPrice.value
        if bnbPriceValue == 0 {
            bnbPrice.text = "-"
        }
        else if bnbPriceValue > 0.1 {
            bnbPrice.text = "\(bnbPriceValue.percentWithSeparator) BNB"
        } else {
            bnbPrice.text = "\(bnbPriceValue.fullFormattedWithSeparator) BNB"
        }

        let bnbTotalPrice = transfer.totalBnb.value
        if bnbTotalPrice == 0 {
            bnbPriceLabel.text = "-"
        }
        else {
            bnbPriceLabel.attributedText = bnbTotalPrice.toBNBPriceLower
        }

        let usdtPrice = transfer.usdtPrice.value
        if usdtPrice == 0 {
            priceLabel.text = "-"
        }
        else if usdtPrice > 1 {
            priceLabel.attributedText = usdtPrice.toDollarPrice
        } else {
            priceLabel.text = "\(usdtPrice.fullFormattedWithSeparator) $"
        }
        
        allLabels.forEach { $0.textColor = transfer.side == 1 ? .mainRed : .mainGreen }


        let date = DateFormatterBuilder.dateFormatter(.iso8601ZZZ, timeZone: .current).date(from: transfer.transactionDate ?? "")
        timeLabel.text = date?.string(.HHmmss)
        dateLabel.text = date?.string(.ddMMMM)
//        let isBuy = transfer.buyAmount != 0
//        allLabels.forEach {
//            $0.textColor = !isBuy ? .mainGreen : .mainRed
//        }
//        amountBaseLabel.text = ""
//        priceLabel.text = transfer.quotePrice.prettyString + " BNB"
//        timeLabel.text = transfer.timeInterval?.second?.toStringFormat
//        let price = isBuy ? transfer.buyAmount : transfer.sellAmount
//        if let price = price, price != 0 {
//            if price > 0.5 {
//                realAmountLabel.text = "$ \(price.witoutDecimals)"
//            } else {
//                realAmountLabel.text = "$ \(price.beginPriceString)"
//            }
//        }
    }
}

extension Double {
    func toMillions() -> String {
        let coins = self
        if coins > 1000000 {
            return "\((coins / 1000000).witoutDecimals) mln."
        } else if coins > 10000 {
            return "\((coins / 1000).witoutDecimals) k."
        } else {
            return "\(self.witoutDecimals)"
        }
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0

        return formatter
    }()

    static let percentSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        return formatter
    }()

    static let mediumSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 0

        return formatter
    }()

    static let fullSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 13
        formatter.minimumFractionDigits = 0

        return formatter
    }()

    static let medium4: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 4
        formatter.minimumFractionDigits = 0

        return formatter
    }()

    static let medium5: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 0

        return formatter
    }()

    static let extraFullSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 18
        formatter.minimumFractionDigits = 0

        return formatter
    }()

    static let witoutDecimals: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0

        return formatter
    }()
}

extension Numeric {
    var witoutDecimals: String { Formatter.witoutDecimals.string(for: self) ?? "" }
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
    var mediumWithSeparator: String { Formatter.mediumSeparator.string(for: self) ?? "" }
    var percentWithSeparator: String { Formatter.percentSeparator.string(for: self) ?? "" }
    var fullFormattedWithSeparator: String { Formatter.fullSeparator.string(for: self) ?? "" }
    var medium4: String { Formatter.medium4.string(for: self) ?? "" }
    var medium5: String { Formatter.medium5.string(for: self) ?? "" }
    var extraFullFormattedWithSeparator: String { Formatter.extraFullSeparator.string(for: self) ?? "" }
}

fileprivate extension String {
    var toStringFormat: String {
        return DateFormatterBuilder
            .dateFormatter(.iso, timeZone: .utc)
            .date(from: self)?
            .string(.dMMMHHmm, timeZone: .current) ?? ""
    }
}

