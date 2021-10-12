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
        let file: StaticString
        let function: StaticString
        let line: UInt
        
        public init(
            id: UInt64 = .random,
            message: String,
            userInfo: CustomDebugStringConvertible? = nil,
            logLevel: BBLogLevel = .debug,
            category: String? = nil,
            file: StaticString = #file,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.id = id
            self.message = message
            self.userInfo = userInfo
            self.logLevel = logLevel
            self.category = category
            self.file = file
            self.function = function
            self.line = line
        }
    }
}
