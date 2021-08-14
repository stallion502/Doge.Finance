//
//  SelectorCollectionCell.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/7/21.
//

import UIKit

class SelectorCollectionCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        containerView.layer.cornerRadius = 8
    }

    func setup(with title: String) {
        self.titleLabel.text = title
        titleLabel.font = title == "Buy" ? .systemFont(ofSize: 15, weight: .medium) : .systemFont(ofSize: 15)
        containerView.backgroundColor = title == "Buy" ? .mainGreen : UIColor.white.withAlphaComponent(0.25)
    }
}
