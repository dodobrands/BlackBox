//
//  BBLoggerProtocol.swift
//  DFoundation
//
//  Created by Алексей Берёзка on 27.02.2020.
//  Copyright © 2020 ru.dodopizza. All rights reserved.
//

import Foundation

public protocol BBLoggerProtocol {
    func log(_ error: Error,
             logLevel: BBLogLevel,
             file: StaticString,
             category: String?,
             function: StaticString,
             line: UInt)
    
    func log(_ message: String,
             userInfo: CustomDebugStringConvertible?,
             logLevel: BBLogLevel,
             eventType: BBEventType?,
             eventId: UInt64?,
             file: StaticString,
             category: String?,
             function: StaticString,
             line: UInt)
}

public enum BBLogLevel {
    case `default`, debug, info, warning, error
}

public enum BBEventType {
    case begin, end
}
