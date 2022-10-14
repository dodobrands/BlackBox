//
//  BlackBoxErrorEventTests.swift
//  
//
//  Created by Aleksey Berezka on 13.10.2022.
//

import XCTest
@testable import BlackBox
@testable import ExampleModule

class BlackBoxErrorEventTests: BlackBoxTestCase {
    func test_error() {
        log(AnakinKills.maceWindu)
        XCTAssertEqual(logger.errorEvent?.error as? AnakinKills, AnakinKills.maceWindu)
    }
    
    func test_message() {
        log(AnakinKills.maceWindu)
        XCTAssertEqual(logger.errorEvent?.message, "BlackBoxTests.AnakinKills.maceWindu")
    }
    
    func test_message_fromAnotherModule() {
        waitForLog {
            ExampleService().logSomeError()
        }
        XCTAssertEqual(logger.errorEvent?.message, "ExampleModule.ExampleError.taskFailed")
    }
    
    func test_messageOfErrorWithAssociatedValue() {
        log(AnakinKills.younglings(count: 11))
        XCTAssertEqual(logger.errorEvent?.message, "BlackBoxTests.AnakinKills.younglings")
    }
    
    func test_userInfoOfErrorWithAssociatedValue() {
        log(AnakinKills.younglings(count: 11))
        XCTAssertEqual(logger.errorEvent?.userInfo as? [String: Int], ["count": 11])
    }
    
    func test_serviceInfo() {
        log(AnakinKills.maceWindu, serviceInfo: Lightsaber(color: "purple"))
        XCTAssertEqual(logger.errorEvent?.serviceInfo as? Lightsaber, Lightsaber(color: "purple"))
    }
    
    func test_defaultLevel() {
        log(AnakinKills.maceWindu)
        XCTAssertEqual(logger.errorEvent?.level, .error)
    }
    
    func test_category() {
        log(AnakinKills.maceWindu, category: "Analytics")
        XCTAssertEqual(logger.errorEvent?.category, "Analytics")
    }
    
    func test_parentEvent() {
        let parentEvent = BlackBox.GenericEvent("Test")
        log(AnakinKills.maceWindu, parentEvent: parentEvent)
        XCTAssertEqual(logger.errorEvent?.parentEvent, parentEvent)
    }
    
    func test_fileID() {
        log(AnakinKills.maceWindu)
        XCTAssertEqual(logger.errorEvent?.source.fileID.description, "BlackBoxTests/BlackBoxErrorEventTests.swift")
    }
    
    func test_module() {
        log(AnakinKills.maceWindu)
        XCTAssertEqual(logger.errorEvent?.source.module, "BlackBoxTests")
    }
    
    func test_filename() {
        log(AnakinKills.maceWindu)
        XCTAssertEqual(logger.errorEvent?.source.filename, "BlackBoxErrorEventTests")
    }
    
    func test_function() {
        log(AnakinKills.maceWindu)
        XCTAssertEqual(logger.errorEvent?.source.function.description, "test_function()")
    }
    
    func test_line() {
        log(AnakinKills.maceWindu)
        XCTAssertEqual(logger.errorEvent?.source.line, 82)
    }
}
