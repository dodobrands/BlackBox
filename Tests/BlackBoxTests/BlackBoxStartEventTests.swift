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
        waitForLog { BlackBox.logStart(event) }
        XCTAssertEqual(logger.startEvent, event)
    }
    func test_message() {
        waitForLog { let _ = BlackBox.logStart("Test") }
        XCTAssertEqual(logger.startEvent?.message, "Start: Test")
    }
    
    func test_rawMessage() {
        waitForLog { let _ = BlackBox.logStart("Test") }
        XCTAssertEqual(logger.startEvent?.rawMessage.description, "Test".description)
    }
    
    func test_userInfo() {
        waitForLog { let _ = BlackBox.logStart("Test", userInfo: ["name": "Kenobi"]) }
        XCTAssertEqual(logger.startEvent?.userInfo as? [String: String], ["name": "Kenobi"])
    }
    
    func test_serviceInfo() {
        waitForLog { let _ = BlackBox.logStart("Test", serviceInfo: Lightsaber(color: "purple")) }
        XCTAssertEqual(logger.startEvent?.serviceInfo as? Lightsaber, Lightsaber(color: "purple"))
    }
    
    func test_level() {
        waitForLog { let _ = BlackBox.logStart("Test", level: .warning) }
        XCTAssertEqual(logger.startEvent?.level, .warning)
    }
    
    func test_defaultLevel() {
        waitForLog { let _ = BlackBox.logStart("Test") }
        XCTAssertEqual(logger.startEvent?.level, .debug)
    }
    
    func test_category() {
        waitForLog { let _ = BlackBox.logStart("Test", category: "Analytics") }
        XCTAssertEqual(logger.startEvent?.category, "Analytics")
    }
    
    func test_parentEvent() {
        let parentEvent = BlackBox.StartEvent("Test")
        waitForLog { let _ = BlackBox.logStart("Test 2", parentEvent: parentEvent) }
        XCTAssertEqual(logger.startEvent?.parentEvent, parentEvent)
    }
    
    func test_fileID() {
        waitForLog { let _ = BlackBox.logStart("Test") }
        XCTAssertEqual(logger.startEvent?.source.fileID.description, "BlackBoxTests/BlackBoxStartEventTests.swift")
    }
    
    func test_module() {
        waitForLog { let _ = BlackBox.logStart("Test") }
        XCTAssertEqual(logger.startEvent?.source.module, "BlackBoxTests")
    }
    
    func test_filename() {
        waitForLog { let _ = BlackBox.logStart("Test") }
        XCTAssertEqual(logger.startEvent?.source.filename, "BlackBoxStartEventTests")
    }
    
    func test_function() {
        waitForLog { let _ = BlackBox.logStart("Test") }
        XCTAssertEqual(logger.startEvent?.source.function.description, "test_function()")
    }
    
    func test_line() {
        waitForLog { let _ = BlackBox.logStart("Test") }
        XCTAssertEqual(logger.startEvent?.source.line, 79)
    }
}
