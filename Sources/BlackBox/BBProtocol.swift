//
//  BBProtocol.swift
//  DFoundation
//
//  Created by Алексей Берёзка on 31.07.2020.
//

import Foundation

public protocol BBProtocol {
    /// Logs plain message
    /// - Parameters:
    ///   - message: Message to log
    ///   - userInfo: Additional info you'd like to see alongside log
    ///   - serviceInfo: to be deleted
    ///   - logLevel: level of log
    ///   - category: Category of log. E.g. View Lifecycle.
    ///   - parentEvent: Parent log of current log. May be useful for traces.
    ///   - fileID: The fileID where the logs occurs. Containts module name and filename. The default is the fileID of the function where you call log.
    ///   - function: The function where the logs occurs. The default is the function name from where you call log.
    ///   - line: The line where the logs occurs. The default is the line in function from where you call log.
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
    
    /// Logs error messages
    /// - Parameters:
    ///   - error: Error to log
    ///   - serviceInfo: to be deleted
    ///   - category: Category of log. E.g. View Lifecycle.
    ///   - parentEvent: Parent log of current log. May be useful for traces.
    ///   - fileID: The fileID where the logs occurs. Containts module name and filename. The default is the fileID of the function where you call log.
    ///   - function: The function where the logs occurs. The default is the function name from where you call log.
    ///   - line: The line where the logs occurs. The default is the line in function from where you call log.
    func log(
        _ error: Error,
        serviceInfo: BBServiceInfo?,
        category: String?,
        parentEvent: BlackBox.GenericEvent?,
        fileID: StaticString,
        function: StaticString,
        line: UInt
    )
    
    // MARK: - Trace
    /// Logs measurement start
    /// - Parameters:
    ///   - message: Measurement name
    ///   - userInfo: Additional info you'd like to see alongside log
    ///   - serviceInfo: to be deleted
    ///   - logLevel: level of log
    ///   - category: Category of log. E.g. View Lifecycle.
    ///   - parentEvent: Parent log of current log. May be useful for traces.
    ///   - fileID: The fileID where the logs occurs. Containts module name and filename. The default is the fileID of the function where you call log.
    ///   - function: The function where the logs occurs. The default is the function name from where you call log.
    ///   - line: The line where the logs occurs. The default is the line in function from where you call log.
    /// - Returns: Started measurement
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
    
    /// Logs measurement start
    /// - Parameter event: measurement start event
    func logStart(
        _ event: BlackBox.StartEvent
    )
    
    /// Logs measurement end
    /// - Parameters:
    ///   - startEvent: Measurement start event
    ///   - message: Alternate message to log instead of ``BlackBox.StartEvent`` message.
    ///   - userInfo: Additional info you'd like to see alongside log
    ///   - serviceInfo: to be deleted
    ///   - category: Category of log. E.g. View Lifecycle.
    ///   - parentEvent: Parent log of current log. May be useful for traces.
    ///   - fileID: The fileID where the logs occurs. Containts module name and filename. The default is the fileID of the function where you call log.
    ///   - function: The function where the logs occurs. The default is the function name from where you call log.
    ///   - line: The line where the logs occurs. The default is the line in function from where you call log.
    /// - Returns: Started measurement
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
