//
//  HTTPClientError.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/17/21.
//

import Foundation

fileprivate let errorDomain = "HTTPClientError"

enum HTTPClientError {
    static func error(_ request: URLRequest, _ response: URLResponse?, _ data: Data?, _ error: Error?) -> Error {
        // system errors
        if let error = error {
            return WalletError.detailedError(from: error)
        }

        // backend errors
        return WalletError.detailedError(from: response as! HTTPURLResponse, data: data)
    }
}

protocol RequestFailure: CustomStringConvertible {
    var requestURL: URL? { get }
}

extension RequestFailure {
    var description: String {
        "[\(String(describing: type(of: self)))]: Request failed: \(requestURL?.absoluteString ?? "<no url>")"
    }
}
