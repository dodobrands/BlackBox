//
//  OSSignpostLoggerTests.swift
//  
//
//  Created by Aleksey Berezka on 26.10.2022.
//

import Foundation
import XCTest
@testable import BlackBox
import os

class OSSignpostLoggerTests: BlackBoxTestCase {
    var osSignpostLogger: OSSignpostLoggerMock!
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        createOSSignpostLogger(levels: .allCases)
    }
    
    override func tearDownWithError() throws {
        logger = nil
        osSignpostLogger = nil
        try super.tearDownWithError()
    }
    
    private func createOSSignpostLogger(levels: [BBLogLevel]) {
        osSignpostLogger = .init(levels: levels)
        BlackBox.instance = .init(loggers: [osSignpostLogger])
        
        logger = osSignpostLogger
    }
    
    func test_startEvent_message() {
        waitForLog { let _ = BlackBox.logStart("Hello there") }
        let expectedResult = "Start: Hello there"
        XCTAssertEqual(osSignpostLogger.data?.message, expectedResult)
    }
    
    
    func test_startEvent_invalidLevels() {
        createOSSignpostLogger(levels: [.error])

        let logLevels: [BBLogLevel] = [.debug, .info, .warning]
        
        logLevels.forEach { level in
            waitForLog(isInverted: true) { let _ = BlackBox.logStart("Hello There", level: level) }
        }
        
        XCTAssertNil(osSignpostLogger.data)
    }
    
    func test_startEvent_validLevel() {
        createOSSignpostLogger(levels: [.error])
        
        waitForLog { let _ = BlackBox.logStart("Hello There", level: .error) }
        XCTAssertNotNil(osSignpostLogger.data)
    }
    
    func test_genericEvent_signpostType_event() {
        waitForLog { BlackBox.log("Hello There", level: .debug) }
        XCTAssertEqual(osSignpostLogger.data?.signpostType, OSSignpostType.event)
    }
    
    func test_errorEvent_signpostType_event() {
        enum Error: Swift.Error {
            case someError
        }
        waitForLog { BlackBox.log(Error.someError) }
        XCTAssertEqual(osSignpostLogger.data?.signpostType, OSSignpostType.event)
    }
    
    func test_startEvent_signpostType_begin() {
        waitForLog { let _ = BlackBox.logStart("Process") }
        XCTAssertEqual(osSignpostLogger.data?.signpostType, OSSignpostType.begin)
    }
    
    func test_endEvent_signpostType_begin() {
        waitForLog { BlackBox.logEnd(BlackBox.StartEvent("Process")) }
        XCTAssertEqual(osSignpostLogger.data?.signpostType, OSSignpostType.end)
    }
    
    func test_startEvent_subsystem() {
        waitForLog { let _ = BlackBox.logStart("Hello There") }
        XCTAssertEqual(osSignpostLogger.data?.subsystem, "BlackBoxTests")
    }
    
    func test_startEvent_categoryProvided() {
        waitForLog { let _ = BlackBox.logStart("Hello There", category: "Analytics") }
        XCTAssertEqual(osSignpostLogger.data?.category, "Analytics")
    }
    
    func test_startEvent_categoryNotProvided() {
        waitForLog { let _ = BlackBox.logStart("Hello There") }
        XCTAssertEqual(osSignpostLogger.data?.category, "OSSignpostLoggerTests")
    }
    
    func test_errorEvent() {
        enum Error: Swift.Error {
            case someError
        }
        waitForLog { BlackBox.log(Error.someError) }
        XCTAssertNotNil(osSignpostLogger.data)
    }
    
    func test_startEvent_endEvent_shareSameId() throws {
        var log: BlackBox.StartEvent?
        waitForLog { log = BlackBox.logStart("Hello There") }
        
        let startLog = try XCTUnwrap(log)
        let startLogData = try XCTUnwrap(osSignpostLogger.data)
        
        waitForLog { BlackBox.logEnd(startLog) }
        let endLogData = try XCTUnwrap(osSignpostLogger.data)
        
        XCTAssertEqual(startLogData.signpostId.rawValue, endLogData.signpostId.rawValue)
    }
}

class OSSignpostLoggerMock: OSSignpostLogger, TestableLoggerProtocol {
    var expectation: XCTestExpectation?
    var genericEvent: BlackBox.GenericEvent?
    var errorEvent: BlackBox.ErrorEvent?
    var startEvent: BlackBox.StartEvent?
    var endEvent: BlackBox.EndEvent?
    
    var data: LogData?
    override func signpostLog(_ data: OSSignpostLogger.LogData) {
        self.data = data
        expectation?.fulfill()
        super.signpostLog(data)
    }
}
