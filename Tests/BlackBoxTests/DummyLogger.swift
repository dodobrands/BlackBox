//
//  DummyLogger.swift
//  
//
//  Created by Aleksey Berezka on 13.10.2022.
//

import XCTest
import BlackBox

class DummyLogger: BBLoggerProtocol {
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
