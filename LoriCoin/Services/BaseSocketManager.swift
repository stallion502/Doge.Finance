//зщ
import Foundation
import SwiftSignalRClient

class BaseSocketManager {

    typealias TokenInfoClosure = (TokenSocketModel?, String) -> Void
    typealias TokenTransactionClosure = (TransactionAPI?, String) -> Void
    private let baseURL = "http://81.23.151.224:5101"
    static let shared = BaseSocketManager()
    var tokenConnections: [String: HubConnection] = [:]
    var subscribers: [String: TokenInfoClosure] = [:]

    func subscribeOnPriceChange(address: String, subscriber: @escaping TokenInfoClosure, transactionSubscriber: TokenTransactionClosure? = nil) {
        let connection = HubConnectionBuilder(url: URL(string: "\(baseURL)/token-notification-hub?token=\(address)")!)
            .withLogging(minLogLevel: .error)
            .build()

        tokenConnections[address] = connection
        subscribers[address] = subscriber
        connection.on(method: "tokenInfo") { [address] ars in
            let tokenInfo = try? ars.getArgument(type: TokenSocketModel.self)
            subscriber(tokenInfo, address)
        }
        if let transactionSubscriber = transactionSubscriber {
            connection.on(method: "transactionInfo") { [address] ars in
                let tokenInfo = try? ars.getArgument(type: TransactionAPI.self)
                transactionSubscriber(tokenInfo, address)
            }
        }
        connection.start()
    }

    func removeSubscription(_ address: String) {
        tokenConnections[address]?.stop()
        tokenConnections[address] = nil
    }

    func stopSubscription() {
        tokenConnections.forEach { $0.value.stop() }
    }

    func restartSubscriptons() {
        tokenConnections.forEach { $0.value.start() }
    }
}
