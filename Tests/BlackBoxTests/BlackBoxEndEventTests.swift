//
//  BlackBoxEndEventTests.swift
//  
//
//  Created by Aleksey Berezka on 13.10.2022.
//

import XCTest
@testable import BlackBox

class BlackBoxEndEventTests: BlackBoxTestCase {
    func test_endEvent_startEvent() {
        let event = BlackBox.StartEvent("Test")
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.startEvent, event)
    }
    func test_message() {
        let event = BlackBox.StartEvent("Test")
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.message, "End: Test")
    }
    
    func test_rawMessage() {
        let event = BlackBox.StartEvent("Test")
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.rawMessage, "Test")
    }
    
    func test_userInfo() {
        let event = BlackBox.StartEvent("Test")
        waitForLog { BlackBox.logEnd(event, userInfo: ["name": "Kenobi"]) }
        XCTAssertEqual(logger.endEvent?.userInfo as? [String: String], ["name": "Kenobi"])
    }
    
    func test_serviceInfo() {
        let event = BlackBox.StartEvent("Test")
        waitForLog { BlackBox.logEnd(event, serviceInfo: Lightsaber(color: "purple")) }
        XCTAssertEqual(logger.endEvent?.serviceInfo as? Lightsaber, Lightsaber(color: "purple"))
    }
    
    func test_level() {
        let event = BlackBox.StartEvent("Test", level: .warning)
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.level, .warning)
    }
    
    func test_defaultLevel() {
        let event = BlackBox.StartEvent("Test")
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.level, .debug)
    }
    
    func test_category() {
        let event = BlackBox.StartEvent("Test")
        waitForLog { BlackBox.logEnd(event, category: "Analytics") }
        XCTAssertEqual(logger.endEvent?.category, "Analytics")
    }
    
    func test_parentEvent() {
        let event = BlackBox.StartEvent("Test")
        let parentEvent = BlackBox.GenericEvent("Test")
        waitForLog { BlackBox.logEnd(event, parentEvent: parentEvent) }
        XCTAssertEqual(logger.endEvent?.parentEvent, parentEvent)
    }
    
    func test_fileID() {
        let event = BlackBox.StartEvent("Test")
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.source.fileID.description, "BlackBoxTests/BlackBoxEndEventTests.swift")
    }
    
    func test_module() {
        let event = BlackBox.StartEvent("Test")
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.source.module, "BlackBoxTests")
    }
    
    func test_filename() {
        let event = BlackBox.StartEvent("Test")
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.source.filename, "BlackBoxEndEventTests")
    }
    
    func test_function() {
        let event = BlackBox.StartEvent("Test")
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.source.function.description, "test_function()")
    }
    
    func test_line() {
        let event = BlackBox.StartEvent("Test")
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.source.line, 92)
    }
}
