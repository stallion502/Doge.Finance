//
//  MainSelectorCollectionCell.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/16/21.
//

import UIKit

class MainSelectorCollectionCell: UICollectionViewCell {

    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!

    override var isSelected: Bool {
        didSet {
            mainContainerView.backgroundColor = isSelected ? UIColor.white.withAlphaComponent(0.4) : UIColor.hex("212121")
            mainTitleLabel.textColor = isSelected ? UIColor.white : UIColor.white.withAlphaComponent(0.9)
        }
    }
}
