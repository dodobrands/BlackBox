import Foundation
import os

/// Redirects logs to Time Profiler
/// Usage example: https://habr.com/ru/company/dododev/blog/690542/
public class OSSignpostLogger: BBLoggerProtocol {
    let levels: [BBLogLevel]
    
    public init(levels: [BBLogLevel]){
        self.levels = levels
    }
    
    public func log(_ event: BlackBox.GenericEvent) {
        signpostLog(event: event)
    }
    
    public func log(_ event: BlackBox.ErrorEvent) {
        signpostLog(event: event)
    }
    
    public func logStart(_ event: BlackBox.StartEvent) {
        signpostLog(event: event)
    }
    
    public func logEnd(_ event: BlackBox.EndEvent) {
        signpostLog(event: event)
    }
}

extension OSSignpostLogger {
    private func signpostLog(
        event: BlackBox.GenericEvent
    ) {
        guard levels.contains(event.level) else { return }
        
        let signpostType = OSSignpostType(event)
        
        let log = OSLog(signpostType: signpostType,
                        event: event)
        
        let name = function(from: event)
        let signpostId = OSSignpostID(event)
        
        os_signpost(signpostType,
                    log: log,
                    name: name,
                    signpostID: signpostId,
                    "%{public}@", event.message)
    }
    
    private func function(from event: BlackBox.GenericEvent) -> StaticString {
        switch event {
        case let endEvent as BlackBox.EndEvent:
            return endEvent.startEvent.source.function
        case _ as BlackBox.StartEvent,
            _ as BlackBox.ErrorEvent: // maybe should return .exclusive for errors and default cases
            return event.source.function
        default:
            return event.source.function
        }
    }
}

extension OSSignpostType {
    init(_ event: BlackBox.GenericEvent) {
        switch event {
        case _ as BlackBox.StartEvent:
            self = .begin
        case _ as BlackBox.EndEvent:
            self = .end
        case _ as BlackBox.ErrorEvent:
            self = .event
        default:
            self = .event
        }
    }
}

extension OSSignpostID {
    init(_ event: BlackBox.GenericEvent) {
        let id: UUID
        switch event {
        case let endEvent as BlackBox.EndEvent:
            id = endEvent.startEvent.id
        case _ as BlackBox.StartEvent,
            _ as BlackBox.ErrorEvent:
            id = event.id
        default:
            id = event.id
        }
        
        self = OSSignpostID(id)
    }
    
    init(_ uuid: UUID) {
        let value = UInt64(abs(uuid.hashValue)) // uniqueness not guaranteed, but chances are ridiculous
        self = OSSignpostID(value)
    }
}

extension OSLog {
    convenience init(signpostType: OSSignpostType,
                     event: BlackBox.GenericEvent) {
        switch signpostType {
        case .begin, .end:
            self.init(subsystem: event.source.module,
                      category: event.category ?? event.source.filename)
        case .event:
            self.init(subsystem: event.source.module,
                      category: .pointsOfInterest)
        default:
            self.init(subsystem: event.source.module,
                      category: .pointsOfInterest)
        }
    }
}
