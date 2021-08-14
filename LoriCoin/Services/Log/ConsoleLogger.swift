//
//  ConsoleLogger.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/17/21.
//

import Foundation

/// Logs messages to the debug console
final class ConsoleLogger: LogWriter {

    private let formatter = LogFormatter()

    func log(_ message: String,
             level: LogLevel,
             error: Error?,
             file: StaticString,
             line: UInt,
             function: StaticString) {
        let str = formatter.string(from: message,
                                   logLevel: level,
                                   error: error,
                                   filename: String(describing: file),
                                   method: String(describing: function),
                                   line: line,
                                   timestamp: Date())
        print(str)
    }

}
