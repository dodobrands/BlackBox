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
        public let id: UInt64
        public let message: String
        /// Default info. Place data you'd like to log here.
        public let userInfo: BBUserInfo?
        /// Place any additional data here. For example, per-event instructions for your custom loggers.
        public let serviceInfo: BBServiceInfo?
        public let logLevel: BBLogLevel
        public let category: String?
        public let parentEvent: GenericEvent?
        public let source: Source
        
        public init(
            id: UInt64 = .random,
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
            self.id = id
            self.message = message
            self.userInfo = userInfo
            self.serviceInfo = serviceInfo
            self.logLevel = logLevel
            self.category = category
            self.parentEvent = parentEvent
            self.source = .init(
                fileID: fileID,
                function: function,
                line: line
            )
        }
    }
}

extension BlackBox {
    public class ErrorEvent: GenericEvent {
        public let error: Swift.Error
        
        public init(
            id: UInt64 = .random,
            error: Swift.Error,
            userInfo: BBUserInfo? = nil,
            serviceInfo: BBServiceInfo? = nil,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            fileID: StaticString = #fileID,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.error = error
            super.init(id: id,
                       String(reflecting: error),
                       userInfo: userInfo,
                       serviceInfo: serviceInfo,
                       logLevel: error.logLevel,
                       category: category,
                       parentEvent: parentEvent,
                       fileID: fileID,
                       function: function,
                       line: line)
        }
    }
}

extension BlackBox {
    public class StartEvent: GenericEvent {
        public var rawMessage: String
        
        public override init(
            id: UInt64 = .random,
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
            self.rawMessage = message
            super.init(id: id,
                       "Start: \(message)",
                       userInfo: userInfo,
                       serviceInfo: serviceInfo,
                       logLevel: logLevel,
                       category: category,
                       parentEvent: parentEvent,
                       fileID: fileID,
                       function: function,
                       line: line)
        }
    }
}

extension BlackBox {
    public class EndEvent: GenericEvent {
        public var rawMessage: String
        public let startEvent: StartEvent
        
        public init(
            id: UInt64 = .random,
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
            self.rawMessage = message
            self.startEvent = startEvent
            
            super.init(id: id,
                       "End: \(message)",
                       userInfo: userInfo,
                       serviceInfo: serviceInfo,
                       logLevel: logLevel,
                       category: category,
                       parentEvent: parentEvent,
                       fileID: fileID,
                       function: function,
                       line: line)
        }
        
        public init(
            id: UInt64 = .random,
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
            
            super.init(id: id,
                       "End: \(message)",
                       userInfo: userInfo,
                       serviceInfo: serviceInfo,
                       logLevel: logLevel,
                       category: category,
                       parentEvent: parentEvent,
                       fileID: source.fileID,
                       function: source.function,
                       line: source.line)
        }
    }
}

public indirect enum Profiling {
    case start
    case end(startEvent: BlackBox.GenericEvent)
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
        
        public let fileID: StaticString
        public let module: String
        public let filename: String
        public let function: StaticString
        public let line: UInt
    }
}
