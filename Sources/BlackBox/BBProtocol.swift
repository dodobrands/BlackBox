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
    ) -> BlackBox.Event
    
    func logStart(
        _ entry: BlackBox.Event
    )
    
    func logEnd(
        _ startEntry: BlackBox.Event,
        userInfo: CustomDebugStringConvertible?,
        file: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    )
}
