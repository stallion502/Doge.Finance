//
//  TransferCollectionHeaderCell.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/4/21.
//

import UIKit

class TransferCollectionHeaderCell: UICollectionViewCell {
    @IBOutlet var separators: [UIView]!
    @IBOutlet weak var dropDownButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dropDownButton.isHidden = true
    }

    func animateBG() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseIn]) {
                self.backgroundColor = .mainBackgorund
            }
        })
    }
}
