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
extension BlackBox: BBLogProtocol {
    public func log(_ error: Error,
                    file: StaticString = #file,
                    function: StaticString = #function,
                    line: UInt = #line) {
        for logger in loggers {
            logger.log(error,
                       file: file,
                       function: function,
                       line: line)
        }
    }
    
    public func log(_ message: String,
                    userInfo: CustomDebugStringConvertible? = nil,
                    logLevel: BBLogLevel = .default,
                    eventType: BBEventType? = nil,
                    file: StaticString = #file,
                    function: StaticString = #function,
                    line: UInt = #line) {
        for logger in loggers {
            logger.log(message,
                       userInfo: userInfo,
                       logLevel: logLevel,
                       eventType: eventType,
                       file: file,
                       function: function,
                       line: line)
        }
    }
}

// MARK: - Static
extension BlackBox {
    public static func log(_ error: Error,
                           file: StaticString = #file,
                           function: StaticString = #function,
                           line: UInt = #line) {
        BlackBox.instance.log(error,
                              file: file,
                              function: function,
                              line: line)
    }
    
    public static func log(_ message: String,
                           userInfo: CustomDebugStringConvertible? = nil,
                           logLevel: BBLogLevel = .default,
                           eventType: BBEventType? = nil,
                           file: StaticString = #file,
                           function: StaticString = #function,
                           line: UInt = #line) {
        BlackBox.instance.log(message,
                              userInfo: userInfo,
                              logLevel: logLevel,
                              eventType: eventType,
                              file: file,
                              function: function,
                              line: line)
    }
}
