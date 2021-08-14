//
//  NewTransactionsCell.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/30/21.
//

import UIKit

class NewTransactionsCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    func setup(with count: Int) {
        titleLabel.text = "New transactions +\(count)"
    }

}
