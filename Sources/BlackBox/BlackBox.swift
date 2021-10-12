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
        let event = BlackBox.Event(
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
                logger.log(event)
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
        let event = Event(
            id: .random,
            message: message,
            userInfo: userInfo,
            category: category,
            file: file,
            function: function,
            line: line
        )
        
        logStart(event)
        
        return event
    }
    
    public func logStart(
        _ event: BlackBox.Event
    ) {
        queue.async {
            self.loggers.forEach { logger in
                logger.logStart(event)
            }
        }
    }
    
    public func logEnd(
        _ startEvent: BlackBox.Event,
        userInfo: CustomDebugStringConvertible?,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) {
        let endEvent = Event(
            message: startEvent.message,
            userInfo: userInfo,
            logLevel: startEvent.logLevel,
            category: category,
            file: file,
            function: function,
            line: line
        )
        
        queue.async {
            self.loggers.forEach { logger in
                logger.logEnd(startEvent: startEvent,
                              endEvent: endEvent)
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
        _ event: Event
    ) {
        BlackBox.instance.logStart(event)
    }
    
    public static func logEnd(
        _ event: Event,
        userInfo: CustomDebugStringConvertible? = nil,
        logLevel: BBLogLevel = .debug,
        file: StaticString = #file,
        category: String? = nil,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        BlackBox.instance.logEnd(
            event,
            userInfo: userInfo,
            file: file,
            category: category,
            function: function,
            line: line
        )
    }
}
