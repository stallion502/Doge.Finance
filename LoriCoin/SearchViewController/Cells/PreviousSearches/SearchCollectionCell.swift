//
//  SearchCollectionCell.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/12/21.
//

import UIKit

class SearchCollectionCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8
    }
}
