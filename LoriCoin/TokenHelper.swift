//
//  TokenHelper.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/21/21.
//

import Foundation
import BigInt

//public static func encodedABI(methodId: Data, arguments: [Any]) -> Data {
//    var data = methodId
//    var arraysData = Data()
//
//    for argument in arguments {
//        switch argument {
//        case let argument as BigUInt:
//            data += pad(data: argument.serialize())
//        case let argument as Address:
//            data += pad(data: argument.raw)
//        case let argument as [Address]:
//            data += pad(data: BigInt(arguments.count * 32 + arraysData.count).serialize())
//            arraysData += encode(array: argument.map { $0.raw })
//        case is Data:
//            data += pad(data: BigUInt(arguments.count * 32 + arraysData.count).serialize())
//            arraysData += pad(data: BigUInt(data.count).serialize()) + data
//        default:
//            ()
//        }
//    }
//
//    return data + arraysData
//}
//
//func pad(data: Data) -> Data {
//    Data(repeating: 0, count: (max(0, 32 - data.count))) + data
//}
