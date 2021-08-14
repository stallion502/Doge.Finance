//
//  TopCollectionCell.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/22/21.
//

import UIKit

class TopCollectionCell: UICollectionViewCell {
    @IBOutlet weak var usdtPriceLabel: UILabel!
    @IBOutlet weak var dayPriceChangeLabel: UILabel!
    @IBOutlet private weak var tokenImageView: UIImageView!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.hex("979797").withAlphaComponent(0.25).cgColor
        backgroundColor = UIColor.hex("212121")
    }

    func setup(with token: TokenInfo?) {
        guard let token = token else { return }
        tokenImageView.backgroundColor = .clear
        tokenImageView.sd_setImage(with: URL(string: "http://81.23.151.224:5101/api/icon/\(token.address ?? "")"))
        nameLabel.text = token.name
        symbolLabel.text = token.symbol

        if let price = token.priceInBnb {
            usdtPriceLabel.attributedText = price.toBNBPriceLower
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
        arrowImageView.image = UIImage(named: "arrowDown")
        if token.dayPriceChange.value != 0 {
            dayPriceChangeLabel.text = "\(isUp ? "+" : "")\(token.dayPriceChange.value.percentWithSeparator) %"
        } else {
            dayPriceChangeLabel.text = ""
        }
    }

}
