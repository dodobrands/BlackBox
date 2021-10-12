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
    private let queue: DispatchQueue
    
    public init(loggers: [BBLoggerProtocol],
                queue: DispatchQueue = .init(label: String(describing: BlackBox.self))) {
        self.loggers = loggers
        self.queue = queue
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
    ) -> LogEntry {
        let entry = LogEntry(id: .random,
                             message: message)
        return logStart(
            entry,
            userInfo: userInfo,
            logLevel: logLevel,
            file: file,
            category: category,
            function: function,
            line: line
        )
    }
    
    public func logStart(
        _ entry: BlackBox.LogEntry,
        userInfo: CustomDebugStringConvertible?,
        logLevel: BBLogLevel,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) -> BlackBox.LogEntry {
        log(
            entry.message,
            userInfo: userInfo,
            logLevel: logLevel,
            eventType: .start,
            eventId: entry.id,
            file: file,
            category: category,
            function: function,
            line: line
        )
        
        return entry
    }
    
    public func logEnd(
        _ entry: LogEntry,
        userInfo: CustomDebugStringConvertible?,
        logLevel: BBLogLevel,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) {
        log(
            entry.message,
            userInfo: userInfo,
            logLevel: logLevel,
            eventType: .end,
            eventId: entry.id,
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
    ) -> LogEntry {
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
    
    public static func logStart(
        _ entry: LogEntry,
        userInfo: CustomDebugStringConvertible? = nil,
        logLevel: BBLogLevel = .debug,
        file: StaticString = #file,
        category: String? = nil,
        function: StaticString = #function,
        line: UInt = #line
    ) -> LogEntry {
        BlackBox.instance.logStart(
            entry,
            userInfo: userInfo,
            logLevel: logLevel,
            file: file,
            category: category,
            function: function,
            line: line
        )
    }
    
    public static func logEnd(
        _ entry: LogEntry,
        userInfo: CustomDebugStringConvertible? = nil,
        logLevel: BBLogLevel = .debug,
        file: StaticString = #file,
        category: String? = nil,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        BlackBox.instance.logEnd(
            entry,
            userInfo: userInfo,
            logLevel: logLevel,
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
        queue.async {
            self.loggers.forEach { logger in
                logger.log(error,
                           eventType: eventType,
                           eventId: eventId,
                           file: file,
                           category: category,
                           function: function,
                           line: line)
            }
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
        queue.async {
            self.loggers.forEach { logger in
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
}

extension BlackBox {
    public struct LogEntry {
        let id: UInt64
        let message: String
        
        public init(
            id: UInt64 = .random,
            message: String
        ) {
            self.id = id
            self.message = message
        }
    }
}

public extension UInt64 {
    static var random: Self {
        random(in: Self.min...Self.max)
    }
}
