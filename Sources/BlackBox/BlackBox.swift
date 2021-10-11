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
    public func log(
        _ error: Error,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) {
        log(
            error,
            eventType: .event,
            eventId: nil,
            file: file,
            category: category,
            function: function,
            line: line
        )
    }
    
    public func log(
        _ message: String,
        userInfo: CustomDebugStringConvertible?,
        logLevel: BBLogLevel,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) {
        log(
            message,
            userInfo: userInfo,
            logLevel: logLevel,
            eventType: .event,
            eventId: nil,
            file: file,
            category: category,
            function: function,
            line: line
        )
    }
    
    public func logStart(
        _ message: String,
        userInfo: CustomDebugStringConvertible?,
        logLevel: BBLogLevel,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) -> UInt64 {
        let id = UInt64.random
        log(
            message,
            userInfo: userInfo,
            logLevel: logLevel,
            eventType: .start,
            eventId: id,
            file: file,
            category: category,
            function: function,
            line: line
        )
        return id
    }
    
    public func logEnd(
        _ message: String,
        userInfo: CustomDebugStringConvertible?,
        logLevel: BBLogLevel,
        eventId: UInt64,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) {
        log(
            message,
            userInfo: userInfo,
            logLevel: logLevel,
            eventType: .start,
            eventId: eventId,
            file: file,
            category: category,
            function: function,
            line: line
        )
    }
    
    public func logEnd(
        _ error: Error,
        eventId: UInt64,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) {
        log(
            error,
            eventType: .end,
            eventId: eventId,
            file: file,
            category: category,
            function: function,
            line: line
        )
    }
}

// MARK: - Static
extension BlackBox {
    public static func log(
        _ error: Error,
        file: StaticString = #file,
        category: String? = nil,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        BlackBox.instance.log(
            error,
            file: file,
            category: category,
            function: function,
            line: line
        )
    }
    
    public static func log(
        _ message: String,
        userInfo: CustomDebugStringConvertible? = nil,
        logLevel: BBLogLevel = .debug,
        file: StaticString = #file,
        category: String? = nil,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        BlackBox.instance.log(
            message,
            userInfo: userInfo,
            logLevel: logLevel,
            file: file,
            category: category,
            function: function,
            line: line
        )
    }
    
    public static func logStart(
        _ message: String,
        userInfo: CustomDebugStringConvertible? = nil,
        logLevel: BBLogLevel = .debug,
        file: StaticString = #file,
        category: String? = nil,
        function: StaticString = #function,
        line: UInt = #line
    ) -> UInt64 {
        BlackBox.instance.logStart(
            message,
            userInfo: userInfo,
            logLevel: logLevel,
            file: file,
            category: category,
            function: function,
            line: line
        )
    }
    
    public static func logEnd(
        _ message: String,
        userInfo: CustomDebugStringConvertible? = nil,
        logLevel: BBLogLevel = .debug,
        eventId: UInt64,
        file: StaticString = #file,
        category: String? = nil,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        BlackBox.instance.logEnd(
            message,
            userInfo: userInfo,
            logLevel: logLevel,
            eventId: eventId,
            file: file,
            category: category,
            function: function,
            line: line
        )
    }
    
    public static func logEnd(
        _ error: Error,
        eventId: UInt64,
        file: StaticString = #file,
        category: String? = nil,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        BlackBox.instance.logEnd(
            error,
            eventId: eventId,
            file: file,
            category: category,
            function: function,
            line: line
        )
    }
}

extension BlackBox {
    private func log(
        _ error: Error,
        eventType: BBEventType,
        eventId: UInt64?,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) {
        loggers.forEach { logger in
            logger.log(error,
                       eventType: eventType,
                       eventId: eventId,
                       file: file,
                       category: category,
                       function: function,
                       line: line)
        }
    }
    
    private func log(
        _ message: String,
        userInfo: CustomDebugStringConvertible?,
        logLevel: BBLogLevel,
        eventType: BBEventType,
        eventId: UInt64?,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) {
        loggers.forEach { logger in
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

fileprivate extension UInt64 {
    static var random: Self {
        random(in: Self.min...Self.max)
    }
}
