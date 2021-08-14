//
//  TokenSearchCell.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/6/21.
//

import UIKit

class CircleImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
}

class CircleView: UILabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
}

class TokenSearchCell: UITableViewCell {

    static var reuseId: String {
        return "\(TokenSearchCell.self)"
    }

    @IBOutlet weak var arrowLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tokenTitleLabel: UILabel!
    @IBOutlet weak var tokenImageView: UIImageView!
    @IBOutlet weak var adresslabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!

    private var token: TokenSearch?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func showTokenInfo(_ sender: Any) {
        guard let token = token, let url = URL(string: "https://bscscan.com/address/\(token.address ?? "")") else { return }
        let web = WebController(url: url, title: token.name ?? "")
        let vc = UINavigationController(rootViewController: web)
        let root = UIApplication.shared.keyWindow?.rootViewController
        if let presented = root?.presentedViewController {
            presented.present(vc, animated: true, completion: nil)
        } else {
            root?.present(vc, animated: true, completion: nil)
        }
    }
    
    func setupUI(with token: TokenSearch) {
        if token.symbol == "SAFEMOON" || token.symbol == "BTCB" || token.symbol == "DOGE" || token.symbol == "SXP" {
            print("\(token.symbol ?? "") \(token.address ?? "")")
        }
        tokenTitleLabel.text = ""
        tokenImageView.backgroundColor = .clear
        tokenImageView.sd_setImage(with: URL(string: "http://81.23.151.224:5101/api/icon/\(token.address ?? "")"), completed: { [weak self] image, error, _, _ in
            if error != nil || image == nil {
                if let first = token.symbol?.prefix(3) {
                    self?.tokenTitleLabel.text = "\(first)"
                    self?.tokenImageView.backgroundColor = UIColor.white.withAlphaComponent(0.25)
                }
            }
        })
        self.token = token
        nameLabel.text = token.name
        symbolLabel.text = token.symbol
        if let price = token.usdtPrice, price != 0 {
            if price > 1 {
                priceLabel.text = price.percentWithSeparator
            } else {
                let priceString = price.fullFormattedWithSeparator
                if priceString == "0" {
                    priceLabel.text = price.extraFullFormattedWithSeparator
                } else {
                    priceLabel.text = priceString
                }
            }
        }
        if let isUp = token.isUp {
            arrowImageView.transform = isUp ? CGAffineTransform(rotationAngle: .pi) : .identity
            arrowImageView.tintColor = isUp ? .mainGreen : .mainRed
            arrowImageView.isHidden = false
        } else {
            arrowImageView.isHidden = true
        }

        adresslabel.text = "\(token.address?.prefix(6) ?? "")..."
        arrowLeftConstraint.constant = token.isUp == nil ? 0 : 8
        arrowWidthConstraint.constant = token.isUp == nil ? 0 : 15
    }
}
