//
//  UIColor+.swift
//  SportLive
//
//

import UIKit

extension UIColor {
    
    // MARK: - Instance Methods

    static let mainBackgorund = UIColor.hex("020102")
    static let mainGreen = UIColor.hex("2DBD85")
    static let mainRed = UIColor.hex("DB4C66")
    static let background = UIColor.hex("020102")
    static let mainYellow = UIColor.hex("D39527")
    static let pink = UIColor.hex("DF169A")

    static func hex(_ hexString: String) -> UIColor {
        var hexString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") { hexString.remove(at: hexString.startIndex) }

        // MARK: - Instance Methods

        var rgbValue:UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        return .init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

