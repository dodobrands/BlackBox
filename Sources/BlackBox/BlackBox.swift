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
        _ error: Swift.Error,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) {
        let error = BlackBox.Error(
            error: error,
            category: category,
            file: file,
            function: function,
            line: line
        )
        
        queue.async {
            self.loggers.forEach { logger in
                logger.log(error)
            }
        }
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
        let entry = BlackBox.Event(
            message: message,
            userInfo: userInfo,
            logLevel: logLevel,
            category: category,
            file: file,
            function: function,
            line: line
        )
        
        queue.async {
            self.loggers.forEach { logger in
                logger.log(entry)
            }
        }
    }
    
    public func logStart(
        _ message: String,
        userInfo: CustomDebugStringConvertible?,
        logLevel: BBLogLevel,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) -> Event {
        let entry = Event(
            id: .random,
            message: message,
            userInfo: userInfo,
            category: category,
            file: file,
            function: function,
            line: line
        )
        
        logStart(entry)
        
        return entry
    }
    
    public func logStart(
        _ entry: BlackBox.Event
    ) {
        queue.async {
            self.loggers.forEach { logger in
                logger.logStart(entry)
            }
        }
    }
    
    public func logEnd(
        _ startEntry: BlackBox.Event,
        userInfo: CustomDebugStringConvertible?,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) {
        let endEntry = Event(
            message: startEntry.message,
            userInfo: userInfo,
            logLevel: startEntry.logLevel,
            category: category,
            file: file,
            function: function,
            line: line
        )
        
        queue.async {
            self.loggers.forEach { logger in
                logger.logEnd(startEntry: startEntry,
                              endEntry: endEntry)
            }
        }
    }
}

// MARK: - Static
extension BlackBox {
    public static func log(
        _ error: Swift.Error,
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
    ) -> Event {
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
        _ entry: Event
    ) {
        BlackBox.instance.logStart(entry)
    }
    
    public static func logEnd(
        _ entry: Event,
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
            file: file,
            category: category,
            function: function,
            line: line
        )
    }
}

extension BlackBox {
    public struct Event {
        let id: UInt64
        let message: String
        let userInfo: CustomDebugStringConvertible?
        let logLevel: BBLogLevel
        let category: String?
        let file: StaticString
        let function: StaticString
        let line: UInt
        
        public init(
            id: UInt64 = .random,
            message: String,
            userInfo: CustomDebugStringConvertible? = nil,
            logLevel: BBLogLevel = .debug,
            category: String? = nil,
            file: StaticString = #file,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.id = id
            self.message = message
            self.userInfo = userInfo
            self.logLevel = logLevel
            self.category = category
            self.file = file
            self.function = function
            self.line = line
        }
    }
    
    public struct Error {
        let id: UInt64
        let error: Swift.Error
        let errorUserInfo: CustomDebugStringConvertible?
        let logLevel: BBLogLevel
        let category: String?
        let file: StaticString
        let function: StaticString
        let line: UInt
        
        public init(
            id: UInt64 = .random,
            error: Swift.Error,
            category: String? = nil,
            file: StaticString = #file,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.id = id
            self.error = error
            let errorUserInfo = (error as? CustomNSError)?.errorUserInfo
            self.errorUserInfo = (errorUserInfo?.isEmpty ?? true) ? nil : errorUserInfo
            self.logLevel = error.logLevel
            self.category = category
            self.file = file
            self.function = function
            self.line = line
        }
    }
}

public extension UInt64 {
    static var random: Self {
        random(in: Self.min...Self.max)
    }
}
