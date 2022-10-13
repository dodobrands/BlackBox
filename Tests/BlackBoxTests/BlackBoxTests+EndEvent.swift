//
//  BlackBoxTests+EndEvent.swift
//  
//
//  Created by Aleksey Berezka on 13.10.2022.
//

import XCTest
@testable import BlackBox

extension BlackBoxTests {
    func test_endEvent_startEvent() {
        let event = BlackBox.StartEvent("Test")
        logEnd(event)
        XCTAssertEqual(logger.endEvent?.startEvent, event)
    }
    func test_endLog_message() {
        let event = BlackBox.StartEvent("Test")
        logEnd(event)
        XCTAssertEqual(logger.endEvent?.message, "End: Test")
    }
    
    func test_endLog_rawMessage() {
        let event = BlackBox.StartEvent("Test")
        logEnd(event)
        XCTAssertEqual(logger.endEvent?.rawMessage, "Test")
    }
    
    func test_endLog_userInfo() {
        let event = BlackBox.StartEvent("Test")
        logEnd(event, userInfo: ["name": "Kenobi"])
        XCTAssertEqual(logger.endEvent?.userInfo as? [String: String], ["name": "Kenobi"])
    }
    
    func test_endLog_serviceInfo() {
        let event = BlackBox.StartEvent("Test")
        logEnd(event, serviceInfo: Lightsaber(color: "purple"))
        XCTAssertEqual(logger.endEvent?.serviceInfo as? Lightsaber, Lightsaber(color: "purple"))
    }
    
    func test_endLog_level() {
        let event = BlackBox.StartEvent("Test", level: .warning)
        logEnd(event)
        XCTAssertEqual(logger.endEvent?.level, .warning)
    }
    
    func test_endLog_category() {
        let event = BlackBox.StartEvent("Test")
        logEnd(event, category: "Analytics")
        XCTAssertEqual(logger.endEvent?.category, "Analytics")
    }
    
    func test_endLog_parentEvent() {
        let event = BlackBox.StartEvent("Test")
        let parentEvent = BlackBox.GenericEvent("Test")
        logEnd(event, parentEvent: parentEvent)
        XCTAssertEqual(logger.endEvent?.parentEvent, parentEvent)
    }
    
    func test_endLog_fileID() {
        let event = BlackBox.StartEvent("Test")
        logEnd(event)
        XCTAssertEqual(logger.endEvent?.source.fileID.description, "BlackBoxTests/BlackBoxTests+EndEvent.swift")
    }
    
    func test_endLog_module() {
        let event = BlackBox.StartEvent("Test")
        logEnd(event)
        XCTAssertEqual(logger.endEvent?.source.module, "BlackBoxTests")
    }
    
    func test_endLog_filename() {
        let event = BlackBox.StartEvent("Test")
        logEnd(event)
        XCTAssertEqual(logger.endEvent?.source.filename, "BlackBoxTests+EndEvent")
    }
    
    func test_endLog_function() {
        let event = BlackBox.StartEvent("Test")
        logEnd(event)
        XCTAssertEqual(logger.endEvent?.source.function.description, "test_endLog_function()")
    }
    
    func test_endLog_line() {
        let event = BlackBox.StartEvent("Test")
        logEnd(event)
        XCTAssertEqual(logger.endEvent?.source.line, 86)
    }
}
