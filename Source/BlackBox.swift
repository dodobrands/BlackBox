//
//  BlackBox.swift
//  DFoundation
//
//  Created by Алексей Берёзка on 27.02.2020.
//  Copyright © 2020 ru.dodopizza. All rights reserved.
//

import Foundation

public class BlackBox {
    public static var instance = BlackBox(loggers: [])
    
    private let loggers: [BBLoggerProtocol]
    
    public init(loggers: [BBLoggerProtocol]) {
        self.loggers = loggers
    }
}

// MARK: - Instance
extension BlackBox: BBProtocol {
    public func log(_ error: Error,
                    file: StaticString = #file,
                    category: String? = nil,
                    function: StaticString = #function,
                    line: UInt = #line) {
        for logger in loggers {
            logger.log(error,
                       logLevel: error.logLevel,
                       file: file,
                       category: category,
                       function: function,
                       line: line)
        }
    }
    
    public func log(_ message: String,
                    userInfo: CustomDebugStringConvertible? = nil,
                    logLevel: BBLogLevel = .default,
                    eventType: BBEventType? = nil,
                    eventId: UInt64? = nil,
                    file: StaticString = #file,
                    category: String? = nil,
                    function: StaticString = #function,
                    line: UInt = #line) {
        for logger in loggers {
            logger.log(message,
                       userInfo: userInfo,
                       logLevel: logLevel,
                       eventType: eventType,
                       eventId: eventId,
                       file: file,
                       category: category,
                       function: function,
                       line: line)
        }
    }
}

// MARK: - Static
extension BlackBox {
    public static func log(_ error: Error,
                           file: StaticString = #file,
                           category: String? = nil,
                           function: StaticString = #function,
                           line: UInt = #line) {
        BlackBox.instance.log(error,
                              file: file,
                              category: category,
                              function: function,
                              line: line)
    }
    
    public static func log(_ message: String,
                           userInfo: CustomDebugStringConvertible? = nil,
                           logLevel: BBLogLevel = .default,
                           eventType: BBEventType? = nil,
                           eventId: UInt64? = nil,
                           file: StaticString = #file,
                           category: String? = nil,
                           function: StaticString = #function,
                           line: UInt = #line) {
        BlackBox.instance.log(message,
                              userInfo: userInfo,
                              logLevel: logLevel,
                              eventType: eventType,
                              eventId: eventId,
                              file: file,
                              category: category,
                              function: function,
                              line: line)
    }
}

extension Swift.Error {
    var logLevel: BBLogLevel {
        if let logLevelError = self as? BBLogLevelProvider {
            return logLevelError.logLevel
        } else {
            return .error
        }
    }
}
