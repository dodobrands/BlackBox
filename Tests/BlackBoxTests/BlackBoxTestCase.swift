//
//  BlackBoxTestCase.swift
//  BlackBoxTestCase
//
//  Created by Алексей Берёзка on 01.08.2020.
//  Copyright © 2020 Dodo Pizza Engineering. All rights reserved.
//

import XCTest
@testable import BlackBox

class BlackBoxTestCase: XCTestCase {
    let timeout: TimeInterval = 0.1
    var logger: (BBLoggerProtocol & TestableLoggerProtocol)!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        logger = DummyLogger()
        BlackBox.instance = .init(loggers: [logger])
    }
    
    override func tearDownWithError() throws {
        logger = nil
        try super.tearDownWithError()
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
        line: UInt = #line,
        isInverted: Bool = false
    ) {
        waitForLog(isInverted: isInverted) {
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
        }
    }
    
    func log(
        _ error: Error,
        serviceInfo: BBServiceInfo? = nil,
        category: String? = nil,
        parentEvent: BlackBox.GenericEvent? = nil,
        fileID: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line,
        isInverted: Bool = false
    ) {
        waitForLog(isInverted: isInverted) {
            BlackBox.log(
                error,
                serviceInfo: serviceInfo,
                category: category,
                parentEvent: parentEvent,
                fileID: fileID,
                function: function,
                line: line
            )
        }
    }
    
    func logStart(
        _ message: String,
        userInfo: BBUserInfo? = nil,
        serviceInfo: BBServiceInfo? = nil,
        level: BBLogLevel = .debug,
        category: String? = nil,
        parentEvent: BlackBox.GenericEvent? = nil,
        fileID: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line,
        isInverted: Bool = false
    ) {
        waitForLog(isInverted: isInverted) {
            let _ = BlackBox.logStart(
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
        }
    }
    
    func logStart(
        _ event: BlackBox.StartEvent,
        isInverted: Bool = false
    ) {
        waitForLog(isInverted: isInverted) {
            BlackBox.logStart(
                event
            )
        }
    }
    
    func logEnd(
        _ event: BlackBox.StartEvent,
        message: String? = nil,
        userInfo: BBUserInfo? = nil,
        serviceInfo: BBServiceInfo? = nil,
        category: String? = nil,
        parentEvent: BlackBox.GenericEvent? = nil,
        fileID: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line,
        isInverted: Bool = false
    ) {
        waitForLog(isInverted: isInverted) {
            BlackBox.logEnd(
                event,
                message: message,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                category: category,
                parentEvent: parentEvent,
                fileID: fileID,
                function: function,
                line: line
            )
        }
    }
    
    private func waitForLog(
        isInverted: Bool = false,
        from code: () -> ()
    ) {
        let expectation = expectation(description: "Log received")
        expectation.isInverted = isInverted
        logger.expectation = expectation
        
        code()
        
        wait(for: [expectation], timeout: timeout)
    }
}

protocol TestableLoggerProtocol {
    var expectation: XCTestExpectation? { get set }
    var genericEvent: BlackBox.GenericEvent? { get set }
    var errorEvent: BlackBox.ErrorEvent? { get set }
    var startEvent: BlackBox.StartEvent? { get set }
    var endEvent: BlackBox.EndEvent? { get set }
}
