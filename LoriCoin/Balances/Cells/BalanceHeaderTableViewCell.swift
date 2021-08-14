//
//  BalanceHeaderTableViewCell.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/22/21.
//

import UIKit

class BalanceHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var walletImageView: UIImageView!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var addressContainerView: UIView!
    @IBOutlet private weak var walletTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        addressContainerView.layer.cornerRadius = 8
        addressContainerView.layer.borderWidth = 1
        addressContainerView.layer.borderColor = UIColor.hex("979797").withAlphaComponent(0.25).cgColor
        if let session = WalletConnectClientController.shared.session {
            let wallet = WalletsDataSource.shared.installedWallets.first(where: { $0.name == session.walletInfo?.peerMeta.name })
            walletImageView.image = UIImage(named: wallet?.imageName ?? "")
            addressLabel.text = "\(session.walletInfo?.accounts.first?.prefix(4) ?? "")..\(session.walletInfo?.accounts.first?.prefix(4) ?? "")"
            walletTitleLabel.text = wallet?.name
        }
    }
}
