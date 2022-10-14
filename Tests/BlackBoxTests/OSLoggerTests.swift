//
//  OSLoggerTests.swift
//  
//
//  Created by Aleksey Berezka on 13.10.2022.
//

import Foundation
import XCTest
@testable import BlackBox

class OSLoggerTests: XCTestCase {
    var sut: OSLoggerMock!
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = .init(
            levels: .allCases
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_genericEvent_message() {
        let event = BlackBox.GenericEvent("Hello there")
        sut.log(event)
        
        let expectedResult = """
Hello there

[Sender]:
OSLoggerTests.test_genericEvent_message()

[User Info]:
nil
"""
        XCTAssertEqual(sut.data?.message, expectedResult)
    }
    
    func test_genericEvent_userInfo() {
        let event = BlackBox.GenericEvent(
            "Hello there",
            userInfo: ["response": "General Kenobi"]
        )
        
        sut.log(event)
        
        let expectedResult = """
Hello there

[Sender]:
OSLoggerTests.test_genericEvent_userInfo()

[User Info]:
{
  "response" : "General Kenobi"
}
"""
        XCTAssertEqual(sut.data?.message, expectedResult)
    }
    
    struct Response {
        let value: String
    }
    func test_genericEvent_userInfo_nonCodable() {
        let event = BlackBox.GenericEvent(
            "Hello there",
            userInfo: ["response": Response(value: "General Kenobi")]
        )
        
        sut.log(event)
        
        let expectedResult = """
Hello there

[Sender]:
OSLoggerTests.test_genericEvent_userInfo_nonCodable()

[User Info]:
["response": BlackBoxTests.OSLoggerTests.Response(value: "General Kenobi")]
"""
        XCTAssertEqual(sut.data?.message, expectedResult)
    }
    
    func test_genericEvent_invalidLevels() {
        sut = .init(levels: [.error])

        let logLevels: [BBLogLevel] = [.debug, .info, .warning]
        
        logLevels.forEach { level in
            let event = BlackBox.GenericEvent("Hello There", level: level)
            sut.log(event)
        }
        
        XCTAssertNil(sut.data)
    }
    
    func test_genericEvent_validLevel() {
        sut = .init(levels: [.error])
        let event = BlackBox.GenericEvent("Hello There", level: .error)
        sut.log(event)
        XCTAssertNotNil(sut.data)
    }
    
    func test_genericEvent_subsystem() {
        let event = BlackBox.GenericEvent("Hello There")
        sut.log(event)
        XCTAssertEqual(sut.data?.subsystem, "BlackBoxTests")
    }
    
    func test_genericEvent_categoryProvided() {
        let event = BlackBox.GenericEvent("Hello There", category: "Analytics")
        sut.log(event)
        XCTAssertEqual(sut.data?.category, "Analytics")
    }
    
    func test_genericEvent_categoryNotProvided() {
        let event = BlackBox.GenericEvent("Hello There")
        sut.log(event)
        XCTAssertEqual(sut.data?.category, "")
    }
}

class OSLoggerMock: OSLogger {
    var data: LogData?
    override func osLog(_ data: LogData) {
        self.data = data
    }
}
