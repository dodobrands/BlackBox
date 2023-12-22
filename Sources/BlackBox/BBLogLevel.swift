import Foundation

public enum BBLogLevel: String, CaseIterable {
    case debug, info, warning, error
}

extension Array where Element == BBLogLevel {
    public static var allCases: [Element] { BBLogLevel.allCases }
}

extension BBLogLevel {
    /// Icons used when formatting messages with loggers
    /// 
    /// See ``BBLogIcon`` for more details
    public var icon: String {
        switch self {
        case .debug: return BBLogIcon.debug
        case .info: return BBLogIcon.info
        case .warning: return BBLogIcon.warning
        case .error: return BBLogIcon.error
        }
    }
}

/// Icons optionally used in messages to improve readability
/// 
/// See ``BBLogFormat/levelsWithIcons`` for more details
public struct BBLogIcon {
    public static var debug =  "🛠"
    public static var info =  "ℹ️"
    public static var warning =  "⚠️"
    public static var error =  "❌"
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
