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
        waitForLog { BlackBox.log("Test") }
        XCTAssertEqual(logger.genericEvent?.message, "Test")
    }
    
    func test_userInfo() {
        waitForLog { BlackBox.log("Test", userInfo: ["name": "Kenobi"]) }
        XCTAssertEqual(logger.genericEvent?.userInfo as? [String: String], ["name": "Kenobi"])
    }
    
    func test_serviceInfo() {
        waitForLog { BlackBox.log("Test", serviceInfo: Lightsaber(color: "purple")) }
        XCTAssertEqual(logger.genericEvent?.serviceInfo as? Lightsaber, Lightsaber(color: "purple"))
    }
    
    func test_level() {
        waitForLog { BlackBox.log("Test", level: .warning) }
        XCTAssertEqual(logger.genericEvent?.level, .warning)
    }
    
    func test_defaultLevel() {
        waitForLog { BlackBox.log("Test") }
        XCTAssertEqual(logger.genericEvent?.level, .debug)
    }
    
    func test_category() {
        waitForLog { BlackBox.log("Test", category: "Analytics") }
        XCTAssertEqual(logger.genericEvent?.category, "Analytics")
    }
    
    func test_parentEvent() {
        let parentEvent = BlackBox.GenericEvent("Test")
        waitForLog { BlackBox.log("Test 2", parentEvent: parentEvent) }
        XCTAssertEqual(logger.genericEvent?.parentEvent, parentEvent)
    }
    
    func test_fileID() {
        waitForLog { BlackBox.log("Test") }
        XCTAssertEqual(logger.genericEvent?.source.fileID.description, "BlackBoxTests/BlackBoxGenericEventTests.swift")
    }
    
    func test_module() {
        waitForLog { BlackBox.log("Test") }
        XCTAssertEqual(logger.genericEvent?.source.module, "BlackBoxTests")
    }
    
    func test_anotherModule() {
        waitForLog { ExampleService().doSomeWork() }
        XCTAssertEqual(logger.genericEvent?.source.module, "ExampleModule")
    }
    
    func test_filename() {
        waitForLog { BlackBox.log("Test") }
        XCTAssertEqual(logger.genericEvent?.source.filename, "BlackBoxGenericEventTests")
    }
    
    func test_function() {
        waitForLog { BlackBox.log("Test") }
        XCTAssertEqual(logger.genericEvent?.source.function.description, "test_function()")
    }
    
    func test_line() {
        waitForLog { BlackBox.log("Test") }
        XCTAssertEqual(logger.genericEvent?.source.line, 75)
    }
}
