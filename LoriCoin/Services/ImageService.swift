//
//  ImageService.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/1/21.
//

import Foundation

class ImageService {
    static let shared = ImageService()

    private var images: [String: String] = [:]

    func loadImage(address: String, completion: () -> String) {
        guard let url = URL(string: "http://92.255.199.69:5101/api/icon/\(address)") else {
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { Data, response, error in

        }.resume()
    }
}
