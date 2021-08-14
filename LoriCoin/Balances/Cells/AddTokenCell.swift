//
//  AddTokenCell.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/22/21.
//

import UIKit

class AddTokenCell: UITableViewCell {

    @IBOutlet weak var addTokenButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        addTokenButton.layer.cornerRadius = 8
        selectionStyle = .none
    }
    
}
