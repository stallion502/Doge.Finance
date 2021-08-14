//
//  ChartDetailTopView.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/4/21.
//

import UIKit

final class ChartDetailTopView: UIView {

    @IBOutlet weak var totalTradesPrice: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var closePrice: UILabel!
    @IBOutlet weak var openPrice: UILabel!
    @IBOutlet weak var minimumPrice: UILabel!
    @IBOutlet weak var maximumPrice: UILabel!

    private var widthAnchorConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?

    var onClose: () -> Void = {}

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let view = superview else { return }
        topConstraint = topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4)
        topConstraint?.isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        widthAnchorConstraint = widthAnchor.constraint(equalToConstant: view.frame.width - 16)
        widthAnchorConstraint?.isActive = true
    }

    override func awakeFromNib() {
        addShadow()
        clipsToBounds = true
        layer.cornerRadius = 8
        translatesAutoresizingMaskIntoConstraints = false
    }

    @IBAction func closePressed(_ sender: Any) {
        onClose()
    }
    
    func setup(with trade: DexTrade?, isPortrait: Bool) {
        guard let trade = trade else { return }
        maximumPrice.text = trade.maximumPrice.prettyString
        minimumPrice.text = trade.minimumPrice.prettyString
        openPrice.text = Double(trade.openPrice ?? "0").prettyString
        closePrice.text = Double(trade.closePrice ?? "0").prettyString
        dateLabel.text = trade.timeInterval?.minute?.toDexStringFormat

        let totalTradings = trade.tradeAmount ?? 0
        let totalTrades = Double(round(100 * totalTradings) / 100)
        totalTradesPrice.text = "Total trades price: \(totalTrades.formattedWithSeparator) $"
        backgroundColor = isPortrait
            ? UIColor.hex("212121")
            : UIColor.mainBackgorund.withAlphaComponent(0.5)
        guard let view = superview else { return }
        widthAnchorConstraint?.constant = view.frame.width - 16
        topConstraint?.constant = isPortrait ? 0 : 8
    }
}

