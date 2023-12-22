//
//  PublicApiTests.swift
//  
//
//  Created by Aleksey Berezka on 21.12.2023.
//

import Foundation
import XCTest
import BlackBox

/// 
/// Anything that's public should be included in this test. Simple call is enough.
/// 
/// If you're marking something already existing as public — add it here.
/// If you're adding something new and it's public — add it here.
/// 
/// If you're testing methods — make sure to include all possible arguments
/// For optional argument provide nil, so that it won't become required without notice
/// For collections provide any value that's suitable, so that test will fail if expected type changes 
/// 
/// If you're testing data — make sure to include all possible constants/variables of a struct/class/etc
/// Check that variables are modifiable — so that test will fail if it's converted to constant
/// 
/// If any of this tests won't compile — you've broke backwards compatibility.
/// There are two options:
///     1. Restore backwards compatibility, so that api call remains the same
///     2. Go forward, but make sure this changes are released to public in a major release, not minor or patch.
///     

class PublicApiTests: XCTestCase {
    enum Error: Swift.Error, BBLogLevelProvider {
        case someError
        
        var level: BBLogLevel { .debug }
    }
    
    func test_BlackBox() {
        let defaultLoggers = BlackBox.defaultLoggers
        let instance = BlackBox(loggers: defaultLoggers)
        BlackBox.instance = instance
        
        BlackBox.log(
            "Message",
            userInfo: nil,
            serviceInfo: nil,
            level: .debug,
            category: nil,
            parentEvent: nil,
            fileID: #fileID,
            function: #function,
            line: #line
        )
        
        BlackBox.log(
            Error.someError,
            serviceInfo: nil,
            category: nil,
            parentEvent: nil,
            fileID: #fileID,
            function: #function,
            line: #line
        )
        
        let startEvent = BlackBox.logStart(
            "Message",
            userInfo: nil,
            serviceInfo: nil,
            level: .debug,
            category: nil,
            parentEvent: nil,
            fileID: #fileID,
            function: #function,
            line: #line
        )
        
        BlackBox.logStart(startEvent)
        
        BlackBox.logEnd(
            startEvent,
            message: nil,
            userInfo: nil,
            serviceInfo: nil,
            category: nil,
            fileID: #fileID,
            function: #function,
            line: #line
        )
    }
    
    func test_events() {
        let source = BlackBox.GenericEvent.Source(
            fileID: #fileID,
            function: #function,
            line: #line
        )
        
        let _ = source.fileID
        let _ = source.module
        let _ = source.filename
        let _ = source.function
        let _ = source.line
        
        let genericEvent = BlackBox.GenericEvent(
            id: UUID(), 
            timestamp: Date(),
            "Message",
            userInfo: nil,
            serviceInfo: nil,
            level: .debug,
            category: nil,
            parentEvent: nil,
            source: source
        )
        
        let _ = genericEvent.id
        let _ = genericEvent.timestamp
        let _ = genericEvent.message
        let _ = genericEvent.userInfo
        let _ = genericEvent.serviceInfo
        let _ = genericEvent.level
        let _ = genericEvent.category
        let _ = genericEvent.parentEvent
        let _ = genericEvent.source
        let _ = genericEvent.formattedDuration(using: MeasurementFormatter())
        let _ = genericEvent.messageWithFormattedDuration(using: MeasurementFormatter())
        
        let _ = BlackBox.GenericEvent(
            id: UUID(), 
            timestamp: Date(),
            "Message",
            userInfo: nil,
            serviceInfo: nil,
            level: .debug,
            category: nil,
            parentEvent: nil,
            fileID: #fileID,
            function: #function,
            line: #line
        )
        
        let errorEvent = BlackBox.ErrorEvent(
            id: UUID(), 
            timestamp: Date(),
            error: Error.someError, 
            serviceInfo: nil, 
            category: nil,
            parentEvent: nil,
            source: source
        )
        let _ = errorEvent.error
        
        let _ = BlackBox.ErrorEvent(
            id: UUID(), 
            timestamp: Date(),
            error: Error.someError, 
            serviceInfo: nil, 
            category: nil,
            parentEvent: nil,
            fileID: #fileID,
            function: #function,
            line: #line
        )
        
        let startEvent = BlackBox.StartEvent(
            id: UUID(),
            timestamp: Date(),
            "Message", 
            userInfo: nil,
            serviceInfo: nil,
            level: .debug,
            category: nil,
            parentEvent: nil,
            source: source
        )
        let _ = startEvent.rawMessage
        
        let _ = BlackBox.StartEvent(
            id: UUID(),
            timestamp: Date(),
            "Message", 
            userInfo: nil,
            serviceInfo: nil,
            level: .debug,
            category: nil,
            parentEvent: nil,
            fileID: #fileID,
            function: #function,
            line: #line
        )
        
        let endEvent = BlackBox.EndEvent(
            id: UUID(), 
            timestamp: Date(), 
            message: nil, 
            startEvent: startEvent, 
            userInfo: nil,
            serviceInfo: nil,
            level: .debug,
            category: nil, 
            source: source
        )
        let _ = endEvent.rawMessage
        let _ = endEvent.startEvent
        let _ = endEvent.duration
        
        let _ = BlackBox.EndEvent(
            id: UUID(), 
            timestamp: Date(), 
            message: nil, 
            startEvent: startEvent, 
            userInfo: nil,
            serviceInfo: nil,
            level: .debug,
            category: nil,
            fileID: #fileID,
            function: #function,
            line: #line
        )
    }
    
    func test_levels() {
        let _ = BBLogLevel.debug
        let _ = BBLogLevel.info
        let _ = BBLogLevel.warning
        let _ = BBLogLevel.error
        let _ = BBLogLevel.allCases
        let _:[BBLogLevel] = .allCases
        
        let _ = BBLogLevel.debug.icon
    }
    
    func test_loggerProtocol() {
        struct Logger: BBLoggerProtocol {
            func log(_ event: BlackBox.GenericEvent) {}
            func log(_ event: BlackBox.ErrorEvent) { }
            func logStart(_ event: BlackBox.StartEvent) { }
            func logEnd(_ event: BlackBox.EndEvent) { }
        }
    }
    
    func test_osLogger() {
        let logger = OSLogger(
            levels: [.debug],
            logFormat: BBLogFormat()
        )
        
        let genericEvent = BlackBox.GenericEvent("Message")
        let errorEvent = BlackBox.ErrorEvent(error: Error.someError)
        let startEvent = BlackBox.StartEvent("Message")
        let endEvent: BlackBox.EndEvent = BlackBox.EndEvent(startEvent: startEvent)
        
        logger.log(genericEvent)
        logger.log(errorEvent)
        logger.logStart(startEvent)
        logger.logEnd(endEvent)
    }
    
    func test_osSignpostLogger() {
        let logger = OSSignpostLogger(levels: [.debug])
        
        let genericEvent = BlackBox.GenericEvent("Message")
        let errorEvent = BlackBox.ErrorEvent(error: Error.someError)
        let startEvent = BlackBox.StartEvent("Message")
        let endEvent: BlackBox.EndEvent = BlackBox.EndEvent(startEvent: startEvent)
        
        logger.log(genericEvent)
        logger.log(errorEvent)
        logger.logStart(startEvent)
        logger.logEnd(endEvent)
    }
    
    func test_fsLogger() {
        let logger = FSLogger(
            path: URL(fileURLWithPath: "~/Caches"),
            name: "FSLogger",
            levels: [.debug],
            queue: .global(),
            logFormat: BBLogFormat()
        )
        
        let genericEvent = BlackBox.GenericEvent("Message")
        let errorEvent = BlackBox.ErrorEvent(error: Error.someError)
        let startEvent = BlackBox.StartEvent("Message")
        let endEvent: BlackBox.EndEvent = BlackBox.EndEvent(startEvent: startEvent)
        
        logger.log(genericEvent)
        logger.log(errorEvent)
        logger.logStart(startEvent)
        logger.logEnd(endEvent)
    }
    
    func test_format() {
        let format = BBLogFormat(
            userInfoFormatOptions: [.fragmentsAllowed],
            sourceSectionInline: false,
            showLevelIcon: [.debug],
            measurementFormatter: MeasurementFormatter(),
            addEmptyLinePrefix: false
        )
        
        let _ = format.userInfoFormatOptions
        let _ = format.sourceSectionInline
        let _ = format.showLevelIcon
        let _ = format.measurementFormatter
        let _ = format.addEmptyLinePrefix
    }
}
