//
//  BNBTokenCell.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/22/21.
//

import UIKit

class BNBTokenCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setup(with price: Double) {
        valueLabel.attributedText = price.toBNBPriceLower
    }
}
