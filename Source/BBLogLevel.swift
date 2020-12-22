//
//  BBLogLevel.swift
//  BlackBox
//
//  Created by Алексей Берёзка on 21.12.2020.
//  Copyright © 2020 Dodo Pizza Engineering. All rights reserved.
//

import Foundation

public enum BBLogLevel {
    case `default`, debug, info, warning, error
}

extension BBLogLevel {
    public var icon: String {
        switch self {
        case .debug:
            return "🛠"
        case .error:
            return "❌"
        case .warning:
            return "⚠️"
        case .info:
            return "ℹ️"
        case .default:
            return "📝"
        }
    }
}

public protocol BBLogLevelProvider where Self: Swift.Error {
    var logLevel: BBLogLevel { get }
}
