//
//  BlackBoxTests.swift
//  BlackBoxTests
//
//  Created by Алексей Берёзка on 01.08.2020.
//  Copyright © 2020 Dodo Pizza Engineering. All rights reserved.
//

import XCTest
@testable import BlackBox

class BlackBoxTests: XCTestCase {
    var logger: TestLogger!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        logger = .init()
        BlackBox.instance = .init(loggers: [logger])
    }
    
    override func tearDownWithError() throws {
        logger = nil
        try super.tearDownWithError()
    }
    
    func test_genericLogMessage() {
        log("Test")
        XCTAssertEqual(logger.genericEvent?.message, "Test")
    }
    
    func test_genericLogUserInfo() {
        log("Test", userInfo: ["name": "Kenobi"])
        XCTAssertEqual(logger.genericEvent?.userInfo as? [String: String], ["name": "Kenobi"])
    }
    
    func test_genericLogServiceInfo() {
        struct ObiWan: Equatable {
            let greeting: String
        }
        log("Test", serviceInfo: ObiWan(greeting: "Hello there"))
        XCTAssertEqual(logger.genericEvent?.serviceInfo as? ObiWan, ObiWan(greeting: "Hello there"))
    }
    
    func log(
        _ message: String,
        userInfo: BBUserInfo? = nil,
        serviceInfo: BBServiceInfo? = nil,
        level: BBLogLevel = .debug,
        category: String? = nil,
        parentEvent: BlackBox.GenericEvent? = nil,
        fileID: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        let expectation = expectation(description: "Log received")
        logger.expectation = expectation
        BlackBox.log(
            message,
            userInfo: userInfo,
            serviceInfo: serviceInfo,
            level: level,
            category: category,
            parentEvent: parentEvent,
            fileID: fileID,
            function: function,
            line: line
        )
        wait(for: [expectation], timeout: 1)
    }
}

class TestLogger: BBLoggerProtocol {
    var expectation: XCTestExpectation?
    
    var genericEvent: BlackBox.GenericEvent?
    func log(_ event: BlackBox.GenericEvent) {
        genericEvent = event
        expectation?.fulfill()
    }
    
    var errorEvent: BlackBox.ErrorEvent?
    func log(_ event: BlackBox.ErrorEvent) {
        errorEvent = event
    }
    
    var startEvent: BlackBox.StartEvent?
    func logStart(_ event: BlackBox.StartEvent) {
        startEvent = event
    }
    
    var endEvent: BlackBox.EndEvent?
    func logEnd(_ event: BlackBox.EndEvent) {
        endEvent = event
    }
}
