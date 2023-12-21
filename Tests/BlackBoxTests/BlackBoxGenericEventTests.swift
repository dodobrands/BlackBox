//
//  BlackBoxGenericEventTests.swift
//  
//
//  Created by Aleksey Berezka on 13.10.2022.
//

import XCTest
@testable import BlackBox
@testable import ExampleModule

class BlackBoxGenericEventTests: BlackBoxTestCase {
    func test_message() {
        BlackBox.log("Test")
        XCTAssertEqual(testableLogger.genericEvent?.message, "Test")
    }
    
    func test_userInfo() {
        BlackBox.log("Test", userInfo: ["name": "Kenobi"])
        XCTAssertEqual(testableLogger.genericEvent?.userInfo as? [String: String], ["name": "Kenobi"])
    }
    
    func test_serviceInfo() {
        BlackBox.log("Test", serviceInfo: Lightsaber(color: "purple"))
        XCTAssertEqual(testableLogger.genericEvent?.serviceInfo as? Lightsaber, Lightsaber(color: "purple"))
    }
    
    func test_level() {
        BlackBox.log("Test", level: .warning)
        XCTAssertEqual(testableLogger.genericEvent?.level, .warning)
    }
    
    func test_defaultLevel() {
        BlackBox.log("Test")
        XCTAssertEqual(testableLogger.genericEvent?.level, .debug)
    }
    
    func test_category() {
        BlackBox.log("Test", category: "Analytics")
        XCTAssertEqual(testableLogger.genericEvent?.category, "Analytics")
    }
    
    func test_parentEvent() {
        let parentEvent = BlackBox.GenericEvent("Test")
        BlackBox.log("Test 2", parentEvent: parentEvent)
        XCTAssertEqual(testableLogger.genericEvent?.parentEvent, parentEvent)
    }
    
    func test_fileID() {
        BlackBox.log("Test")
        XCTAssertEqual(testableLogger.genericEvent?.source.fileID.description, "BlackBoxTests/BlackBoxGenericEventTests.swift")
    }
    
    func test_module() {
        BlackBox.log("Test")
        XCTAssertEqual(testableLogger.genericEvent?.source.module, "BlackBoxTests")
    }
    
    func test_anotherModule() {
        ExampleService().doSomeWork()
        XCTAssertEqual(testableLogger.genericEvent?.source.module, "ExampleModule")
    }
    
    func test_filename() {
        BlackBox.log("Test")
        XCTAssertEqual(testableLogger.genericEvent?.source.filename, "BlackBoxGenericEventTests")
    }
    
    func test_function() {
        BlackBox.log("Test")
        XCTAssertEqual(testableLogger.genericEvent?.source.function.description, "test_function()")
    }
    
    func test_line() {
        BlackBox.log("Test")
        XCTAssertEqual(testableLogger.genericEvent?.source.line, 75)
    }
}
