//
//  OnboardingCell.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/29/21.
//

import UIKit

class OnboardingCell: UICollectionViewCell {

    @IBOutlet weak var watchOutView: UIView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!

    var onContinuePressed: () -> Void = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        continueButton.layer.cornerRadius = 8
    }

    @objc private func continuePressed() {
        onContinuePressed()
    }

    func setup(with index: Int) {
        continueButton.addTarget(self, action: #selector(continuePressed), for: .touchUpInside)
        continueButton.setTitle("Continue", for: .normal)
        switch index {
        case 0:
            watchOutView.isHidden = true
            let attributed = NSMutableAttributedString(string: "Hey dear friend!\nWelcome to Doge.")
            attributed.append(NSAttributedString(string: "Finance", attributes: [.foregroundColor: UIColor.mainYellow]))
            titleLabel.attributedText = attributed

            subtitleLabel.text = "Doge.Finace is the place where you can find any token that was created. Keep in my in mind bro, it’s defi sector and be very carefull buying tokens"

        case 1:
            watchOutView.isHidden = true
            titleLabel.text = "Check out our own ratings on Pancake Swap"
            subtitleLabel.text = "Doge likes PancakeSwap that’s why I have raiting by:  - New and hot  - Hour and Day volume - Hour and Day transactions"

        case 2:
            watchOutView.isHidden = false
            titleLabel.text = "Charts and transactions"
            subtitleLabel.text = "Doge will provide you with all transactions of the token!  - Check out specific candle by just pressing on it - Use long press to compare candles - Rotate your device to use full screen mode - Check dev wallet balance and transactions  "
        case 3:
            continueButton.setTitle("Start", for: .normal)
            watchOutView.isHidden = false
            titleLabel.text = "Search and Favorites"
            subtitleLabel.text = "Doge will find any token!  Just type ADDRESS, SYMBOL or NAME  You will never lost your token with Doge, just add them to favorites and watch their growth.  "
        default:
            break
        }
    }

}
