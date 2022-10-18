import Foundation

public protocol BBLoggerProtocol {
    func log(_ event: BlackBox.GenericEvent)
    
    func log(_ event: BlackBox.ErrorEvent)
    
    // MARK: - Trace
    func logStart(_ event: BlackBox.StartEvent)
    
    func logEnd(_ event: BlackBox.EndEvent)
}
