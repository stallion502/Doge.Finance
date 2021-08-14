//
//  BannerCollectionCell.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/16/21.
//

import UIKit

class BannerCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        clipsToBounds = true
    }

}
