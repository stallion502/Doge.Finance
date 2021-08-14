//
//  WalletTransactionCell.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/8/21.
//

import UIKit

class WalletTransactionCell: UITableViewCell {

    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet var allLabels: [UILabel]!
    @IBOutlet weak var tokenTitleLabel: UILabel!
    @IBOutlet weak var tokenImageView: UIImageView!
    @IBOutlet weak var adresslabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gasPriceLabel: UILabel!
//    @IBOutlet weak var receiveAmountLabel: UILabel!
    @IBOutlet private weak var cellAmountLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!

    private let bnbAddress = "0xbb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c"

    private var token: DexTrade?

    @IBAction func showTokenInfo(_ sender: Any) {
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
        tokenTitleLabel.text = ""
        tokenImageView.backgroundColor = .clear
        if let first = token.smartContract?.currency?.symbol?.prefix(3) {
            self.tokenTitleLabel.text = "\(first)"
            self.tokenImageView.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        }
        self.token = token
        let isBuy = token.buyCurrency?.address != bnbAddress
        let tokenCurrency = isBuy ? token.buyCurrency : token.sellCurrency
        nameLabel.text = tokenCurrency?.name
        symbolLabel.text = tokenCurrency?.symbol
        captionLabel.text = isBuy ? "Buy amount in $" : "Sell amount in $"
        cellAmountLabel.text = "\((isBuy ? token.buyAmount?.formattedWithSeparator : token.buyAmount?.formattedWithSeparator) ?? "") $"
//        receiveAmountLabel.text = "\(token.buyAmount?.formattedWithSeparator ?? "") $"
        gasPriceLabel.text = "\(token.gasValue?.formattedWithSeparator ?? "") $"
        dateLabel.text = token.exchange?.fullName
        adresslabel.text = "\(token.transaction?.hash?.prefix(6) ?? "")..."
        allLabels.forEach { $0.textColor = isBuy ? .mainGreen : .mainRed }
    }
}
