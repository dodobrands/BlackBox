//
//  BlackBoxTests+StartEvent.swift
//  
//
//  Created by Aleksey Berezka on 13.10.2022.
//

import XCTest
@testable import BlackBox

extension BlackBoxTests {
    func test_startLog_message() {
        logStart("Test")
        XCTAssertEqual(logger.startEvent?.message, "Start: Test")
    }
    
    func test_startLog_rawMessage() {
        logStart("Test")
        XCTAssertEqual(logger.startEvent?.rawMessage, "Test")
    }
    
    func test_startLog_userInfo() {
        logStart("Test", userInfo: ["name": "Kenobi"])
        XCTAssertEqual(logger.startEvent?.userInfo as? [String: String], ["name": "Kenobi"])
    }
    
    func test_startLog_serviceInfo() {
        logStart("Test", serviceInfo: Lightsaber(color: "purple"))
        XCTAssertEqual(logger.startEvent?.serviceInfo as? Lightsaber, Lightsaber(color: "purple"))
    }
    
    func test_startLog_level() {
        logStart("Test", level: .warning)
        XCTAssertEqual(logger.startEvent?.level, .warning)
    }
    
    func test_startLog_defaultLevel() {
        logStart("Test")
        XCTAssertEqual(logger.startEvent?.level, .debug)
    }
    
    func test_startLog_category() {
        logStart("Test", category: "Analytics")
        XCTAssertEqual(logger.startEvent?.category, "Analytics")
    }
    
    func test_startLog_parentEvent() {
        let parentEvent = BlackBox.StartEvent("Test")
        logStart("Test 2", parentEvent: parentEvent)
        XCTAssertEqual(logger.startEvent?.parentEvent, parentEvent)
    }
    
    func test_startLog_fileID() {
        logStart("Test")
        XCTAssertEqual(logger.startEvent?.source.fileID.description, "BlackBoxTests/BlackBoxTests+StartEvent.swift")
    }
    
    func test_startLog_module() {
        logStart("Test")
        XCTAssertEqual(logger.startEvent?.source.module, "BlackBoxTests")
    }
    
    func test_startLog_filename() {
        logStart("Test")
        XCTAssertEqual(logger.startEvent?.source.filename, "BlackBoxTests+StartEvent")
    }
    
    func test_startLog_function() {
        logStart("Test")
        XCTAssertEqual(logger.startEvent?.source.function.description, "test_startLog_function()")
    }
    
    func test_startLog_line() {
        logStart("Test")
        XCTAssertEqual(logger.startEvent?.source.line, 74)
    }
}
