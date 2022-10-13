//
//  BBLoggerProtocol.swift
//  DFoundation
//
//  Created by Алексей Берёзка on 27.02.2020.
//  Copyright © 2020 ru.dodopizza. All rights reserved.
//

import Foundation

public protocol BBLoggerProtocol {
    func log(_ event: BlackBox.GenericEvent)
    
    func log(_ event: BlackBox.ErrorEvent)
    
    // MARK: - Trace
    func logStart(_ event: BlackBox.StartEvent)
    
    func logEnd(_ event: BlackBox.EndEvent)
}
