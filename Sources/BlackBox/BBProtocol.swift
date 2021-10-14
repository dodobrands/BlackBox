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
        serviceInfo: BBServiceInfo?,
        fileID: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    )
    
    func log(
        _ message: String,
        userInfo: BBUserInfo?,
        serviceInfo: BBServiceInfo?,
        logLevel: BBLogLevel,
        fileID: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    )
    
    // MARK: - Trace
    func logStart(
        _ message: String,
        userInfo: BBUserInfo?,
        serviceInfo: BBServiceInfo?,
        logLevel: BBLogLevel,
        fileID: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    ) -> BlackBox.StartEvent
    
    func logStart(
        _ event: BlackBox.StartEvent
    )
    
    func logEnd(
        _ startEvent: BlackBox.StartEvent,
        alternateMessage: String?,
        userInfo: BBUserInfo?,
        serviceInfo: BBServiceInfo?,
        fileID: StaticString,
        category: String?,
        function: StaticString,
        line: UInt
    )
}
