//
//  Double+.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/11/21.
//

import UIKit

extension Double {
    var toDollarPrice: NSAttributedString {
        if self >= 0.5 {
            return NSAttributedString(string: "≈ \(formattedWithSeparator) $")
        } else {
            let mutable = NSMutableAttributedString(string: "≈ \(begin3PriceString)")
            let power = NSAttributedString(string: "\(self.power)", attributes: [.font: UIFont.systemFont(ofSize: 10, weight: .medium), .baselineOffset: 8])
            mutable.append(power)
            mutable.append(NSMutableAttributedString(string: " $"))
            return mutable
        }
    }

    var toBNBPrice: NSAttributedString {
        if self >= 0.5 {
            return NSAttributedString(string: "≈ \(formattedWithSeparator) BNB")
        } else {
            let mutable = NSMutableAttributedString(string: "≈ \(begin5PriceString)")
            let power = NSAttributedString(string: "\(self.power)", attributes: [.font: UIFont.systemFont(ofSize: 10, weight: .medium), .baselineOffset: 8])
            mutable.append(power)
            mutable.append(NSMutableAttributedString(string: " BNB", attributes: [.font: UIFont.systemFont(ofSize: 10, weight: .semibold)]))
            return mutable
        }
    }

    var toBNBPriceLower: NSAttributedString {
        if self >= 0.5 {
            return NSAttributedString(string: "≈ \(formattedWithSeparator) BNB")
        }
        else if self >= 0.00005 {
            return NSAttributedString(string: "≈ \(medium4) BNB")
        } else {
            let mutable = NSMutableAttributedString(string: "≈ \(begin3PriceString)")
            let power = NSAttributedString(string: "\(self.power)", attributes: [.font: UIFont.systemFont(ofSize: 10, weight: .medium), .baselineOffset: 8])
            mutable.append(power)
            mutable.append(NSMutableAttributedString(string: " BNB", attributes: [.font: UIFont.systemFont(ofSize: 10, weight: .semibold)]))
            return mutable
        }
    }

    func toAmount(symbol: String) -> NSAttributedString {
        if self >= 0.5 {
            return NSAttributedString(string: "≈ \(formattedWithSeparator) \(symbol)")
        } else {
            let mutable = NSMutableAttributedString(string: "\(medium4) \(symbol)")
            return mutable
        }
    }
}
