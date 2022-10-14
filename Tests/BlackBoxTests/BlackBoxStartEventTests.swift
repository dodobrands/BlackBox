//
//  BlackBoxStartEventTests.swift
//  
//
//  Created by Aleksey Berezka on 13.10.2022.
//

import XCTest
@testable import BlackBox

class BlackBoxStartEventTests: BlackBoxTestCase {
    func test_logStart_event() {
        let event = BlackBox.StartEvent("Test")
        logStart(event)
        XCTAssertEqual(logger.startEvent, event)
    }
    func test_message() {
        logStart("Test")
        XCTAssertEqual(logger.startEvent?.message, "Start: Test")
    }
    
    func test_rawMessage() {
        logStart("Test")
        XCTAssertEqual(logger.startEvent?.rawMessage, "Test")
    }
    
    func test_userInfo() {
        logStart("Test", userInfo: ["name": "Kenobi"])
        XCTAssertEqual(logger.startEvent?.userInfo as? [String: String], ["name": "Kenobi"])
    }
    
    func test_serviceInfo() {
        logStart("Test", serviceInfo: Lightsaber(color: "purple"))
        XCTAssertEqual(logger.startEvent?.serviceInfo as? Lightsaber, Lightsaber(color: "purple"))
    }
    
    func test_level() {
        logStart("Test", level: .warning)
        XCTAssertEqual(logger.startEvent?.level, .warning)
    }
    
    func test_defaultLevel() {
        logStart("Test")
        XCTAssertEqual(logger.startEvent?.level, .debug)
    }
    
    func test_category() {
        logStart("Test", category: "Analytics")
        XCTAssertEqual(logger.startEvent?.category, "Analytics")
    }
    
    func test_parentEvent() {
        let parentEvent = BlackBox.StartEvent("Test")
        logStart("Test 2", parentEvent: parentEvent)
        XCTAssertEqual(logger.startEvent?.parentEvent, parentEvent)
    }
    
    func test_fileID() {
        logStart("Test")
        XCTAssertEqual(logger.startEvent?.source.fileID.description, "BlackBoxTests/BlackBoxStartEventTests.swift")
    }
    
    func test_module() {
        logStart("Test")
        XCTAssertEqual(logger.startEvent?.source.module, "BlackBoxTests")
    }
    
    func test_filename() {
        logStart("Test")
        XCTAssertEqual(logger.startEvent?.source.filename, "BlackBoxStartEventTests")
    }
    
    func test_function() {
        logStart("Test")
        XCTAssertEqual(logger.startEvent?.source.function.description, "test_function()")
    }
    
    func test_line() {
        logStart("Test")
        XCTAssertEqual(logger.startEvent?.source.line, 79)
    }
}
