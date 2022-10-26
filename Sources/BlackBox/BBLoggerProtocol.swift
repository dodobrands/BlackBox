import Foundation

/// Receives all possible logs from BlackBox
public protocol BBLoggerProtocol {
    /// Logs generic event
    /// - Parameter event: Generic event
    func log(_ event: BlackBox.GenericEvent)
    
    /// Logs error
    /// - Parameter event: Error event
    func log(_ event: BlackBox.ErrorEvent)
    
    // MARK: - Measurements
    /// Logs measurement start
    /// - Parameter event: Measurement start event
    func logStart(_ event: BlackBox.StartEvent)
    
    /// Logs measurement end
    /// - Parameter event: Measurement end event
    func logEnd(_ event: BlackBox.EndEvent)
}
