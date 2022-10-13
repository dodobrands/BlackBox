//
//  BlackBoxTests+GenericEvent.swift
//  
//
//  Created by Aleksey Berezka on 13.10.2022.
//

import XCTest
@testable import BlackBox

extension BlackBoxTests {
    func test_genericLog_message() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.message, "Test")
    }
    
    func test_genericLog_userInfo() {
        log("Test", userInfo: ["name": "Kenobi"])
        XCTAssertEqual(logger.genericEvent?.userInfo as? [String: String], ["name": "Kenobi"])
    }
    
    func test_genericLog_serviceInfo() {
        log("Test", serviceInfo: ObiWan(greeting: "Hello there"))
        XCTAssertEqual(logger.genericEvent?.serviceInfo as? ObiWan, ObiWan(greeting: "Hello there"))
    }
    
    func test_genericLog_level() {
        log("Test", level: .warning)
        XCTAssertEqual(logger.genericEvent?.level, .warning)
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
        XCTAssertEqual(logger.genericEvent?.source.fileID.description, "BlackBoxTests/BlackBoxTests+GenericEvent.swift")
    }
    
    func test_genericLog_module() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.source.module, "BlackBoxTests")
    }
    
    func test_genericLog_filename() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.source.filename, "BlackBoxTests+GenericEvent")
    }
    
    func test_genericLog_function() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.source.function.description, "test_genericLog_function()")
    }
    
    func test_genericLog_line() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.source.line, 64)
    }
}
