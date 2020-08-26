//
//  BBProtocol.swift
//  DFoundation
//
//  Created by Алексей Берёзка on 31.07.2020.
//

import Foundation

public protocol BBProtocol {
    func log(_ error: Error,
             file: StaticString,
             function: StaticString,
             line: UInt)
    
    func log(_ message: String,
             userInfo: CustomDebugStringConvertible?,
             logLevel: BBLogLevel,
             eventType: BBEventType?,
             eventId: UInt64?,
             file: StaticString,
             function: StaticString,
             line: UInt)
}
