//
//  SearchService.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/12/21.
//

import Foundation

final class SearchService {

    static let shared = SearchService()

    static let searches = "SearchService"

    var searches: [String] {
        get {
            let teams = UserDefaults.standard.stringArray(forKey: SearchService.searches)
            return teams?
                .compactMap { $0.data(using: .utf8) }
                .compactMap { try? JSONDecoder().decode(String.self, from: $0) } ?? []
        }
        set {
            let teams = newValue
                .compactMap { try? JSONEncoder().encode($0) }
                .compactMap { String(data: $0, encoding: .utf8) }
            UserDefaults.standard.set(teams, forKey: SearchService.searches)
        }
    }
}

