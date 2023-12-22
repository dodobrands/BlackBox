import Foundation

public enum BBLogLevel: String, CaseIterable {
    case debug, info, warning, error
}

extension Array where Element == BBLogLevel {
    public static var allCases: [Element] { BBLogLevel.allCases }
}

extension BBLogLevel {
    public var icon: String {
        switch self {
        case .debug: return Icon.debug
        case .info: return Icon.info
        case .warning: return Icon.warning
        case .error: return Icon.error
        }
    }
    
    public struct Icon {
        public static var debug =  "🛠"
        public static var info =  "ℹ️"
        public static var warning =  "⚠️"
        public static var error =  "❌"
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
