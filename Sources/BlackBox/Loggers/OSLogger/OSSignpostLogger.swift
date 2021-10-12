import Foundation
import os

@available(iOS 12.0, *)
extension BlackBox {
    public class OSSignpostLogger: BBLoggerProtocol {
        let logLevels: [BBLogLevel]
        
        public init(logLevels: [BBLogLevel]){
            self.logLevels = logLevels
        }
        
        public func log(
            _ error: BlackBox.Error
        ) {
            guard logLevels.contains(error.logLevel) else { return }
            
            let message = String(reflecting: error.error)
            
            let logger = self.logger(
                eventType: .event,
                file: error.file,
                category: error.category
            )
            
            log(message,
                logger: logger,
                function: error.function,
                signpostType: .event,
                signpostId: OSSignpostID(error.id))
        }
        
        public func log(
            _ entry: BlackBox.Event
        ) {
            guard logLevels.contains(entry.logLevel) else { return }
            
            let logger = self.logger(
                eventType: .event,
                file: entry.file,
                category: entry.category
            )
            
            log(entry.message,
                logger: logger,
                function: entry.function,
                signpostType: .event,
                signpostId: OSSignpostID(entry.id))
        }
        
        public func logStart(
            _ entry: BlackBox.Event
        ) {
            let eventType = BBEventType.start
            guard logLevels.contains(entry.logLevel) else { return }
            
            let logger = self.logger(eventType: eventType,
                                     file: entry.file,
                                     category: entry.category)
            
            let formattedMessage = "\(BBEventType.start.description): \(entry.message)"
            
            log(formattedMessage,
                logger: logger,
                function: entry.function,
                signpostType: OSSignpostType(eventType),
                signpostId: OSSignpostID(entry.id))
        }
        
        public func logEnd(
            startEntry: BlackBox.Event,
            endEntry: BlackBox.Event
        ) {
            let eventType = BBEventType.end
            guard logLevels.contains(endEntry.logLevel) else { return }
            
            let logger = self.logger(eventType: eventType,
                                     file: endEntry.file,
                                     category: endEntry.category)
            
            let formattedMessage = "\(BBEventType.end.description): \(endEntry.message)"
            
            log(formattedMessage,
                logger: logger,
                function: startEntry.function,
                signpostType: OSSignpostType(eventType),
                signpostId: OSSignpostID(startEntry.id))
        }
        
        private func logger(eventType: BBEventType,
                            file: StaticString,
                            category: String?) -> OSLog {
            let filename = file.bbFilename
            
            switch eventType {
            case .start, .end:
                return OSLog(subsystem: filename,
                             category: category ?? filename)
            case .event:
                return OSLog(subsystem: filename,
                             category: .pointsOfInterest)
            }
        }
    }
}

@available(iOS 12.0, *)
extension BlackBox.OSSignpostLogger {
    private func log(_ message: String,
                     logger: OSLog,
                     function: StaticString,
                     signpostType: OSSignpostType,
                     signpostId: OSSignpostID?) {
        let name: StaticString = function
        
        os_signpost(signpostType,
                    log: logger,
                    name: name,
                    signpostID: signpostId ?? .exclusive,
                    "%{public}@", message)
    }
}

@available(iOS 12.0, *)
extension OSSignpostType {
    init(_ eventType: BBEventType) {
        switch eventType {
        case .start:
            self = .begin
        case .end:
            self = .end
        case .event:
            self = .event
        }
    }
}
