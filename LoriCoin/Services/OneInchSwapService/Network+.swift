//
//  Network+.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 8/15/21.
//

import Foundation
import HsToolKit
import RxSwift
import Alamofire

extension NetworkManager {
    public func single<Mapper: IApiMapper>(url: URLConvertible, method: HTTPMethod, parameters: Parameters, mapper: Mapper, encoding: ParameterEncoding = URLEncoding.default,
                                           headers: HTTPHeaders? = nil, interceptor: RequestInterceptor? = nil, responseCacherBehavior: ResponseCacher.Behavior? = nil) -> Single<Mapper.T> {
        let serializer = JsonMapperResponseSerializer<Mapper>(mapper: mapper, logger: nil)

        return Single<Mapper.T>.create { [weak self] observer in
            guard let manager = self else {
                observer(.error(NetworkManager.RequestError.noResponse(reason: nil)))
                return Disposables.create()
            }

            var request = manager.session.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers, interceptor: interceptor)

            if let behavior = responseCacherBehavior {
                request = request.cacheResponse(using: ResponseCacher(behavior: behavior))
            }

            let requestReference = request.response(queue: DispatchQueue.global(qos: .background), responseSerializer: serializer) { response in
                switch response.result {
                case .success(let result):
                    observer(.success(result))
                case .failure(let error):
                    observer(.error(NetworkManager.unwrap(error: error)))
                }
            }

            return Disposables.create {
                requestReference.cancel()
            }
        }
    }
}

extension NetworkManager {

    class NetworkLogger: EventMonitor {
        private var logger: Logger?

        let queue = DispatchQueue(label: "Network Logger", qos: .background)

        init(logger: Logger?) {
            self.logger = logger
        }

        func requestDidResume(_ request: Request) {
            var parametersLog = ""

            if let httpBody = request.request?.httpBody, let json = try? JSONSerialization.jsonObject(with: httpBody), let data = try? JSONSerialization.data(withJSONObject: json, options: [.sortedKeys, .prettyPrinted]), let string = String(data: data, encoding: .utf8) {
                parametersLog = "\n\(string)"
            }

            logger?.debug("API OUT [\(request.id)]\n\(request)\(parametersLog)\n")
        }

        func requestIsRetrying(_ request: Request) {
            logger?.debug("API RETRY: \(request.id)")
        }

        func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
            switch response.result {
            case .success(let result):
                logger?.debug("API IN [\(request.id)]\n\(result)\n")
            case .failure(let error):
                logger?.error("API IN [\(request.id)]\n\(NetworkManager.unwrap(error: error))\n")
            }
        }

    }

}

extension NetworkManager {

    class JsonMapperResponseSerializer<Mapper: IApiMapper>: ResponseSerializer {
        private let mapper: Mapper
        private var logger: Logger?

        private let jsonSerializer = JSONResponseSerializer()

        init(mapper: Mapper, logger: Logger?) {
            self.mapper = mapper
            self.logger = logger
        }

        func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> Mapper.T {
            guard let response = response else {
                throw RequestError.noResponse(reason: error?.localizedDescription)
            }

            let json = try? jsonSerializer.serialize(request: request, response: response, data: data, error: nil)

            if let json = json {
                logger?.debug("JSON Response:\n\(json)")
            }

            return try mapper.map(statusCode: response.statusCode, data: json)
        }

    }

}

extension NetworkManager {

    public static func unwrap(error: Error) -> Error {
        if case let AFError.responseSerializationFailed(reason) = error, case let .customSerializationFailed(error) = reason {
            return error
        }

        return error
    }
}

public protocol IApiMapper {
    associatedtype T
    func map(statusCode: Int, data: Any?) throws -> T
}
