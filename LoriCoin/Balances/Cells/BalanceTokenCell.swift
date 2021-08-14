//
//  BalanceTokenCell.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/22/21.
//

import UIKit

class BalanceTokenCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var usdtPriceLabel: UILabel!
    @IBOutlet weak var dayPriceChangeLabel: UILabel!
    @IBOutlet private weak var tokenTitleLabel: UILabel!
    @IBOutlet private weak var tokenImageView: UIImageView!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setup(with token: TokenInfo, amount: Double) {
        amountLabel.attributedText = amount.toAmount(symbol: token.symbol ?? "")
        
        tokenTitleLabel.text = ""
        tokenImageView.backgroundColor = .clear
        tokenImageView.sd_setImage(with: URL(string: "http://81.23.151.224:5101/api/icon/\(token.address ?? "")"), completed: { [weak self] image, error, _, _ in
            if error != nil || image == nil {
                if let first = token.symbol?.prefix(3) {
                    self?.tokenTitleLabel.text = "\(first)"
                    self?.tokenImageView.backgroundColor = UIColor.white.withAlphaComponent(0.25)
                }
            }
        })
        nameLabel.text = token.name

        if let price = token.usdtPrice {
            usdtPriceLabel.attributedText = price.toBNBPrice
        }

        if let price = token.usdtPrice {
            if price == 0 {
                priceLabel.text = "-"
            }
             else if price > 1 {
                priceLabel.text = "\(price.mediumWithSeparator) $"
            } else {
                priceLabel.text = "\(price.fullFormattedWithSeparator) $"
            }
        }
        let isUp = token.dayPriceChange.value > 0
        arrowImageView.transform = isUp ? CGAffineTransform(rotationAngle: .pi) : .identity
        arrowImageView.tintColor = isUp ? .mainGreen : .mainRed

        if token.dayPriceChange.value != 0 {
            dayPriceChangeLabel.text = "\(isUp ? "+" : "")\(token.dayPriceChange.value.percentWithSeparator) %"
        } else {
            dayPriceChangeLabel.text = ""
        }
    }
}
