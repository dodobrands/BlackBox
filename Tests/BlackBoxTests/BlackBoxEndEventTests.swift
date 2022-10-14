//
//  BlackBoxEndEventTests.swift
//  
//
//  Created by Aleksey Berezka on 13.10.2022.
//

import XCTest
@testable import BlackBox

class BlackBoxEndEventTests: BlackBoxTestCase {
    var event: BlackBox.StartEvent!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        event = BlackBox.StartEvent("Test")
    }
    
    func test_endEvent_startEvent() {
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.startEvent, event)
    }
    
    func test_message() {
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.message, "End: Test")
    }
    
    func test_rawMessage() {
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.rawMessage, "Test")
    }
    
    func test_userInfo() {
        waitForLog { BlackBox.logEnd(event, userInfo: ["name": "Kenobi"]) }
        XCTAssertEqual(logger.endEvent?.userInfo as? [String: String], ["name": "Kenobi"])
    }
    
    func test_serviceInfo() {
        waitForLog { BlackBox.logEnd(event, serviceInfo: Lightsaber(color: "purple")) }
        XCTAssertEqual(logger.endEvent?.serviceInfo as? Lightsaber, Lightsaber(color: "purple"))
    }
    
    func test_levelComeFromStartEvent() {
        event = BlackBox.StartEvent("Test", level: .warning)
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.level, .warning)
    }
    
    func test_defaultLevel() {
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.level, .debug)
    }
    
    func test_category() {
        waitForLog { BlackBox.logEnd(event, category: "Analytics") }
        XCTAssertEqual(logger.endEvent?.category, "Analytics")
    }
    
    func test_parentEvent() {
        let parentEvent = BlackBox.GenericEvent("Test")
        waitForLog { BlackBox.logEnd(event, parentEvent: parentEvent) }
        XCTAssertEqual(logger.endEvent?.parentEvent, parentEvent)
    }
    
    func test_fileID() {
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.source.fileID.description, "BlackBoxTests/BlackBoxEndEventTests.swift")
    }
    
    func test_module() {
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.source.module, "BlackBoxTests")
    }
    
    func test_filename() {
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.source.filename, "BlackBoxEndEventTests")
    }
    
    func test_function() {
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.source.function.description, "test_function()")
    }
    
    func test_line() {
        waitForLog { BlackBox.logEnd(event) }
        XCTAssertEqual(logger.endEvent?.source.line, 87)
    }
}
