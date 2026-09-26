import Foundation

public protocol BBLogMessageProvider where Self: Swift.Error {
    var logMessage: String { get }
}
