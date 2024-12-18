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
    @available(*, deprecated, message: "Use BBLogFormat.Icons")
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
@available(*, deprecated, message: "Use struct BBLogFormat.Icons")
public struct BBLogIcon {
    nonisolated(unsafe) public static var debug =  "🛠"
    nonisolated(unsafe) public static var info =  "ℹ️"
    nonisolated(unsafe) public static var warning =  "⚠️"
    nonisolated(unsafe) public static var error =  "❌"
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
