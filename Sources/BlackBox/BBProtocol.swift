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
        category: String?,
        parentEvent: BlackBox.GenericEvent?,
        fileID: StaticString,
        function: StaticString,
        line: UInt
    )
    
    func log(
        _ message: String,
        userInfo: BBUserInfo?,
        serviceInfo: BBServiceInfo?,
        logLevel: BBLogLevel,
        category: String?,
        parentEvent: BlackBox.GenericEvent?,
        fileID: StaticString,
        function: StaticString,
        line: UInt
    )
    
    // MARK: - Trace
    func logStart(
        _ message: String,
        userInfo: BBUserInfo?,
        serviceInfo: BBServiceInfo?,
        logLevel: BBLogLevel,
        category: String?,
        parentEvent: BlackBox.GenericEvent?,
        fileID: StaticString,
        function: StaticString,
        line: UInt
    ) -> BlackBox.StartEvent
    
    func logStart(
        _ event: BlackBox.StartEvent
    )
    
    func logEnd(
        _ startEvent: BlackBox.StartEvent,
        message: String?,
        userInfo: BBUserInfo?,
        serviceInfo: BBServiceInfo?,
        category: String?,
        parentEvent: BlackBox.GenericEvent?,
        fileID: StaticString,
        function: StaticString,
        line: UInt
    )
}
