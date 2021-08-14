//
//  NetworkManager.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/1/21.
//

import Foundation

enum RequestType {
    case tokenInfo(String)
    case search(String, take: Int, skip: Int)
    case topRaiting(RatingType)
    case transactions(address: String, limit: Int, from: String)

    var url: String {
        switch self {
        case let .transactions(address, limit, from):
            return "/transactions/\(address)?from=\(from)&limit=\(limit)"
        case .tokenInfo(let address):
            return "/token/info/\(address)"
        case .search(let filter, let take, let skip):
            return "/token?filter=\(filter)&take=\(take)&skip=\(skip)"
        case .topRaiting(let rate):
            switch rate {
            case .new:
                return "/top-tokens/new-tokens"
            case .hourVolume:
                return "/top-tokens/hour-volume"
            case .hourTransaction:
                return "/top-tokens/hour-transaction"
            case .dayVolume:
                return "/top-tokens/day-volume"
            case .dayTransaction:
                return "/top-tokens/day-transactions"
            }
        }
    }
}

enum NetworkError: Error {
    case invalidObject
}


final class NetworkManager {
    static let shared = NetworkManager()

    private let baseURL = "http://81.23.151.224:5101/api"

    func buildURL(_ requestType: RequestType) -> URL {
        let url = (baseURL + requestType.url).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return URL(string: url!) ?? URL(string: baseURL)!
    }

    func tokenInfo(address: String, completion: @escaping (Result<TokenInfo, NetworkError>) -> Void) {
        let request = RequestType.tokenInfo(address)
        URLSession.shared.dataTask(
            with: URLRequest(url: buildURL(request))) { data, response, error in
            guard let data = data, let model = try? JSONDecoder().decode(TokenInfo.self, from: data) else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidObject))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(model))
            }
        }.resume()
    }

    func tokenSearch(filter: String, take: Int, skip: Int, completion: @escaping (Result<[TokenSearch], NetworkError>) -> Void) {
        let request = RequestType.search(filter, take: take, skip: skip)
        URLSession.shared.dataTask(
            with: URLRequest(url: buildURL(request))) { data, response, error in
            guard let data = data, let model = try? JSONDecoder().decode([TokenSearch].self, from: data) else {
                DispatchQueue.main.async {
                    completion(.success([]))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(model))
            }
        }.resume()
    }

    func transactions(address: String, limit: Int, from: String, completion: @escaping (Result<[TransactionAPI], NetworkError>) -> Void) {
        let request = RequestType.transactions(address: address, limit: limit, from: from)
        let url = URL(string: "http://81.23.151.224:5101/api/transactions/0x192E9321b6244D204D4301AfA507EB29CA84D9ef?from=2021-07-17T23%3A11%3A37.945Z&limit=100")!
        URLSession.shared.dataTask(
            with: URLRequest(url: buildURL(request))) { data, response, error in
            guard let data = data, let model = try? JSONDecoder().decode([TransactionAPI].self, from: data) else {
                DispatchQueue.main.async {
                    completion(.success([]))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(model))
            }
        }.resume()
    }

//    func bnbPrice(range: ChartRange, dateFrom: String, dateTo: String, completion: @escaping (Result<[TokenSearch], NetworkError>) -> Void) {
//        let request = RequestType.search(filter, take: take, skip: skip)
//        URLSession.shared.dataTask(
//            with: URLRequest(url: buildURL(request))) { data, response, error in
//            guard let data = data, let model = try? JSONDecoder().decode([TokenSearch].self, from: data) else {
//                DispatchQueue.main.async {
//                    completion(.success([]))
//                }
//                return
//            }
//            DispatchQueue.main.async {
//                completion(.success(model))
//            }
//        }.resume()
//    }

    func tokenTopRaiting(rating: RatingType, completion: @escaping (Result<[TokenSearch], NetworkError>) -> Void) {
        let request = RequestType.topRaiting(rating)
        URLSession.shared.dataTask(
            with: URLRequest(url: buildURL(request))) { data, response, error in
            guard let data = data, let model = try? JSONDecoder().decode([TokenSearch].self, from: data) else {
                DispatchQueue.main.async {
                    completion(.success([]))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(model))
            }
        }.resume()
    }
}
