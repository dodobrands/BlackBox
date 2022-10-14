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

class OSLoggerTests: BlackBoxTests {
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
        log("Hello there")
        
        let expectedResult = """
Hello there

[Source]:
OSLoggerTests:35
test_genericEvent_message()

[User Info]:
nil
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)
    }
    
    func test_genericEvent_userInfo() {
        log(
            "Hello there",
            userInfo: ["response": "General Kenobi"]
        )
        
        let expectedResult = """
Hello there

[Source]:
OSLoggerTests:51
test_genericEvent_userInfo()

[User Info]:
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
        log(
            "Hello there",
            userInfo: ["response": Response(value: "General Kenobi")]
        )
        
        let expectedResult = """
Hello there

[Source]:
OSLoggerTests:75
test_genericEvent_userInfo_nonCodable()

[User Info]:
["response": BlackBoxTests.OSLoggerTests.Response(value: "General Kenobi")]
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)
    }
    
    func test_genericEvent_invalidLevels() {
        createOSLogger(levels: [.error])

        let logLevels: [BBLogLevel] = [.debug, .info, .warning]
        
        logLevels.forEach { level in
            log("Hello There", level: level, isInverted: true)
        }
        
        XCTAssertNil(osLogger.data)
    }
    
    func test_genericEvent_validLevel() {
        createOSLogger(levels: [.error])
        
        log("Hello There", level: .error)
        XCTAssertNotNil(osLogger.data)
    }
    
    func test_genericEvent_level_debugMapsToDefault() {
        log("Hello There", level: .debug)
        XCTAssertEqual(osLogger.data?.logType.rawValue, OSLogType.default.rawValue)
    }
    
    func test_genericEvent_level_infoMapsToInfo() {
        log("Hello There", level: .info)
        XCTAssertEqual(osLogger.data?.logType.rawValue, OSLogType.info.rawValue)
    }
    
    func test_genericEvent_level_warningMapsToError() {
        log("Hello There", level: .warning)
        XCTAssertEqual(osLogger.data?.logType.rawValue, OSLogType.error.rawValue)
    }
    
    func test_genericEvent_level_errorMapsToFault() {
        log("Hello There", level: .error)
        XCTAssertEqual(osLogger.data?.logType.rawValue, OSLogType.fault.rawValue)
    }
    
    func test_genericEvent_subsystem() {
        log("Hello There")
        XCTAssertEqual(osLogger.data?.subsystem, "BlackBoxTests")
    }
    
    func test_genericEvent_categoryProvided() {
        log("Hello There", category: "Analytics")
        XCTAssertEqual(osLogger.data?.category, "Analytics")
    }
    
    func test_genericEvent_categoryNotProvided() {
        log("Hello There")
        XCTAssertEqual(osLogger.data?.category, "")
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
