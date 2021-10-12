//
//  BlackBoxEvent.swift
//  
//
//  Created by Алексей Берёзка on 12.10.2021.
//

import Foundation

extension BlackBox {
    public struct Event {
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
            message: String,
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
    public struct Error {
        public let id: UInt64
        public let error: Swift.Error
        public let errorUserInfo: CustomDebugStringConvertible?
        public let logLevel: BBLogLevel
        public let category: String?
        public let module: String
        public let filename: String
        public let function: StaticString
        public let line: UInt
        
        public init(
            id: UInt64 = .random,
            error: Swift.Error,
            category: String? = nil,
            fileID: StaticString = #fileID,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.id = id
            self.error = error
            let errorUserInfo = (error as? CustomNSError)?.errorUserInfo
            self.errorUserInfo = (errorUserInfo?.isEmpty ?? true) ? nil : errorUserInfo
            self.logLevel = error.logLevel
            self.category = category
            self.module = fileID.description.module
            self.filename = fileID.description.filename
            self.function = function
            self.line = line
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
