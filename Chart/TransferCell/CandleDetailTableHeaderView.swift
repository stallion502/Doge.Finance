//
//  CandleDetailTableHeaderView.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/4/21.
//

import UIKit
import MaterialActivityIndicator
class CandleDetailTableHeaderView: UIView {

    var trade: DexTrade? {
        didSet {
            setupUI()
        }
    }

    var isLoading: Bool = false {
        didSet {
            isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }

    var onClose: () -> Void = {}

    @IBOutlet weak var activityIndicator: MaterialActivityIndicatorView!
    @IBOutlet weak var totalTradesPrice: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var closePrice: UILabel!
    @IBOutlet weak var openPrice: UILabel!
    @IBOutlet weak var minimumPrice: UILabel!
    @IBOutlet weak var maximumPrice: UILabel!
    @IBOutlet weak var mainContainerView: UIView!
    
    override func awakeFromNib() {
        translatesAutoresizingMaskIntoConstraints = false
        mainContainerView.roundCorners([.top], radius: 8)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        mainContainerView.roundCorners([.top], radius: 8)
    }

    private func setupUI() {
        maximumPrice.text = trade?.maximumPrice?.toCorrectPrice()
        minimumPrice.text = trade?.minimumPrice?.toCorrectPrice()
        openPrice.text = Double(trade?.openPrice ?? "0")?.toCorrectPrice()
        closePrice.text = Double(trade?.closePrice ?? "0")?.toCorrectPrice()
        dateLabel.text = trade?.timeInterval?.minute?.toDexStringFormat

        let totalTradings = trade?.tradeAmount ?? 0
        let totalTrades = Double(round(100 * totalTradings) / 100)
        totalTradesPrice.text = "Total trades price: \(totalTrades.formattedWithSeparator) $"
        activityIndicator.color = UIColor.white.withAlphaComponent(0.5)
     }

    @IBAction func closePressed(_ sender: Any) {
        onClose()
    }
}

extension String {
    var toDexStringFormat: String {
        return DateFormatterBuilder
            .dateFormatter(.iso8601Z, timeZone: .utc)
            .date(from: self)?
            .string(.dMMMHHmm, timeZone: .current) ?? ""
    }
}

fileprivate extension Double {
    func toCorrectPrice() -> String {
        let newPrice = self
        if newPrice > 1 {
            return newPrice.percentWithSeparator + " $"
        } else {
            return newPrice.fullFormattedWithSeparator + " $"
        }
    }
}
