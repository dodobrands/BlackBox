//
//  OSSignpostLogger.swift
//  BlackBox
//
//  Created by Алексей Берёзка on 27.08.2020.
//  Copyright © 2020 Dodo Pizza Engineering. All rights reserved.
//

import Foundation
import os

@available(iOS 12.0, *)
extension BlackBox {
    public class OSSignpostLogger: BBLoggerProtocol {
        public init(){}
        
        public func log(_ error: Error,
                        logLevel: BBLogLevel,
                        file: StaticString,
                        category: String?,
                        function: StaticString,
                        line: UInt) {
            return
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
            guard let signpostType = eventType?.osSignpostType else { return }
            
            log(message,
                logger: OSLog(file: file, category: category),
                function: function,
                signpostType: signpostType,
                signpostId: eventId.map { OSSignpostID($0) })
        }
    }
}

@available(iOS 12.0, *)
extension BlackBox.OSSignpostLogger {
    private func log(_ message: String,
                     logger: OSLog,
                     function: StaticString,
                     signpostType: OSSignpostType,
                     signpostId: OSSignpostID?) {
        let name: StaticString = function
        
        os_signpost(signpostType,
                    log: logger,
                    name: name,
                    signpostID: signpostId ?? .exclusive,
                    "%{public}@", message)
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
