//
//  BBLoggerProtocol.swift
//  DFoundation
//
//  Created by Алексей Берёзка on 27.02.2020.
//  Copyright © 2020 ru.dodopizza. All rights reserved.
//

import Foundation

public protocol BBLoggerProtocol {
    func log(
        _ error: BlackBox.Error
    )
    
    func log(
        _ event: BlackBox.Event
    )
    
    // MARK: - Trace
    func logStart(
        _ event: BlackBox.Event
    )
    
    func logEnd(
        startEvent: BlackBox.Event,
        endEvent: BlackBox.Event
    )
}

public enum BBEventType {
    case start, end
    case event
}

public extension BBEventType {
    var description: String {
        switch self {
        case .start:
            return "Start"
        case .end:
            return "End"
        case .event:
            return "Event"
        }
    }
}
