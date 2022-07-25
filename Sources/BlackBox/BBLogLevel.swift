import Foundation

public enum BBLogLevel: String, CaseIterable {
    case debug, `default`, info, warning, error
}

extension BBLogLevel {
    public var icon: String {
        switch self {
        case .debug:
            return "🛠"
        case .default:
            return "📝"
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
    var logLevel: BBLogLevel { get }
}

public extension Swift.Error {
    var logLevel: BBLogLevel {
        if let logLevelError = self as? BBLogLevelProvider {
            return logLevelError.logLevel
        } else {
            return .error
        }
    }
}
