//
//  EthereumNodeService.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/17/21.
//

import Foundation
import Web3
import Web3PromiseKit
import Web3ContractABI

class EthereumNodeService {

    init() { }

    func balanceOf(walletAddress: String, contractAddress: String, rpcURL: URL, compltion: @escaping (BigUInt?) -> Void) {
        let web3 = Web3(rpcURL: rpcURL.absoluteString)
        let contractAddress = try! EthereumAddress(hex: contractAddress, eip55: false)
        let contract = web3.eth.Contract(type: GenericERC20Contract.self, address: contractAddress)
        try! contract.balanceOf(address: EthereumAddress(hex: walletAddress, eip55: true)).call { outputs, error  in
            compltion(outputs?["_balance"] as? BigUInt)
        }
    }

    func eth_call(to: Address, rpcURL: URL, data: Data) throws -> Data {
        let web3 = Web3(rpcURL: rpcURL.absoluteString)
        let semaphore = DispatchSemaphore(value: 0)

        var result: Web3Response<EthereumData>!

        web3.eth.call(call: EthereumCall(to: try EthereumAddress(to.data), data: EthereumData(Array(data))),
                      block: EthereumQuantityTag(tagType: .latest),
                      response: { result = $0; semaphore.signal() })
        semaphore.wait()

        if let error = result.error {
            if let web3Error = error as? Web3Response<EthereumData>.Error {
                switch web3Error {
                case .connectionFailed(let error):
                    if let error = error {
                        throw WalletError.detailedError(from: error)
                    } else {
                        throw WalletError.ThirdPartyError(reason: "Web3 library connection failed")
                    }
                case .emptyResponse:
                    throw WalletError.ThirdPartyError(reason: "Web3 library empty response")
                case .requestFailed(let error):
                    if let error = error {
                        throw WalletError.detailedError(from: error)
                    } else {
                        throw WalletError.ThirdPartyError(reason: "Web3 library request failed")
                    }
                case .serverError(let error):
                    if let error = error {
                        throw WalletError.detailedError(from: error)
                    } else {
                        throw WalletError.ThirdPartyError(reason: "Web3 library server error")
                    }
                case .decodingError(let error):
                    if let error = error {
                        throw WalletError.detailedError(from: error)
                    } else {
                        throw WalletError.ThirdPartyError(reason: "Web3 library decoding error")
                    }
                }
            }
            throw WalletError.ThirdPartyError(reason: "Web3 library unknown error")
        } else if let data = result.result {
            return Data(data.bytes)
        } else {
            return Data()
        }
    }

    public func rawCall(payload: String, rpcURL: URL) throws -> String {
        // all requests are proxied to the infura service as is because it is simple to do it now.
        struct RawJSONRPCRequest: HTTPRequest {
            var httpMethod: String { return "POST" }
            var urlPath: String { return "/" }
            var body: Data?
            var url: URL?
            var headers: [String: String] { return ["Content-Type": "application/json"] }
        }
        guard let body = payload.data(using: .utf8) else {
            throw WalletError.ThirdPartyError(reason: "Request payload is malformed")
        }
        let request = RawJSONRPCRequest(body: body, url: rpcURL)
        let client = HTTPClient(url: rpcURL, logger: LogService.shared)
        let response = try client.execute(request: request)
        guard let result = String(data: response, encoding: .utf8) else {
            throw WalletError.ThirdPartyError(reason: "Response is empty")
        }
        return result
    }
}
