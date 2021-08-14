//
//  FirDatabase.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/24/21.
//

import Foundation
import FirebaseDatabase

struct Socials: Codable {
    let twitter: String?
    let tg: String?
}

class FirDatabaseService {
    fileprivate struct Constants {
        static let banners = "Banners"
        static let socials = "Socials"
    }
//    let botURL = URL.init(string: "tg://resolve?domain=\(tg)")
    private let ref = Database.database().reference()

    static let shared = FirDatabaseService()

    func setBanners(_ banners: [Banner]) {
        let encoder = JSONEncoder()
        let strings = banners.compactMap { news -> Data? in try? encoder.encode(news) }.compactMap { $0.base64EncodedString() }
        var newsJSON: [String: String] = .init()
        strings.enumerated().forEach {
            newsJSON["\($0.offset)"] = $0.element
        }
        ref.child(Constants.banners).setValue(newsJSON)
    }

    func getBanners(completion: @escaping ([Banner]) -> Void) {
        ref.child(Constants.banners).observeSingleEvent(of: .value) { (snapshot) in
            let objects: [Banner] = snapshot.children.allObjects
                .compactMap { element -> Banner? in
                    guard
                        let snap = element as? DataSnapshot,
                        let value = snap.value as? String,
                        let data = Data(base64Encoded: value),
                        let news = try? JSONDecoder().decode(Banner.self, from: data)
                    else { return nil }
                    return news
                }
            completion(objects)
        }
    }


    func setSocials(_ social: Socials) {
        let encoder = JSONEncoder()
        let strings = [social].compactMap { news -> Data? in try? encoder.encode(news) }.compactMap { $0.base64EncodedString() }
        var newsJSON: [String: String] = .init()
        strings.enumerated().forEach {
            newsJSON["\($0.offset)"] = $0.element
        }
        ref.child(Constants.socials).setValue(newsJSON)
    }

    func getSocials(completion: @escaping (Socials?) -> Void) {
        ref.child(Constants.socials).observeSingleEvent(of: .value) { (snapshot) in
            let objects: [Socials] = snapshot.children.allObjects
                .compactMap { element -> Socials? in
                    guard
                        let snap = element as? DataSnapshot,
                        let value = snap.value as? String,
                        let data = Data(base64Encoded: value),
                        let news = try? JSONDecoder().decode(Socials.self, from: data)
                    else { return nil }
                    return news
                }
            completion(objects.first)
        }
    }
}
