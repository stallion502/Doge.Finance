//
//  UIImageView+QR.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/17/21.
//

import UIKit
import Foundation

extension UIImage {
    static func generateQRCode(value: String, size: CGSize = .init(width: 150, height: 150)) -> UIImage {
        let data = Data(value.utf8)
        let context = CIContext()
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return .init() }
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            let scaleX = size.width / outputImage.extent.size.width;
            let scaleY = size.height / outputImage.extent.size.height;
            let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
            if let cgimg = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
