//
//  BlackBoxGenericEventTests.swift
//  
//
//  Created by Aleksey Berezka on 13.10.2022.
//

import XCTest
@testable import BlackBox

class BlackBoxGenericEventTests: BlackBoxTestCase {
    func test_genericLog_message() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.message, "Test")
    }
    
    func test_genericLog_userInfo() {
        log("Test", userInfo: ["name": "Kenobi"])
        XCTAssertEqual(logger.genericEvent?.userInfo as? [String: String], ["name": "Kenobi"])
    }
    
    func test_genericLog_serviceInfo() {
        log("Test", serviceInfo: Lightsaber(color: "purple"))
        XCTAssertEqual(logger.genericEvent?.serviceInfo as? Lightsaber, Lightsaber(color: "purple"))
    }
    
    func test_genericLog_level() {
        log("Test", level: .warning)
        XCTAssertEqual(logger.genericEvent?.level, .warning)
    }
    
    func test_genericLog_defaultLevel() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.level, .debug)
    }
    
    func test_genericLog_category() {
        log("Test", category: "Analytics")
        XCTAssertEqual(logger.genericEvent?.category, "Analytics")
    }
    
    func test_genericLog_parentEvent() {
        let parentEvent = BlackBox.GenericEvent("Test")
        log("Test 2", parentEvent: parentEvent)
        XCTAssertEqual(logger.genericEvent?.parentEvent, parentEvent)
    }
    
    func test_genericLog_fileID() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.source.fileID.description, "BlackBoxTests/BlackBoxGenericEventTests.swift")
    }
    
    func test_genericLog_module() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.source.module, "BlackBoxTests")
    }
    
    func test_genericLog_filename() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.source.filename, "BlackBoxGenericEventTests")
    }
    
    func test_genericLog_function() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.source.function.description, "test_genericLog_function()")
    }
    
    func test_genericLog_line() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.source.line, 69)
    }
}
