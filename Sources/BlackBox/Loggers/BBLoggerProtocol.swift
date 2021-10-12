//
//  BBLoggerProtocol.swift
//  DFoundation
//
//  Created by Алексей Берёзка on 27.02.2020.
//  Copyright © 2020 ru.dodopizza. All rights reserved.
//

import Foundation

public protocol BBLoggerProtocol {
    func log(
        _ error: Error,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    )
    
    func log(
        _ message: String,
        userInfo: CustomDebugStringConvertible?,
        logLevel: BBLogLevel,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    )
    
    // MARK: - Trace
    func logStart(
        _ entry: BlackBox.LogEntry,
        userInfo: CustomDebugStringConvertible?,
        logLevel: BBLogLevel,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    )
    
    func logEnd(
        _ entry: BlackBox.LogEntry,
        userInfo: CustomDebugStringConvertible?,
        logLevel: BBLogLevel,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    )
}

public enum BBEventType {
    case start, end
    case event
}

extension BBEventType {
    var description: String {
        switch self {
        case .start:
            return "Event start"
        case .end:
            return "Event end"
        case .event:
            return "Event"
        }
    }
}
