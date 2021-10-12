//
//  BlackBoxError.swift
//  
//
//  Created by Алексей Берёзка on 12.10.2021.
//

import Foundation

extension BlackBox {
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
