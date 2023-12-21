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
    let timeout: TimeInterval = 1
    var logger: BBLoggerProtocol!
    var testableLogger: TestableLoggerProtocol { logger as! TestableLoggerProtocol } 
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        logger = LoggerMock()
        BlackBox.instance = .init(loggers: [logger])
    }
    
    override func tearDownWithError() throws {
        logger = nil
        try super.tearDownWithError()
    }
}
