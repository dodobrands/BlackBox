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
            _ event: BlackBox.Event
        ) {
            guard logLevels.contains(event.logLevel) else { return }
            
            let logger = self.logger(
                eventType: .event,
                file: event.file,
                category: event.category
            )
            
            log(event.message,
                logger: logger,
                function: event.function,
                signpostType: .event,
                signpostId: OSSignpostID(event.id))
        }
        
        public func logStart(
            _ event: BlackBox.Event
        ) {
            let eventType = BBEventType.start
            guard logLevels.contains(event.logLevel) else { return }
            
            let logger = self.logger(eventType: eventType,
                                     file: event.file,
                                     category: event.category)
            
            let formattedMessage = "\(BBEventType.start.description): \(event.message)"
            
            log(formattedMessage,
                logger: logger,
                function: event.function,
                signpostType: OSSignpostType(eventType),
                signpostId: OSSignpostID(event.id))
        }
        
        public func logEnd(
            startEvent: BlackBox.Event,
            endEvent: BlackBox.Event
        ) {
            let eventType = BBEventType.end
            guard logLevels.contains(endEvent.logLevel) else { return }
            
            let logger = self.logger(eventType: eventType,
                                     file: endEvent.file,
                                     category: endEvent.category)
            
            let formattedMessage = "\(BBEventType.end.description): \(endEvent.message)"
            
            log(formattedMessage,
                logger: logger,
                function: startEvent.function,
                signpostType: OSSignpostType(eventType),
                signpostId: OSSignpostID(startEvent.id))
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
