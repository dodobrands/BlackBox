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
        fileID: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) {
        queue.async {
            let error = BlackBox.ErrorEvent(
                error: error,
                category: category,
                fileID: fileID,
                function: function,
                line: line
            )
            
            self.loggers.forEach { logger in
                logger.log(error)
            }
        }
    }
    
    public func log(
        _ message: String,
        userInfo: CustomDebugStringConvertible?,
        logLevel: BBLogLevel,
        fileID: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) {
        queue.async {
            let event = BlackBox.GenericEvent(
                message,
                userInfo: userInfo,
                logLevel: logLevel,
                category: category,
                fileID: fileID,
                function: function,
                line: line
            )
            
            self.loggers.forEach { logger in
                logger.log(event)
            }
        }
    }
    
    public func logStart(
        _ message: String,
        userInfo: CustomDebugStringConvertible?,
        logLevel: BBLogLevel,
        fileID: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) -> BlackBox.StartEvent {
        let event = StartEvent(
            message,
            userInfo: userInfo,
            logLevel: logLevel,
            category: category,
            fileID: fileID,
            function: function,
            line: line
        )
        
        logStart(event)
        
        return event
    }
    
    public func logStart(
        _ event: BlackBox.StartEvent
    ) {
        queue.async {
            self.loggers.forEach { logger in
                logger.logStart(event)
            }
        }
    }
    
    public func logEnd(
        _ startEvent: BlackBox.StartEvent,
        userInfo: CustomDebugStringConvertible?,
        fileID: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) {
        queue.async {
            let event = EndEvent(
                message: startEvent.rawMessage,
                startEvent: startEvent,
                userInfo: userInfo,
                logLevel: startEvent.logLevel,
                category: category,
                fileID: fileID,
                function: function,
                line: line
            )
            
            self.loggers.forEach { logger in
                logger.logEnd(event)
            }
        }
    }
}

// MARK: - Static
extension BlackBox {
    public static func log(
        _ error: Swift.Error,
        fileID: StaticString = #fileID,
        category: String? = nil,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        BlackBox.instance.log(
            error,
            fileID: fileID,
            category: category,
            function: function,
            line: line
        )
    }
    
    public static func log(
        _ message: String,
        userInfo: CustomDebugStringConvertible? = nil,
        logLevel: BBLogLevel = .debug,
        fileID: StaticString = #fileID,
        category: String? = nil,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        BlackBox.instance.log(
            message,
            userInfo: userInfo,
            logLevel: logLevel,
            fileID: fileID,
            category: category,
            function: function,
            line: line
        )
    }
    
    public static func logStart(
        _ message: String,
        userInfo: CustomDebugStringConvertible? = nil,
        logLevel: BBLogLevel = .debug,
        fileID: StaticString = #fileID,
        category: String? = nil,
        function: StaticString = #function,
        line: UInt = #line
    ) -> StartEvent {
        BlackBox.instance.logStart(
            message,
            userInfo: userInfo,
            logLevel: logLevel,
            fileID: fileID,
            category: category,
            function: function,
            line: line
        )
    }
    
    public static func logStart(
        _ event: StartEvent
    ) {
        BlackBox.instance.logStart(event)
    }
    
    public static func logEnd(
        _ event: StartEvent,
        userInfo: CustomDebugStringConvertible? = nil,
        fileID: StaticString = #fileID,
        category: String? = nil,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        BlackBox.instance.logEnd(
            event,
            userInfo: userInfo,
            fileID: fileID,
            category: category,
            function: function,
            line: line
        )
    }
}

extension BlackBox {
    func moduleName(from fileId: String) -> String? {
        fileId.firstIndex(of: "/").flatMap { String(fileId[fileId.startIndex ..< $0]) }
    }
}
