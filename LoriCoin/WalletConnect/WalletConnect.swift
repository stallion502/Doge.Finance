//
//  Copyright © 2019 Gnosis Ltd. All rights reserved.
//

import Foundation
import WalletConnectSwift

protocol WalletConnectDelegate {
    func failedToConnect()
    func didConnect()
    func didDisconnect()
}

class WalletConnect {
    var client: Client!
    var session: Session!
    var delegate: WalletConnectDelegate

    let sessionKey = "sessionKey"

    init(delegate: WalletConnectDelegate) {
        self.delegate = delegate
    }

    func connect() -> String {
        // gnosis wc bridge: https://safe-walletconnect.gnosis.io
        // test bridge with latest protocol version: https://bridge.walletconnect.org
        let wcUrl =  WCURL(topic: UUID().uuidString,
                           bridgeURL: URL(string: "https://safe-walletconnect.gnosis.io")!,
                           key: try! randomKey())
        let clientMeta =
            Session.ClientMeta(name: "ExampleDApp",
                                            description: "WalletConnectSwift ",
                                            icons: [URL(string: "https://img.icons8.com/material-outlined/24/000000/test-tube.png")!],
                                            url: URL(string: "https://safe.gnosis.io")!,
                                            scheme: "trust:")
        
        let dAppInfo = Session.DAppInfo(peerId: UUID().uuidString, peerMeta: clientMeta)
        client = Client(delegate: self, dAppInfo: dAppInfo)

        print("WalletConnect URL: \(wcUrl.absoluteString)")

        try! client.connect(to: wcUrl)
        return wcUrl.absoluteString
    }

    static let safeKeyPrefix = "gnosissafe".data(using: .utf8)!.toHexString()

    func connectv2() throws -> WCURL {
        // Currently controller supports only one session at the time.
        reconnectIfNeeded()

        let key = (try! randomKey())
            // .replacingCharacters(in: ..<Self.safeKeyPrefix.endIndex, with: Self.safeKeyPrefix)
        let bridge = URL(string: "https://bridge.walletconnect.org")!
        let wcUrl =  WCURL(topic: UUID().uuidString,
                           bridgeURL: bridge,
                           key: key)

//        let clientMeta = Session.ClientMeta(
//            name: "Gnosis Safe",
//            description: "The most trusted platform to manage digital assets on Ethereum",
//            icons: [URL(string: "https://gnosis-safe.io/app/favicon.ico")!],
//            url: URL(string: "https://gnosis-safe.io")!,
//            scheme: "gnosissafe")

        let clientMeta =
            Session.ClientMeta(name: "ExampleDApp",
                                            description: "WalletConnectSwift ",
                                            icons: [URL(string: "https://img.icons8.com/material-outlined/24/000000/test-tube.png")!],
                                            url: URL(string: "https://laflix.com")!)

        let dAppInfo = Session.DAppInfo(peerId: UUID().uuidString, peerMeta: clientMeta)
        client = Client(delegate: self, dAppInfo: dAppInfo)
        try client!.connect(to: wcUrl)

        return wcUrl
    }

//    ▿ WCURL
//      - topic : "D947E046-F643-4FD5-AEB6-850AC4043174"
//      - version : "1"
//      ▿ bridgeURL : https://safe-walletconnect.gnosis.io/
//        - _url : https://safe-walletconnect.gnosis.io/
//      - key : "676e6f73697373616665d5581f364a39b1bdbae5d9424a63718a618564b1a03b"

    func reconnectIfNeeded() {
        if let oldSessionObject = UserDefaults.standard.object(forKey: sessionKey) as? Data,
            let session = try? JSONDecoder().decode(Session.self, from: oldSessionObject) {
            client = Client(delegate: self, dAppInfo: session.dAppInfo)
            try? client.reconnect(to: session)
        }
    }

    // https://developer.apple.com/documentation/security/1399291-secrandomcopybytes
    private func randomKey() throws -> String {
        var bytes = [Int8](repeating: 0, count: 32)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        if status == errSecSuccess {
            return Data(bytes: bytes, count: 32).toHexString()
        } else {
            // we don't care in the example app
            enum TestError: Error {
                case unknown
            }
            throw TestError.unknown
        }
    }
}

extension WalletConnect: ClientDelegate {
    func client(_ client: Client, didFailToConnect url: WCURL) {
        delegate.failedToConnect()
    }

    func client(_ client: Client, didConnect url: WCURL) {
        // do nothing
    }

    func client(_ client: Client, didConnect session: Session) {
        self.session = session
        let sessionData = try! JSONEncoder().encode(session)
        UserDefaults.standard.set(sessionData, forKey: sessionKey)
        delegate.didConnect()
    }

    func client(_ client: Client, didDisconnect session: Session) {
        UserDefaults.standard.removeObject(forKey: sessionKey)
        delegate.didDisconnect()
    }

    func client(_ client: Client, didUpdate session: Session) {
        // do nothing
    }
}
