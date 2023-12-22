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
        BlackBox.logStart(event)
        XCTAssertEqual(testableLogger.startEvent, event)
    }
    func test_message() {
        let _ = BlackBox.logStart("Test")
        XCTAssertEqual(testableLogger.startEvent?.message, "Start: Test")
    }
    
    func test_rawMessage() {
        let _ = BlackBox.logStart("Test")
        XCTAssertEqual(testableLogger.startEvent?.rawMessage.description, "Test".description)
    }
    
    func test_userInfo() {
        let _ = BlackBox.logStart("Test", userInfo: ["name": "Kenobi"])
        XCTAssertEqual(testableLogger.startEvent?.userInfo as? [String: String], ["name": "Kenobi"])
    }
    
    func test_serviceInfo() {
        let _ = BlackBox.logStart("Test", serviceInfo: Lightsaber(color: "purple"))
        XCTAssertEqual(testableLogger.startEvent?.serviceInfo as? Lightsaber, Lightsaber(color: "purple"))
    }
    
    func test_level() {
        let _ = BlackBox.logStart("Test", level: .warning)
        XCTAssertEqual(testableLogger.startEvent?.level, .warning)
    }
    
    func test_defaultLevel() {
        let _ = BlackBox.logStart("Test")
        XCTAssertEqual(testableLogger.startEvent?.level, .debug)
    }
    
    func test_category() {
        let _ = BlackBox.logStart("Test", category: "Analytics")
        XCTAssertEqual(testableLogger.startEvent?.category, "Analytics")
    }
    
    func test_parentEvent() {
        let parentEvent = BlackBox.StartEvent("Test")
        let _ = BlackBox.logStart("Test 2", parentEvent: parentEvent)
        XCTAssertEqual(testableLogger.startEvent?.parentEvent, parentEvent)
    }
    
    func test_fileID() {
        let _ = BlackBox.logStart("Test")
        XCTAssertEqual(testableLogger.startEvent?.source.fileID.description, "BlackBoxTests/BlackBoxStartEventTests.swift")
    }
    
    func test_module() {
        let _ = BlackBox.logStart("Test")
        XCTAssertEqual(testableLogger.startEvent?.source.module, "BlackBoxTests")
    }
    
    func test_filename() {
        let _ = BlackBox.logStart("Test")
        XCTAssertEqual(testableLogger.startEvent?.source.filename, "BlackBoxStartEventTests")
    }
    
    func test_function() {
        let _ = BlackBox.logStart("Test")
        XCTAssertEqual(testableLogger.startEvent?.source.function.description, "test_function()")
    }
    
    func test_line() {
        let _ = BlackBox.logStart("Test")
        XCTAssertEqual(testableLogger.startEvent?.source.line, 79)
    }
    
    func test_durationFormattedIsNil() {
        let _ = BlackBox.logStart("Test")
        XCTAssertNil(testableLogger.startEvent?.formattedDuration(using: MeasurementFormatter()))
    }
    
    func test_messageWithDurationFormattedIsMessageItself() {
        let _ = BlackBox.logStart("Test")
        XCTAssertEqual(testableLogger.startEvent?.message, testableLogger.startEvent?.messageWithFormattedDuration(using: MeasurementFormatter()))
    }
}
