//
//  BBProtocol.swift
//  DFoundation
//
//  Created by Алексей Берёзка on 31.07.2020.
//

import Foundation

public protocol BBProtocol {
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
        _ message: String,
        userInfo: CustomDebugStringConvertible?,
        logLevel: BBLogLevel,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) -> UInt64
    
    func logEnd(
        _ message: String,
        userInfo: CustomDebugStringConvertible?,
        logLevel: BBLogLevel,
        eventId: UInt64,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    )
    
    func logEnd(
        _ error: Error,
        eventId: UInt64,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    )
}
