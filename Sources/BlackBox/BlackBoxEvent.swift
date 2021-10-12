//
//  BlackBoxEvent.swift
//  
//
//  Created by Алексей Берёзка on 12.10.2021.
//

import Foundation

extension BlackBox {
    public struct Event {
        let id: UInt64
        let message: String
        let userInfo: CustomDebugStringConvertible?
        let logLevel: BBLogLevel
        let category: String?
        let module: String
        let filename: String
        let function: StaticString
        let line: UInt
        
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
        let id: UInt64
        let error: Swift.Error
        let errorUserInfo: CustomDebugStringConvertible?
        let logLevel: BBLogLevel
        let category: String?
        let module: String
        let filename: String
        let function: StaticString
        let line: UInt
        
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
