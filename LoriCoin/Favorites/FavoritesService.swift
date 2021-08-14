//
//  FavoritesService.swift
//  HPCompany
//
//  Created by Pozdnyshev Maksim on 6/23/21.
//

import Foundation

final class FavoritesService {
    
    static let shared = FavoritesService()

    static let favs = "FavoritesService"

    func setFavorites(token: TokenInfo, isFavorite: Bool) {
        if isFavorite {
            tokens.append(token)
        } else {
            tokens.removeAll(where: { $0.address == token.address })
        }
    }

    func isFavorite(address: String) -> Bool {
        return tokens.contains(where: { $0.address == address })
    }
    

    var tokens: [TokenInfo] {
        get {
            let teams = UserDefaults.standard.stringArray(forKey: FavoritesService.favs)
            return teams?
                .compactMap { $0.data(using: .utf8) }
                .compactMap { try? JSONDecoder().decode(TokenInfo.self, from: $0) } ?? []
        }
        set {
            let teams = newValue
                .compactMap { try? JSONEncoder().encode($0) }
                .compactMap { String(data: $0, encoding: .utf8) }
            UserDefaults.standard.set(teams, forKey: FavoritesService.favs)
        }
    }
}

