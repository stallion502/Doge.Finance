//
//  TitleTableCell.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/16/21.
//

import UIKit

class TitleTableCell: UITableViewCell {

    @IBOutlet weak var mainTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
