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
    
    func waitForLog(
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
