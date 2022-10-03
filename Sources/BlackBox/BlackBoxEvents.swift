//
//  BlackBoxEvent.swift
//  
//
//  Created by Алексей Берёзка on 12.10.2021.
//

import Foundation

public typealias BBUserInfo = [String: Any]
public typealias BBServiceInfo = Any

extension BlackBox {
    public class GenericEvent {
        /// Unique event ID
        public let id: UUID
        /// Timestamp when event occured
        public let timestamp: Date
        /// Event message. May be formatted for some events.
        public let message: String
        /// Default info. Place data you'd like to log here.
        public let userInfo: BBUserInfo?
        /// Place any additional data here. For example, per-event instructions for your custom loggers.
        public let serviceInfo: BBServiceInfo?
        /// level of log
        public let logLevel: BBLogLevel
        /// Category of log. E.g. View Lifecycle.
        public let category: String?
        /// Parent log of current log. May be useful for traces.
        public let parentEvent: GenericEvent?
        /// From where log originated
        public let source: Source
        
        public init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            _ message: String,
            userInfo: BBUserInfo? = nil,
            serviceInfo: BBServiceInfo? = nil,
            logLevel: BBLogLevel = .debug,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            source: Source
        ) {
            self.id = id
            self.timestamp = timestamp
            self.message = message
            self.userInfo = userInfo
            self.serviceInfo = serviceInfo
            self.logLevel = logLevel
            self.category = category
            self.parentEvent = parentEvent
            self.source = source
        }
        
        public convenience init(
            id: UUID = .init(),
            timestamp: Date = .init(),
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
            self.init(
                id: id,
                timestamp: timestamp,
                message,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                logLevel: logLevel,
                category: category,
                parentEvent: parentEvent,
                source: .init(
                    fileID: fileID,
                    function: function,
                    line: line
                )
            )
        }
    }
}

extension BlackBox {
    /// Error event
    public class ErrorEvent: GenericEvent {
        /// Original logged error
        public let error: Swift.Error
        
        public init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            error: Swift.Error,
            userInfo: BBUserInfo? = nil,
            serviceInfo: BBServiceInfo? = nil,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            source: Source
        ) {
            self.error = error
            super.init(
                id: id,
                timestamp: timestamp,
                String(reflecting: error),
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                logLevel: error.logLevel,
                category: category,
                parentEvent: parentEvent,
                source: source
            )
        }
        
        public convenience init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            error: Swift.Error,
            userInfo: BBUserInfo? = nil,
            serviceInfo: BBServiceInfo? = nil,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            fileID: StaticString = #fileID,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.init(
                id: id,
                timestamp: timestamp,
                error: error,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                category: category,
                parentEvent: parentEvent,
                source: .init(
                    fileID: fileID,
                    function: function,
                    line: line
                )
            )
        }
    }
}

extension BlackBox {
    /// Measurement start event
    public class StartEvent: GenericEvent {
        /// Original unformatted message
        public var rawMessage: String
        
        public override init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            _ message: String,
            userInfo: BBUserInfo? = nil,
            serviceInfo: BBServiceInfo? = nil,
            logLevel: BBLogLevel = .debug,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            source: Source
        ) {
            self.rawMessage = message
            super.init(
                id: id,
                timestamp: timestamp,
                "Start: \(message)",
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                logLevel: logLevel,
                category: category,
                parentEvent: parentEvent,
                source: source
            )
        }
        
        public convenience init(
            id: UUID = .init(),
            timestamp: Date = .init(),
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
            self.init(
                id: id,
                timestamp: timestamp,
                message,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                logLevel: logLevel,
                category: category,
                parentEvent: parentEvent,
                source: .init(
                    fileID: fileID,
                    function: function,
                    line: line
                )
            )
        }
    }
}

extension BlackBox {
    public class EndEvent: GenericEvent {
        /// Original unformatted message
        public var rawMessage: String
        
        /// Start event
        public let startEvent: StartEvent
        
        public init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            message: String,
            startEvent: StartEvent,
            userInfo: BBUserInfo? = nil,
            serviceInfo: BBServiceInfo? = nil,
            logLevel: BBLogLevel = .debug,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            source: Source
        ) {
            self.rawMessage = message
            self.startEvent = startEvent
            
            super.init(
                id: id,
                timestamp: timestamp,
                "End: \(message)",
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                logLevel: logLevel,
                category: category,
                parentEvent: parentEvent,
                source: source
            )
        }
        
        public convenience init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            message: String,
            startEvent: StartEvent,
            userInfo: BBUserInfo? = nil,
            serviceInfo: BBServiceInfo? = nil,
            logLevel: BBLogLevel = .debug,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            fileID: StaticString = #fileID,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.init(
                id: id,
                timestamp: timestamp,
                message: message,
                startEvent: startEvent,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                logLevel: logLevel,
                category: category,
                parentEvent: parentEvent,
                source: .init(
                    fileID: fileID,
                    function: function,
                    line: line
                )
            )
        }
    }
}

fileprivate extension String {
    var filename: String {
        URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    var module: String {
        firstIndex(of: "/").flatMap { String(self[self.startIndex ..< $0]) } ?? ""
    }
}

public extension BlackBox.GenericEvent {
    struct Source {
        public let fileID: StaticString
        public let module: String
        public let filename: String
        public let function: StaticString
        public let line: UInt
        
        public init(
            fileID: StaticString = #fileID,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.fileID = fileID
            self.module = fileID.description.module
            self.filename = fileID.description.filename
            self.function = function
            self.line = line
        }
    }
}
