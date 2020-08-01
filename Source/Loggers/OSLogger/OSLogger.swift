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
                        file: StaticString,
                        function: StaticString,
                        line: UInt) {
            let message = String(reflecting: error)
            log(message,
                userInfo: nil,
                logger: OSLog.logger(for: file),
                file: file,
                function: function,
                logType: .error,
                signpostType: nil)
        }
        
        public func log(_ message: String,
                        userInfo: CustomDebugStringConvertible?,
                        logLevel: BBLogLevel,
                        eventType: BBEventType?,
                        file: StaticString,
                        function: StaticString,
                        line: UInt) {
            log(message,
                userInfo: userInfo,
                logger: OSLog.logger(for: file),
                file: file,
                function: function,
                logType: logLevel.osLogType,
                signpostType: eventType?.osSignpostType)
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
                     logType: OSLogType,
                     signpostType: OSSignpostType?) {
        let userInfo = userInfo?.bbLogDescription ?? "nil"
        let message = message + "\n\n" + "[User Info]:" + "\n" + userInfo
        
        os_log(logType,
               log: logger,
               "%{public}@\n%{public}@", function.description, message)
        
        if let signpostType = signpostType {
            let name: StaticString = function
            
            os_signpost(signpostType,
                        log: logger,
                        name: name,
                        "%{public}@", message)
        }
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

@available(iOS 12.0, *)
extension BBEventType {
    var osSignpostType: OSSignpostType {
        switch self {
        case .begin:
            return .begin
        case .end:
            return .end
        }
    }
}
