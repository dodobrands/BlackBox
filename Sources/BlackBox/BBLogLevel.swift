import Foundation

public enum BBLogLevel: String, CaseIterable {
    case debug, info, warning, error
}

extension Array where Element == BBLogLevel {
    public static var allCases: [Element] { BBLogLevel.allCases }
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
