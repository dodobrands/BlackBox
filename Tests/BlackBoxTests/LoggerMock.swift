//
//  LoggerMock.swift
//  
//
//  Created by Aleksey Berezka on 13.10.2022.
//

import XCTest
import BlackBox

protocol TestableLoggerProtocol {
    var genericEvent: BlackBox.GenericEvent? { get set }
    var errorEvent: BlackBox.ErrorEvent? { get set }
    var startEvent: BlackBox.StartEvent? { get set }
    var endEvent: BlackBox.EndEvent? { get set }
}

class LoggerMock: BBLoggerProtocol, TestableLoggerProtocol {
    
    var genericEvent: BlackBox.GenericEvent?
    func log(_ event: BlackBox.GenericEvent) { genericEvent = event }
    
    var errorEvent: BlackBox.ErrorEvent?
    func log(_ event: BlackBox.ErrorEvent) { errorEvent = event }
    
    var startEvent: BlackBox.StartEvent?
    func logStart(_ event: BlackBox.StartEvent) { startEvent = event }
    
    var endEvent: BlackBox.EndEvent?
    func logEnd(_ event: BlackBox.EndEvent) { endEvent = event }
}

