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
        serviceInfo: BBUserInfo?,
        fileID: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) {
        queue.async {
            let error = BlackBox.ErrorEvent(
                error: error,
                serviceInfo: serviceInfo,
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
        userInfo: BBUserInfo?,
        serviceInfo: BBUserInfo?,
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
                serviceInfo: serviceInfo,
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
        userInfo: BBUserInfo?,
        serviceInfo: BBUserInfo?,
        logLevel: BBLogLevel,
        fileID: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) -> BlackBox.StartEvent {
        let event = StartEvent(
            message,
            userInfo: userInfo,
            serviceInfo: serviceInfo,
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
        alternateMessage: String?,
        userInfo: BBUserInfo?,
        serviceInfo: BBUserInfo?,
        fileID: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) {
        queue.async {
            let event = EndEvent(
                message: alternateMessage ?? startEvent.rawMessage,
                startEvent: startEvent,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
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
        serviceInfo: BBUserInfo? = nil,
        fileID: StaticString = #fileID,
        category: String? = nil,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        BlackBox.instance.log(
            error,
            serviceInfo: serviceInfo,
            fileID: fileID,
            category: category,
            function: function,
            line: line
        )
    }
    
    public static func log(
        _ message: String,
        userInfo: BBUserInfo? = nil,
        serviceInfo: BBUserInfo? = nil,
        logLevel: BBLogLevel = .debug,
        fileID: StaticString = #fileID,
        category: String? = nil,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        BlackBox.instance.log(
            message,
            userInfo: userInfo,
            serviceInfo: serviceInfo,
            logLevel: logLevel,
            fileID: fileID,
            category: category,
            function: function,
            line: line
        )
    }
    
    public static func logStart(
        _ message: String,
        userInfo: BBUserInfo? = nil,
        serviceInfo: BBUserInfo? = nil,
        logLevel: BBLogLevel = .debug,
        fileID: StaticString = #fileID,
        category: String? = nil,
        function: StaticString = #function,
        line: UInt = #line
    ) -> StartEvent {
        BlackBox.instance.logStart(
            message,
            userInfo: userInfo,
            serviceInfo: serviceInfo,
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
        alternateMessage: String? = nil,
        userInfo: BBUserInfo? = nil,
        serviceInfo: BBUserInfo? = nil,
        fileID: StaticString = #fileID,
        category: String? = nil,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        BlackBox.instance.logEnd(
            event,
            alternateMessage: alternateMessage,
            userInfo: userInfo,
            serviceInfo: serviceInfo,
            fileID: fileID,
            category: category,
            function: function,
            line: line
        )
    }
}
