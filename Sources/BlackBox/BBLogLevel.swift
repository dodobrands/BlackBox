import Foundation

public enum BBLogLevel: String, CaseIterable {
    case debug, info, warning, error
}

extension BBLogLevel {
    public var icon: String {
        switch self {
        case .debug:
            return "🛠"
        case .info:
            return "ℹ️"
        case .warning:
            return "⚠️"
        case .error:
            return "❌"
        }
    }
}

public protocol BBLogLevelProvider where Self: Swift.Error {
    var level: BBLogLevel { get }
}

public extension Swift.Error {
    var level: BBLogLevel {
        if let levelProvider = self as? BBLogLevelProvider {
            return levelProvider.level
        } else {
            return .error
        }
    }
}
