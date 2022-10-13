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
    
    struct ObiWan: Equatable {
        let greeting: String
    }
    
    enum SomeError: Error, Equatable, CustomNSError {
        case someCase
        case otherCase(value: Int)
        
        var errorUserInfo: [String : Any] {
            switch self {
            case .someCase:
                return [:]
            case .otherCase(let value):
                return ["value": value]
            }
        }
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
    
    func log(
        _ error: Error,
        serviceInfo: BBServiceInfo? = nil,
        category: String? = nil,
        parentEvent: BlackBox.GenericEvent? = nil,
        fileID: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        let expectation = expectation(description: "Log received")
        logger.expectation = expectation
        
        BlackBox.log(
            error,
            serviceInfo: serviceInfo,
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
        expectation?.fulfill()
    }
    
    var startEvent: BlackBox.StartEvent?
    func logStart(_ event: BlackBox.StartEvent) {
        startEvent = event
        expectation?.fulfill()
    }
    
    var endEvent: BlackBox.EndEvent?
    func logEnd(_ event: BlackBox.EndEvent) {
        endEvent = event
        expectation?.fulfill()
    }
}
