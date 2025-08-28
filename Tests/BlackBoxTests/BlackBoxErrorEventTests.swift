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
        BlackBox.log(AnakinKills.maceWindu)
        XCTAssertEqual(testableLogger.errorEvent?.error as? AnakinKills, AnakinKills.maceWindu)
    }
    
    func test_message() {
        BlackBox.log(AnakinKills.maceWindu)
        XCTAssertEqual(testableLogger.errorEvent?.message, "AnakinKills.maceWindu")
    }
    
    func test_message_fromAnotherModule() {
        ExampleService().logSomeError()
        XCTAssertEqual(testableLogger.errorEvent?.message, "ExampleError.taskFailed")
    }
    
    func test_message_hasNoWithAssociatedValue() {
        BlackBox.log(AnakinKills.younglings(count: 11))
        XCTAssertEqual(testableLogger.errorEvent?.message, "AnakinKills.younglings")
    }
    
    func test_userInfo_hasAssociatedValue() {
        BlackBox.log(AnakinKills.younglings(count: 11))
        XCTAssertEqual(testableLogger.errorEvent?.userInfo as? [String: Int], ["count": 11])
    }
    
    func test_serviceInfo() {
        BlackBox.log(AnakinKills.maceWindu, serviceInfo: Lightsaber(color: "purple"))
        XCTAssertEqual(testableLogger.errorEvent?.serviceInfo as? Lightsaber, Lightsaber(color: "purple"))
    }
    
    func test_defaultLevel() {
        BlackBox.log(AnakinKills.maceWindu)
        XCTAssertEqual(testableLogger.errorEvent?.level, .error)
    }
    
    func test_category() {
        BlackBox.log(AnakinKills.maceWindu, category: "Analytics")
        XCTAssertEqual(testableLogger.errorEvent?.category, "Analytics")
    }
    
    func test_parentEvent() {
        let parentEvent = BlackBox.GenericEvent("Test")
        BlackBox.log(AnakinKills.maceWindu, parentEvent: parentEvent)
        XCTAssertEqual(testableLogger.errorEvent?.parentEvent, parentEvent)
    }
    
    func test_fileID() {
        BlackBox.log(AnakinKills.maceWindu)
        XCTAssertEqual(testableLogger.errorEvent?.source.fileID.description, "BlackBoxTests/BlackBoxErrorEventTests.swift")
    }
    
    func test_module() {
        BlackBox.log(AnakinKills.maceWindu)
        XCTAssertEqual(testableLogger.errorEvent?.source.module, "BlackBoxTests")
    }
    
    func test_filename() {
        BlackBox.log(AnakinKills.maceWindu)
        XCTAssertEqual(testableLogger.errorEvent?.source.filename, "BlackBoxErrorEventTests")
    }
    
    func test_function() {
        BlackBox.log(AnakinKills.maceWindu)
        XCTAssertEqual(testableLogger.errorEvent?.source.function.description, "test_function()")
    }
    
    func test_line() {
        BlackBox.log(AnakinKills.maceWindu)
        XCTAssertEqual(testableLogger.errorEvent?.source.line, 80)
    }
    
    func test_durationFormattedIsNil() {
        BlackBox.log(AnakinKills.maceWindu)
        XCTAssertNil(testableLogger.errorEvent?.formattedDuration(using: MeasurementFormatter()))
    }
    
    func test_messageWithDurationFormattedIsMessageItself() {
        BlackBox.log(AnakinKills.maceWindu)
        XCTAssertEqual(testableLogger.errorEvent?.message, testableLogger.errorEvent?.messageWithFormattedDuration(using: MeasurementFormatter()))
    }
    
    func test_isTrace() {
        BlackBox.log(AnakinKills.maceWindu)
        XCTAssertEqual(testableLogger.errorEvent?.isTrace, false)
    }
}
