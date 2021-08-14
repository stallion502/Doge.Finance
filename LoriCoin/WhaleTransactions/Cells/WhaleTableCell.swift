//
//  WhaleTableCell.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/31/21.
//

import UIKit

class WhaleTableCell: UITableViewCell {

    @IBOutlet weak var transactionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var buyAmountLabel: UILabel!
    @IBOutlet weak var buyAmountSubtitleLabel: UILabel!
    @IBOutlet weak var sellAmountSubtitleLabel: NSLayoutConstraint!
    @IBOutlet weak var sellAmountTitleLabel: UILabel!

    private var token: DexTrade?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    @IBAction func transactionPressed(_ sender: Any) {
        guard let token = token, let url = URL(string: "https://bscscan.com/address/\(token.transaction?.hash ?? "")") else { return }
        let web = WebController(url: url, title: token.smartContract?.currency?.name ?? "")
        let vc = UINavigationController(rootViewController: web)
        let root = UIApplication.shared.keyWindow?.rootViewController
        if let presented = root?.presentedViewController {
            presented.present(vc, animated: true, completion: nil)
        } else {
            root?.present(vc, animated: true, completion: nil)
        }
    }

    func setupUI(with token: DexTrade) {
        if let first = token.smartContract?.currency?.symbol?.prefix(3) {
            self.transactionLabel.text = "\(first)"
        }
        self.token = token
        let totalCoins = token.buyAmount.value
        if totalCoins > 1 {
            buyAmountLabel.text = "\(totalCoins.witoutDecimals)"
        } else {
            buyAmountLabel.text = "\(totalCoins.fullFormattedWithSeparator)"
        }
        buyAmountSubtitleLabel.text = "Buy \(token.buyCurrency?.symbol ?? "") amount:"

        let usdtPrice = token.tradeAmount.value
        if usdtPrice == 0 {
            sellAmountTitleLabel.text = "-"
        }
        else if usdtPrice > 1 {
            sellAmountTitleLabel.attributedText = usdtPrice.toDollarPrice
        } else {
            sellAmountTitleLabel.text = "\(usdtPrice.fullFormattedWithSeparator) $"
        }

        dateLabel.text = token.date?.date
    }
}
