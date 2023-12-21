//
//  OSSignpostLoggerTests.swift
//  
//
//  Created by Aleksey Berezka on 26.10.2022.
//

@testable import BlackBox
@testable import ExampleModule
import Foundation
import XCTest
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
        let _ = BlackBox.logStart("Hello there")
        let expectedResult = "Start: Hello there"
        XCTAssertEqual(osSignpostLogger.data?.message, expectedResult)
    }
    
    
    func test_startEvent_invalidLevels() {
        createOSSignpostLogger(levels: [.error])

        let logLevels: [BBLogLevel] = [.debug, .info, .warning]
        
        logLevels.forEach { level in
            let _ = BlackBox.logStart("Hello There", level: level)
        }
        
        XCTAssertNil(osSignpostLogger.data)
    }
    
    func test_startEvent_validLevel() {
        createOSSignpostLogger(levels: [.error])
        
        let _ = BlackBox.logStart("Hello There", level: .error)
        XCTAssertNotNil(osSignpostLogger.data)
    }
    
    func test_genericEvent_signpostType_event() {
        BlackBox.log("Hello There", level: .debug)
        XCTAssertEqual(osSignpostLogger.data?.signpostType, OSSignpostType.event)
    }
    
    func test_errorEvent_signpostType_event() {
        enum Error: Swift.Error {
            case someError
        }
        BlackBox.log(Error.someError)
        XCTAssertEqual(osSignpostLogger.data?.signpostType, OSSignpostType.event)
    }
    
    func test_startEvent_signpostType_begin() {
        let _ = BlackBox.logStart("Process")
        XCTAssertEqual(osSignpostLogger.data?.signpostType, OSSignpostType.begin)
    }
    
    func test_endEvent_signpostType_begin() {
        BlackBox.logEnd(BlackBox.StartEvent("Process"))
        XCTAssertEqual(osSignpostLogger.data?.signpostType, OSSignpostType.end)
    }
    
    func test_startEvent_subsystem() {
        let _ = BlackBox.logStart("Hello There")
        XCTAssertEqual(osSignpostLogger.data?.subsystem, "BlackBoxTests")
    }
    
    func test_startEvent_categoryProvided() {
        let _ = BlackBox.logStart("Hello There", category: "Analytics")
        XCTAssertEqual(osSignpostLogger.data?.category, "Analytics")
    }
    
    func test_startEvent_categoryNotProvided() {
        let _ = BlackBox.logStart("Hello There")
        XCTAssertEqual(osSignpostLogger.data?.category, "OSSignpostLoggerTests")
    }
    
    func test_errorEvent() {
        enum Error: Swift.Error {
            case someError
        }
        BlackBox.log(Error.someError)
        XCTAssertNotNil(osSignpostLogger.data)
    }
    
    func test_startEvent_endEvent_shareSameId() throws {
        let startLog = BlackBox.logStart("Hello There")
        let startLogData = try XCTUnwrap(osSignpostLogger.data)
        
        BlackBox.logEnd(startLog)
        let endLogData = try XCTUnwrap(osSignpostLogger.data)
        
        XCTAssertEqual(startLogData.signpostId.rawValue, endLogData.signpostId.rawValue)
    }
    
    func test_startEvent_endEvent_shareSameSubsystem() throws {
        let startLog = BlackBox.logStart("Hello There")
        let startLogData = try XCTUnwrap(osSignpostLogger.data)
        
        ExampleModule.ExampleService().finishLog(startLog)
        let endLogData = try XCTUnwrap(osSignpostLogger.data)
        
        XCTAssertEqual(startLogData.subsystem, endLogData.subsystem)
    }
    
    func test_startEvent_endEvent_shareSameCategory() throws {
        let startLog = BlackBox.logStart("Hello There")
        let startLogData = try XCTUnwrap(osSignpostLogger.data)
        
        ExampleModule.ExampleService().finishLog(startLog)
        let endLogData = try XCTUnwrap(osSignpostLogger.data)
        
        XCTAssertEqual(startLogData.category, endLogData.category)
    }
    
    func test_startEvent_endEvent_shareSameName() throws {
        let startLog = BlackBox.logStart("Hello There")
        let startLogData = try XCTUnwrap(osSignpostLogger.data)
        
        ExampleModule.ExampleService().finishLog(startLog)
        let endLogData = try XCTUnwrap(osSignpostLogger.data)
        
        XCTAssertEqual(startLogData.name.description, endLogData.name.description)
    }
}

class OSSignpostLoggerMock: OSSignpostLogger {
    
    var data: LogData?
    override func signpostLog(_ data: OSSignpostLogger.LogData) {
        self.data = data
        super.signpostLog(data)
    }
}
