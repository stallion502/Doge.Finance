//
//  ChartOptionsView.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/9/21.
//

import UIKit

class ChartOptionsView: UIView {

    var isShown: Bool = false

    func setIsShown(_ isShown: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.frame.origin.y = isShown ? 0 : -44
        }
        
        self.isShown = isShown
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame.origin.y = isShown ? 0 : -44
    }

    override func awakeFromNib() {
        setIsShown(false)
        self.frame.origin.y = -44
    }
}
