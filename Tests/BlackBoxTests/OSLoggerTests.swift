//
//  OSLoggerTests.swift
//  
//
//  Created by Aleksey Berezka on 13.10.2022.
//

import Foundation
import XCTest
@testable import BlackBox
import os

class OSLoggerTests: BlackBoxTestCase {
    var osLogger: OSLoggerMock!
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        createOSLogger(levels: .allCases)
    }
    
    override func tearDownWithError() throws {
        logger = nil
        osLogger = nil
        try super.tearDownWithError()
    }
    
    private func createOSLogger(levels: [BBLogLevel]) {
        osLogger = .init(levels: levels)
        BlackBox.instance = .init(loggers: [osLogger])
        
        logger = osLogger
    }
    
    func test_genericEvent_message() {
        waitForLog { BlackBox.log("Hello there") }
        
        
        let expectedResult = """

Hello there

[Source]
OSLoggerTests:35
test_genericEvent_message()
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)
    }
    
    func test_genericEvent_userInfo() {
        waitForLog { BlackBox.log("Hello there", userInfo: ["response": "General Kenobi"]) }
        
        let expectedResult = """

Hello there

[Source]
OSLoggerTests:50
test_genericEvent_userInfo()

[User Info]
{
  "response" : "General Kenobi"
}
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)
    }
    
    struct Response {
        let value: String
    }
    func test_genericEvent_userInfo_nonCodable() {
        waitForLog { BlackBox.log("Hello there", userInfo: ["response": Response(value: "General Kenobi")]) }
        
        let expectedResult = """

Hello there

[Source]
OSLoggerTests:72
test_genericEvent_userInfo_nonCodable()

[User Info]
["response": BlackBoxTests.OSLoggerTests.Response(value: "General Kenobi")]
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)
    }
    
    func test_genericEvent_invalidLevels() {
        createOSLogger(levels: [.error])

        let logLevels: [BBLogLevel] = [.debug, .info, .warning]
        
        logLevels.forEach { level in
            waitForLog(isInverted: true) { BlackBox.log("Hello There", level: level) }
        }
        
        XCTAssertNil(osLogger.data)
    }
    
    func test_genericEvent_validLevel() {
        createOSLogger(levels: [.error])
        
        waitForLog { BlackBox.log("Hello There", level: .error) }
        let expectedResult = """

Hello There

[Source]
OSLoggerTests:103
test_genericEvent_validLevel()
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)
    }
    
    func test_genericEvent_level_debugMapsToDefault() {
        waitForLog { BlackBox.log("Hello There", level: .debug) }
        XCTAssertEqual(osLogger.data?.logType.rawValue, OSLogType.default.rawValue)
    }
    
    func test_genericEvent_level_infoMapsToInfo() {
        waitForLog { BlackBox.log("Hello There", level: .info) }
        XCTAssertEqual(osLogger.data?.logType.rawValue, OSLogType.info.rawValue)
    }
    
    func test_genericEvent_level_warningMapsToError() {
        waitForLog { BlackBox.log("Hello There", level: .warning) }
        XCTAssertEqual(osLogger.data?.logType.rawValue, OSLogType.error.rawValue)
    }
    
    func test_genericEvent_level_errorMapsToFault() {
        waitForLog { BlackBox.log("Hello There", level: .error) }
        XCTAssertEqual(osLogger.data?.logType.rawValue, OSLogType.fault.rawValue)
    }
    
    func test_genericEvent_subsystem() {
        waitForLog { BlackBox.log("Hello There") }
        XCTAssertEqual(osLogger.data?.subsystem, "BlackBoxTests")
    }
    
    func test_genericEvent_categoryProvided() {
        waitForLog { BlackBox.log("Hello There", category: "Analytics") }
        XCTAssertEqual(osLogger.data?.category, "Analytics")
    }
    
    func test_genericEvent_categoryNotProvided() {
        waitForLog { BlackBox.log("Hello There") }
        XCTAssertEqual(osLogger.data?.category, "")
    }
    
    enum Error: Swift.Error {
        case someError
    }
    
    func test_errorEvent() {
        waitForLog { BlackBox.log(Error.someError) }
        let expectedResult = """

OSLoggerTests.Error.someError

[Source]
OSLoggerTests:155
test_errorEvent()
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)
    }
    
    func test_startEvent() {
        waitForLog { let _ = BlackBox.logStart("Process") }
        
        let expectedResult = """

Start: Process

[Source]
OSLoggerTests:168
test_startEvent()
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)
    }
    
    func test_endEvent() {
        waitForLog { 
            let date = Date()
            let startEvent = BlackBox.StartEvent(
                timestamp: date, 
                "Process"
            )
            
            let endEvent = BlackBox.EndEvent(
                timestamp: date.addingTimeInterval(1),
                startEvent: startEvent
            )
            
            BlackBox.logEnd(endEvent) 
        }
        let expectedResult = """

End: Process, duration: 1 sec

[Source]
OSLoggerTests:189
test_endEvent()
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)
    }
}

class OSLoggerMock: OSLogger, TestableLoggerProtocol {
    var expectation: XCTestExpectation?
    var genericEvent: BlackBox.GenericEvent?
    var errorEvent: BlackBox.ErrorEvent?
    var startEvent: BlackBox.StartEvent?
    var endEvent: BlackBox.EndEvent?
    
    var data: LogData?
    override func osLog(_ data: LogData) {
        self.data = data
        expectation?.fulfill()
        super.osLog(data)
    }
}
