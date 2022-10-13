//
//  BlackBoxTests+ErrorEvent.swift
//  
//
//  Created by Aleksey Berezka on 13.10.2022.
//

import XCTest
@testable import BlackBox

extension BlackBoxTests {
    func test_errorLog_error() {
        log(SomeError.someCase)
        XCTAssertEqual(logger.errorEvent?.error as? SomeError, SomeError.someCase)
    }
    
    func test_errorLog_message() {
        log(SomeError.someCase)
        XCTAssertEqual(logger.errorEvent?.message, "BlackBoxTests.SomeError.someCase")
    }
    
    func test_errorLog_userInfo() {
        log(SomeError.otherCase(value: 123))
        XCTAssertEqual(logger.errorEvent?.userInfo as? [String: Int], ["value": 123])
    }
    
    func test_errorLog_serviceInfo() {
        log(SomeError.someCase, serviceInfo: ObiWan(greeting: "Hello there"))
        XCTAssertEqual(logger.errorEvent?.serviceInfo as? ObiWan, ObiWan(greeting: "Hello there"))
    }
    
    func test_errorLog_level() {
        log(SomeError.someCase)
        XCTAssertEqual(logger.errorEvent?.level, .error)
    }
    
    func test_errorLog_category() {
        log(SomeError.someCase, category: "Analytics")
        XCTAssertEqual(logger.errorEvent?.category, "Analytics")
    }
    
    func test_errorLog_parentEvent() {
        let parentEvent = BlackBox.GenericEvent("Test")
        log(SomeError.someCase, parentEvent: parentEvent)
        XCTAssertEqual(logger.errorEvent?.parentEvent, parentEvent)
    }
    
    func test_errorLog_fileID() {
        log(SomeError.someCase)
        XCTAssertEqual(logger.errorEvent?.source.fileID.description, "BlackBoxTests/BlackBoxTests+ErrorEvent.swift")
    }
    
    func test_errorLog_module() {
        log(SomeError.someCase)
        XCTAssertEqual(logger.errorEvent?.source.module, "BlackBoxTests")
    }
    
    func test_errorLog_filename() {
        log(SomeError.someCase)
        XCTAssertEqual(logger.errorEvent?.source.filename, "BlackBoxTests+ErrorEvent")
    }
    
    func test_errorLog_function() {
        log(SomeError.someCase)
        XCTAssertEqual(logger.errorEvent?.source.function.description, "test_errorLog_function()")
    }
    
    func test_errorLog_line() {
        log(SomeError.someCase)
        XCTAssertEqual(logger.errorEvent?.source.line, 69)
    }
}
