import Foundation
import os

/// Redirects logs to Time Profiler
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

    private func signpostLog(event: BlackBox.GenericEvent) {
        guard levels.contains(event.level) else { return }
        
        let data = LogData(from: event)
        
        signpostLog(data)
    }
    
    func signpostLog(_ data: LogData) {
        let log = OSLog(
            subsystem: data.subsystem,
            category: data.category
        )
        
        os_signpost(data.signpostType,
                    log: log,
                    name: data.name,
                    signpostID: data.signpostId,
                    "%{public}@", data.message)
    }
}

extension OSSignpostLogger {
    struct LogData {
        let signpostType: OSSignpostType
        let signpostId: OSSignpostID
        let subsystem: String
        let category: String
        let name: StaticString
        let message: String
        
        init(
            signpostType: OSSignpostType,
            signpostId: OSSignpostID,
            subsystem: String,
            category: String,
            name: StaticString,
            message: String
        ) {
            self.signpostType = signpostType
            self.signpostId = signpostId
            self.subsystem = subsystem
            self.category = category
            self.name = name
            self.message = message
        }
        
        init(from event: BlackBox.GenericEvent) {
            let subsystem = event.source.module
            let category = event.category ?? event.source.filename
            let name = Self.function(from: event)
            let signpostId = OSSignpostID(event)
            
            self.init(
                signpostType: OSSignpostType(event),
                signpostId: signpostId,
                subsystem: subsystem,
                category: category,
                name: name,
                message: event.message
            )
        }
        
        private static func function(from event: BlackBox.GenericEvent) -> StaticString {
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
