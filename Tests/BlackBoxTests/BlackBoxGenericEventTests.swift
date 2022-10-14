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
        log("Test")
        XCTAssertEqual(logger.genericEvent?.message, "Test")
    }
    
    func test_userInfo() {
        log("Test", userInfo: ["name": "Kenobi"])
        XCTAssertEqual(logger.genericEvent?.userInfo as? [String: String], ["name": "Kenobi"])
    }
    
    func test_serviceInfo() {
        log("Test", serviceInfo: Lightsaber(color: "purple"))
        XCTAssertEqual(logger.genericEvent?.serviceInfo as? Lightsaber, Lightsaber(color: "purple"))
    }
    
    func test_level() {
        log("Test", level: .warning)
        XCTAssertEqual(logger.genericEvent?.level, .warning)
    }
    
    func test_defaultLevel() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.level, .debug)
    }
    
    func test_category() {
        log("Test", category: "Analytics")
        XCTAssertEqual(logger.genericEvent?.category, "Analytics")
    }
    
    func test_parentEvent() {
        let parentEvent = BlackBox.GenericEvent("Test")
        log("Test 2", parentEvent: parentEvent)
        XCTAssertEqual(logger.genericEvent?.parentEvent, parentEvent)
    }
    
    func test_fileID() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.source.fileID.description, "BlackBoxTests/BlackBoxGenericEventTests.swift")
    }
    
    func test_module() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.source.module, "BlackBoxTests")
    }
    
    func test_anotherModule() {
        waitForLog {
            ExampleService().doSomeWork()
        }
        XCTAssertEqual(logger.genericEvent?.source.module, "ExampleModule")
    }
    
    func test_filename() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.source.filename, "BlackBoxGenericEventTests")
    }
    
    func test_function() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.source.function.description, "test_function()")
    }
    
    func test_line() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.source.line, 77)
    }
}
