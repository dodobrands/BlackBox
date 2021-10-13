//
//  BlackBoxEvent.swift
//  
//
//  Created by Алексей Берёзка on 12.10.2021.
//

import Foundation

extension BlackBox {
    public class GenericEvent {
        // EventProtocol
        public let id: UInt64
        public let message: String
        public let userInfo: CustomDebugStringConvertible?
        public let logLevel: BBLogLevel
        public let category: String?
        public let module: String
        public let filename: String
        public let function: StaticString
        public let line: UInt
        
        public init(
            id: UInt64 = .random,
            _ message: String,
            userInfo: CustomDebugStringConvertible? = nil,
            logLevel: BBLogLevel = .debug,
            category: String? = nil,
            fileID: StaticString = #fileID,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.id = id
            self.message = message
            self.userInfo = userInfo
            self.logLevel = logLevel
            self.category = category
            self.module = fileID.description.module
            self.filename = fileID.description.filename
            self.function = function
            self.line = line
        }
    }
}

extension BlackBox {
    public class ErrorEvent: GenericEvent {
        public let error: Swift.Error
        
        public init(
            id: UInt64 = .random,
            error: Swift.Error,
            userInfo: CustomDebugStringConvertible? = nil,
            category: String? = nil,
            fileID: StaticString = #fileID,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.error = error
            super.init(id: id,
                       String(reflecting: error),
                       userInfo: userInfo,
                       logLevel: error.logLevel,
                       category: category,
                       fileID: fileID,
                       function: function,
                       line: line)
        }
    }
}

extension BlackBox {
    public class StartEvent: GenericEvent {
        public override init(
            id: UInt64 = .random,
            _ message: String,
            userInfo: CustomDebugStringConvertible? = nil,
            logLevel: BBLogLevel = .debug,
            category: String? = nil,
            fileID: StaticString = #fileID,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            super.init(id: id,
                       "Start: \(message)",
                       userInfo: userInfo,
                       logLevel: logLevel,
                       category: category,
                       fileID: fileID,
                       function: function,
                       line: line)
        }
    }
}

extension BlackBox {
    public class EndEvent: GenericEvent {
        public let startEvent: StartEvent
        
        public init(
            id: UInt64 = .random,
            message: String,
            startEvent: StartEvent,
            userInfo: CustomDebugStringConvertible? = nil,
            logLevel: BBLogLevel = .debug,
            category: String? = nil,
            fileID: StaticString = #fileID,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.startEvent = startEvent
            
            super.init(id: id,
                       "End: \(message)",
                       userInfo: userInfo,
                       logLevel: logLevel,
                       category: category,
                       fileID: fileID,
                       function: function,
                       line: line)
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
