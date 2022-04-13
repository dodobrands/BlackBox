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
        serviceInfo: BBServiceInfo?,
        category: String?,
        parentEvent: GenericEvent?,
        fileID: StaticString,
        function: StaticString,
        line: UInt
    ) {
        queue.async {
            let source = GenericEvent.Source(
                fileID: fileID,
                function: function,
                line: line
            )
            let error = BlackBox.ErrorEvent(
                error: error,
                serviceInfo: serviceInfo,
                category: category,
                parentEvent: parentEvent,
                source: source
            )
            
            self.loggers.forEach { logger in
                logger.log(error)
            }
        }
    }
    
    public func log(
        _ message: String,
        userInfo: BBUserInfo?,
        serviceInfo: BBServiceInfo?,
        logLevel: BBLogLevel,
        category: String?,
        parentEvent: GenericEvent?,
        fileID: StaticString,
        function: StaticString,
        line: UInt
    ) {
        queue.async {
            let source = GenericEvent.Source(
                fileID: fileID,
                function: function,
                line: line
            )
            let event = BlackBox.GenericEvent(
                message,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                logLevel: logLevel,
                category: category,
                parentEvent: parentEvent,
                source: source
            )
            
            self.loggers.forEach { logger in
                logger.log(event)
            }
        }
    }
    
    public func logStart(
        _ message: String,
        userInfo: BBUserInfo?,
        serviceInfo: BBServiceInfo?,
        logLevel: BBLogLevel,
        category: String?,
        parentEvent: GenericEvent?,
        fileID: StaticString,
        function: StaticString,
        line: UInt
    ) -> BlackBox.StartEvent {
        let source = GenericEvent.Source(
            fileID: fileID,
            function: function,
            line: line
        )
        let event = StartEvent(
            message,
            userInfo: userInfo,
            serviceInfo: serviceInfo,
            logLevel: logLevel,
            category: category,
            parentEvent: parentEvent,
            source: source
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
        message: String?,
        userInfo: BBUserInfo?,
        serviceInfo: BBServiceInfo?,
        category: String?,
        parentEvent: GenericEvent?,
        fileID: StaticString,
        function: StaticString,
        line: UInt
    ) {
        queue.async {
            let source = GenericEvent.Source(
                fileID: fileID,
                function: function,
                line: line
            )
            let event = EndEvent(
                message: message ?? startEvent.rawMessage,
                startEvent: startEvent,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                logLevel: startEvent.logLevel,
                category: category,
                parentEvent: parentEvent ?? startEvent.parentEvent,
                source: source
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
        serviceInfo: BBServiceInfo? = nil,
        category: String? = nil,
        parentEvent: GenericEvent? = nil,
        fileID: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        BlackBox.instance.log(
            error,
            serviceInfo: serviceInfo,
            category: category,
            parentEvent: parentEvent,
            fileID: fileID,
            function: function,
            line: line
        )
    }
    
    public static func log(
        _ message: String,
        userInfo: BBUserInfo? = nil,
        serviceInfo: BBServiceInfo? = nil,
        logLevel: BBLogLevel = .debug,
        category: String? = nil,
        parentEvent: GenericEvent? = nil,
        fileID: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        BlackBox.instance.log(
            message,
            userInfo: userInfo,
            serviceInfo: serviceInfo,
            logLevel: logLevel,
            category: category,
            parentEvent: parentEvent,
            fileID: fileID,
            function: function,
            line: line
        )
    }
    
    public static func logStart(
        _ message: String,
        userInfo: BBUserInfo? = nil,
        serviceInfo: BBServiceInfo? = nil,
        logLevel: BBLogLevel = .debug,
        category: String? = nil,
        parentEvent: GenericEvent? = nil,
        fileID: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line
    ) -> StartEvent {
        BlackBox.instance.logStart(
            message,
            userInfo: userInfo,
            serviceInfo: serviceInfo,
            logLevel: logLevel,
            category: category,
            parentEvent: parentEvent,
            fileID: fileID,
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
        message: String? = nil,
        userInfo: BBUserInfo? = nil,
        serviceInfo: BBServiceInfo? = nil,
        category: String? = nil,
        parentEvent: GenericEvent? = nil,
        fileID: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        BlackBox.instance.logEnd(
            event,
            message: message,
            userInfo: userInfo,
            serviceInfo: serviceInfo,
            category: category,
            parentEvent: parentEvent,
            fileID: fileID,
            function: function,
            line: line
        )
    }
}
