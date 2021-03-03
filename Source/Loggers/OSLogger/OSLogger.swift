//
//  OSLogger.swift
//  DodoPizza
//
//  Created by Алексей Берёзка on 27.02.2020.
//  Copyright © 2020 Dodo Pizza. All rights reserved.
//

import Foundation
import os

@available(iOS 12.0, *)
extension BlackBox {
    public class OSLogger: BBLoggerProtocol {
        public init(){}
        
        public func log(_ error: Error,
                        logLevel: BBLogLevel,
                        file: StaticString,
                        category: String?,
                        function: StaticString,
                        line: UInt) {
            let message = String(reflecting: error)
            log(message,
                userInfo: nil,
                logger: logger(file: file, category: category),
                file: file,
                function: function,
                logType: logLevel.osLogType)
        }
        
        public func log(_ message: String,
                        userInfo: CustomDebugStringConvertible?,
                        logLevel: BBLogLevel,
                        eventType: BBEventType?,
                        eventId: UInt64?,
                        file: StaticString,
                        category: String?,
                        function: StaticString,
                        line: UInt) {
            log(message,
                userInfo: userInfo,
                logger: logger(file: file, category: category),
                file: file,
                function: function,
                logType: logLevel.osLogType)
        }
        
        private func logger(file: StaticString, category: String?) -> OSLog {
            OSLog(subsystem: file.bbFilename, category: category ?? "")
        }
    }
}

@available(iOS 12.0, *)
extension BlackBox.OSLogger {
    private func log(_ message: String,
                     userInfo: CustomDebugStringConvertible?,
                     logger: OSLog,
                     file: StaticString,
                     function: StaticString,
                     logType: OSLogType) {
        let userInfo = userInfo?.bbLogDescription ?? "nil"
        let message = message + "\n\n" + "[User Info]:" + "\n" + userInfo
        
        os_log(logType,
               log: logger,
               "%{public}@\n%{public}@", function.description, message)
    }
}

@available(iOS 12.0, *)
extension BBLogLevel {
    var osLogType: OSLogType {
        switch self {
        case .debug:    return .debug
        case .info:     return .info
        case .warning:  return .error
        case .error:    return .error
        case .default:  return .default
        }
    }
}
