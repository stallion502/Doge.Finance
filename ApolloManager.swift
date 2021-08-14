//
//  ApolloManager.swift
//  KazanExpress
//
//  Created by Pozdnyshev Maksim on 25.06.2020.
//  Copyright © 2020 Позднышев Максим. All rights reserved.
//

import Apollo

public typealias ISO8601DateTime = String

class ApolloManager {
    private let graphQLEndpoint = "https://graphql.bitquery.io"


    private let store = ApolloStore()

    private lazy var apollo: ApolloClient = {
        let configuration = URLSessionConfiguration.default

        let headers = ["X-API-KEY": "BQYcOOf5Z4Nx7T69PlKbRW02H8URUTC8"]
        
        let url = URL(string: graphQLEndpoint)!

//        let webSocketTransport = WebSocketTransport(request: URLRequest(url: url))
//
//        /// An HTTP transport to use for queries and mutations.
//        let normalTransport = RequestChainNetworkTransport(
//            interceptorProvider: nil,
//            endpointURL: url, additionalHeaders: [:])
//
//        /// A split network transport to allow the use of both of the above transports through a single `NetworkTransport` instance.
//        let splitNetworkTransport = SplitNetworkTransport(
//            uploadingNetworkTransport: normalTransport,
//            webSocketNetworkTransport: webSocketTransport
//        )

        let network = RequestChainNetworkTransport(
            interceptorProvider: LegacyInterceptorProvider(store: store),
            endpointURL: url,
            additionalHeaders: headers
        )

        return ApolloClient(networkTransport: network, store: store)
        
    }()
    
    static let shared = ApolloManager()

    private let bnbAddress = "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c"
    
    func getDexTrades(range: ChartRange, till: String, limit: Int, offset: Int, baseCurrency: String, completion: @escaping (Result<Ethereum?, Error>) -> Void) {
        let query = GetCandleDataQuery(
            baseCurrency: baseCurrency,
            till: till,
            limit: limit,
            offset: offset,
            quoteCurrency: bnbAddress,
            minTrade: 0.1,
            window: range.rawValue
        )

        apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch, queue: DispatchQueue.global()) { (result) in
            switch result {
            case .success(let graphData):
                let value: Ethereum? = graphData.data?.resultMap.value()
                let dexTradesDates = value?.ethereum?.dexTrades?.compactMap { $0.timeInterval?.minute } ?? []
                self.getBNBTrades(range: range, dates: dexTradesDates) { result in
                    switch result {
                    case .success(let bnbs):
                        BNBPriceService.shared.dexTrades = bnbs?.ethereum?.dexTrades ?? []
                    case .failure:
                        break
                    }
                    DispatchQueue.main.async {
                        completion(.success(value))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func getBNBTrades(range: ChartRange, dates: [String], completion: @escaping (Result<Ethereum?, Error>) -> Void) {
        let query = GetBnbbusdQuery(
            dates: dates,
            window: range.rawValue
        )
        apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch, queue: DispatchQueue.main) { (result) in
            switch result {
            case .success(let graphData):
                guard let map =  graphData.data?.resultMap, JSONSerialization.isValidJSONObject(map) else {
                    completion(.failure(NetworkError.invalidObject))
                    return
                }
                let value: Ethereum? = graphData.data?.resultMap.value()
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func devWalletAdress(address: String, completion: @escaping (Result<TransfersEthereum?, Error>) -> Void) {
        let query = DevWalletQuery(address: [address])
        apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch, queue: DispatchQueue.main) { (result) in
            switch result {
            case .success(let graphData):
                guard let map =  graphData.data?.resultMap, JSONSerialization.isValidJSONObject(map) else {
                    completion(.failure(NetworkError.invalidObject))
                    return
                }
                let value: TransfersEthereum? = graphData.data?.resultMap.value()
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func walletBalance(address: String, completion: @escaping (Result<EtheriumAdress?, Error>) -> Void) {
        let query = WalletBalanceQuery(address: address)
        apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch, queue: DispatchQueue.main) { (result) in
            switch result {
            case .success(let graphData):
                let value: EtheriumAdress? = graphData.data?.resultMap.value()
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func whaleTransactions(address: String, completion: @escaping (Result<Ethereum?, Error>) -> Void) {
        let query = GetTopTradesQuery(baseCurrency: address, desc: ["sellAmountInUsd"])
        apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch, queue: DispatchQueue.main) { (result) in
            switch result {
            case .success(let graphData):
                let value: Ethereum? = graphData.data?.resultMap.value()
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func walletTransactions(address: String, completion: @escaping (Result<Ethereum?, Error>) -> Void) {
        let query = WalletTransactionsQuery(adress: address)
        apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch, queue: DispatchQueue.main) { (result) in
            switch result {
            case .success(let graphData):
                let value: Ethereum? = graphData.data?.resultMap.value()
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getTransactions(baseCurrency: String, till: String, limit: Int, offset: Int, quoteCurrency: String, completion: @escaping (Result<Ethereum?, Error>) -> Void) {
        let query = GetTransactionsQuery(
            baseCurrency: baseCurrency, till: till,
            limit: limit,
            offset: offset,
            quoteCurrency: quoteCurrency,
            minTrade: 1,
            window: 1
        )
        apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch, queue: DispatchQueue.main) { (result) in
            switch result {
            case .success(let graphData):
                let value: Ethereum? = graphData.data?.resultMap.value()
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getLatestPrice(baseAddress: String, completion: @escaping (Result<Ethereum?, Error>) -> Void) {
        let query = GetLatestPriceQuery(baseCurrency: baseAddress, quoteCurrency: bnbAddress)
        apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch, queue: DispatchQueue.main) { (result) in
            switch result {
            case .success(let graphData):
                let value: Ethereum? = graphData.data?.resultMap.value()
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension ResultMap {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }

    func value<T: Codable>() -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: [.fragmentsAllowed]) else {
            return nil
        }

        return try? JSONDecoder().decode(T.self, from: data)
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
