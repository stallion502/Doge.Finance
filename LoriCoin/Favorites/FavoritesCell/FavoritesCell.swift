//
//  FavoritesCell.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/9/21.
//

import UIKit

class FavoritesCell: UITableViewCell {
    @IBOutlet weak var volumeChangeLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var liqudityLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var totalSupplyLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var usdtPriceLabel: UILabel!
    @IBOutlet weak var dayPriceChangeLabel: UILabel!
    @IBOutlet private weak var tokenTitleLabel: UILabel!
    @IBOutlet private weak var tokenImageView: UIImageView!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!

    private var token: TokenInfo?
    
    func setup(with token: TokenInfo) {
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

        if let price = token.usdtPrice {
            usdtPriceLabel.attributedText = price.toBNBPrice
        }

        if let price = token.usdtPrice {
            if price == 0 {
                priceLabel.text = "-"
            }
             else if price > 1 {
                priceLabel.text = "\(price.mediumWithSeparator) $"
            } else {
                priceLabel.text = "\(price.fullFormattedWithSeparator) $"
            }
        }
        let isUp = token.dayPriceChange.value > 0
        arrowImageView.transform = isUp ? CGAffineTransform(rotationAngle: .pi) : .identity
        arrowImageView.tintColor = isUp ? .mainGreen : .mainRed

        if token.dayPriceChange.value != 0 {
            dayPriceChangeLabel.text = "\(isUp ? "+" : "")\(token.dayPriceChange.value.percentWithSeparator) %"
        } else {
            dayPriceChangeLabel.text = ""
        }
        addressLabel.text = "\(token.address?.prefix(6) ?? "")..."

        let marketCap = token.marketCap.value
        if marketCap > 0.5 {
            marketCapLabel.text = "\(marketCap.witoutDecimals) $"
        } else {
            marketCapLabel.text = "\(marketCap.beginPriceString) $"
        }

        var supply = token.supply.value
        if supply > 100000000 {
            supply /= 1000000
            totalSupplyLabel.text = supply == 0 ? "-" : "\(supply.witoutDecimals) mln."
        } else {
            totalSupplyLabel.text = "\(supply.witoutDecimals)"
        }

        let liqudity = token.liquidityInUsdt.value
        if liqudity > 1 {
            liqudityLabel.text = "\(liqudity.witoutDecimals) $"
        } else {
            liqudityLabel.text = "\(liqudity.fullFormattedWithSeparator) $"
        }

        let dayVolumeChange = token.dayVolumeChange.value
        volumeChangeLabel.superview?.isHidden = dayVolumeChange == 0
        let isVolumeUp = dayVolumeChange >= 0
        volumeChangeLabel.text = dayVolumeChange == 0 ? "" : "\(isVolumeUp ? "+" : "")\(dayVolumeChange.percentWithSeparator) %"
    }

    func update(with tokenPrice: TokenInfo?, newInfo: TokenSocketModel?) {
        if let currentPrice = tokenPrice?.usdtPrice, let newPrice = newInfo?.priceInUsdt {
            guard currentPrice != newPrice && newPrice != 0 else { return }
            UIView.animate(withDuration: 0.3, animations: {
                if let price = newInfo?.priceInBnb {
                    self.usdtPriceLabel.attributedText = price.toBNBPrice
                }

               if newPrice > 1 {
                    self.priceLabel.text = "\(newPrice.mediumWithSeparator) $"
                } else {
                    self.priceLabel.text = "\(newPrice.fullFormattedWithSeparator) $"
                }
                self.usdtPriceLabel.textColor = currentPrice > newPrice ? .mainRed : .mainGreen
                self.priceLabel.textColor = currentPrice > newPrice ? .mainRed : .mainGreen
            }, completion: { _ in
                self.perform(#selector(self.restoreTextColor), with: nil, afterDelay: 1.5)
            })
        }

        if let currentMC = tokenPrice?.marketCap, let newMP = newInfo?.marketCap {
            guard currentMC != newMP && newMP != 0 else { return }
            UIView.animate(withDuration: 0.3, animations: {
                self.marketCapLabel.text = "\(newMP.witoutDecimals) $"
                self.marketCapLabel.textColor = currentMC > newMP ? .mainRed : .mainGreen
            })
        }

        if let currentChange = tokenPrice?.dayPriceChange, let newChange = newInfo?.dayPriceChange {
            let isUp = newChange > 0

            UIView.animate(withDuration: 0.3, animations: {
                self.dayPriceChangeLabel.text = newChange == 0 ? "" : "\(isUp ? "+" : "")\(newChange.percentWithSeparator) %"

                self.dayPriceChangeLabel.textColor = currentChange > newChange ? .mainRed : .mainGreen
            })
        }

        if let currentLP = tokenPrice?.liquidityInUsdt, let newLP = newInfo?.liquidityInUsdt {
            guard currentLP != newLP && newLP != 0 else { return }
            UIView.animate(withDuration: 0.3, animations: {
                if newLP > 1 {
                    self.liqudityLabel.text = "\(newLP.witoutDecimals) $"
                } else {
                    self.liqudityLabel.text = "\(newLP.fullFormattedWithSeparator) $"
                }
                self.liqudityLabel.textColor = currentLP > newLP ? .mainRed : .mainGreen
            })
        }

        self.perform(#selector(self.restoreTextColor), with: nil, afterDelay: 1.5)
    }

    @objc private func restoreTextColor() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState], animations: {
            self.usdtPriceLabel.textColor = .white
            self.liqudityLabel.textColor = .white
            self.priceLabel.textColor = .white
            self.dayPriceChangeLabel.textColor = .white
            self.marketCapLabel.textColor = .white
        }, completion: nil)
    }

    @IBAction func bscPressed(_ sender: Any) {
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
}
