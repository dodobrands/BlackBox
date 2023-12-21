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
    
    func test_startEvent() {
        BlackBox.logEnd(event)
        XCTAssertEqual(testableLogger.endEvent?.startEvent, event)
    }
    
    func test_duration() {
        let startTimestamp = Date()
        let endTimestamp = startTimestamp.addingTimeInterval(10)
        
        let startEvent = BlackBox.StartEvent(timestamp: startTimestamp, "Test")
        let endEvent = BlackBox.EndEvent(timestamp: endTimestamp, message: "Test", startEvent: startEvent)
        
        XCTAssertEqual(endEvent.duration, 10)
    }
    
    func test_durationFormatted() {
        let startTimestamp = Date()
        let endTimestamp = startTimestamp.addingTimeInterval(1)
        
        let startEvent = BlackBox.StartEvent(timestamp: startTimestamp, "Test")
        let endEvent = BlackBox.EndEvent(timestamp: endTimestamp, message: "Test", startEvent: startEvent)
        
        XCTAssertEqual(endEvent.durationFormatted, "1 sec")
    }
    
    func test_durationFormatted_short() {
        let startTimestamp = Date()
        let endTimestamp = startTimestamp.addingTimeInterval(0.0001)
        
        let startEvent = BlackBox.StartEvent(timestamp: startTimestamp, "Test")
        let endEvent = BlackBox.EndEvent(timestamp: endTimestamp, message: "Test", startEvent: startEvent)
        
        XCTAssertEqual(endEvent.durationFormatted, "0.0001 secs")
    }
    
    func test_durationFormatted_long() {
        let startTimestamp = Date()
        let endTimestamp = startTimestamp.addingTimeInterval(1000)
        
        let startEvent = BlackBox.StartEvent(timestamp: startTimestamp, "Test")
        let endEvent = BlackBox.EndEvent(timestamp: endTimestamp, message: "Test", startEvent: startEvent)
        
        XCTAssertEqual(endEvent.durationFormatted, "1,000 secs")
    }
    
    func test_message() throws {
        let event = BlackBox.StartEvent(timestamp: Date().addingTimeInterval(-1), "Test")
        BlackBox.logEnd(event)
        let endEvent = try XCTUnwrap(testableLogger.endEvent)
        XCTAssertTrue(endEvent.durationFormatted.hasPrefix("1.00"))
    }
    
    func test_rawMessage() {
        BlackBox.logEnd(event)
        XCTAssertEqual(testableLogger.endEvent?.rawMessage.description, "Test".description)
    }
    
    func test_customMessage() throws {
        let event = BlackBox.StartEvent("Test")
        BlackBox.logEnd(event, message: "Custom Message")
        let endEvent = try XCTUnwrap(testableLogger.endEvent)
        XCTAssertTrue(endEvent.message.hasPrefix("End: Custom Message"))
    }
    
    func test_userInfo() {
        BlackBox.logEnd(event, userInfo: ["name": "Kenobi"])
        XCTAssertEqual(testableLogger.endEvent?.userInfo as? [String: String], ["name": "Kenobi"])
    }
    
    func test_serviceInfo() {
        BlackBox.logEnd(event, serviceInfo: Lightsaber(color: "purple"))
        XCTAssertEqual(testableLogger.endEvent?.serviceInfo as? Lightsaber, Lightsaber(color: "purple"))
    }
    
    func test_levelComeFromStartEvent() {
        event = BlackBox.StartEvent("Test", level: .warning)
        BlackBox.logEnd(event)
        XCTAssertEqual(testableLogger.endEvent?.level, .warning)
    }
    
    func test_defaultLevel() {
        BlackBox.logEnd(event)
        XCTAssertEqual(testableLogger.endEvent?.level, .debug)
    }
    
    func test_category() {
        BlackBox.logEnd(event, category: "Analytics")
        XCTAssertEqual(testableLogger.endEvent?.category, "Analytics")
    }
    
    func test_parentEvent() {
        BlackBox.logEnd(event)
        XCTAssertEqual(testableLogger.endEvent?.parentEvent, event)
        XCTAssertEqual(testableLogger.endEvent?.startEvent, event)
    }
    
    func test_fileID() {
        BlackBox.logEnd(event)
        XCTAssertEqual(testableLogger.endEvent?.source.fileID.description, "BlackBoxTests/BlackBoxEndEventTests.swift")
    }
    
    func test_module() {
        BlackBox.logEnd(event)
        XCTAssertEqual(testableLogger.endEvent?.source.module, "BlackBoxTests")
    }
    
    func test_filename() {
        BlackBox.logEnd(event)
        XCTAssertEqual(testableLogger.endEvent?.source.filename, "BlackBoxEndEventTests")
    }
    
    func test_function() {
        BlackBox.logEnd(event)
        XCTAssertEqual(testableLogger.endEvent?.source.function.description, "test_function()")
    }
    
    func test_line() {
        BlackBox.logEnd(event)
        XCTAssertEqual(testableLogger.endEvent?.source.line, 136)
    }
}
