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
            _ error: Error,
            file: StaticString,
            category: String?,
            function: StaticString,
            line: UInt
        ) {
            guard logLevels.contains(error.logLevel) else { return }
            
            let message = String(reflecting: error)
            
            log(message,
                userInfo: nil,
                logLevel: error.logLevel,
                file: file,
                category: category,
                function: function,
                line: line)
        }
        
        public func log(
            _ message: String,
            userInfo: CustomDebugStringConvertible?,
            logLevel: BBLogLevel,
            file: StaticString,
            category: String?,
            function: StaticString,
            line: UInt
        ) {
            guard logLevels.contains(logLevel) else { return }
            
            let logger = self.logger(
                eventType: nil,
                file: file,
                category: category
            )
            
            log(message,
                logger: logger,
                function: function,
                signpostType: .event,
                signpostId: nil)
        }
        
        public func logStart(
            _ entry: BlackBox.LogEntry,
            userInfo: CustomDebugStringConvertible?,
            logLevel: BBLogLevel,
            file: StaticString,
            category: String?,
            function: StaticString,
            line: UInt
        ) {
            let eventType = BBEventType.start
            guard logLevels.contains(logLevel) else { return }
            
            let logger = self.logger(eventType: eventType,
                                     file: file,
                                     category: category)
            
            log(entry.message,
                logger: logger,
                function: function,
                signpostType: OSSignpostType(eventType),
                signpostId: OSSignpostID(entry.id))
        }
        
        public func logEnd(
            _ entry: BlackBox.LogEntry,
            userInfo: CustomDebugStringConvertible?,
            logLevel: BBLogLevel,
            file: StaticString,
            category: String?,
            function: StaticString,
            line: UInt
        ) {
            let eventType = BBEventType.end
            guard logLevels.contains(logLevel) else { return }
            
            let logger = self.logger(eventType: eventType,
                                     file: file,
                                     category: category)
            
            log(entry.message,
                logger: logger,
                function: function,
                signpostType: OSSignpostType(eventType),
                signpostId: OSSignpostID(entry.id))
        }
        
        private func logger(eventType: BBEventType?,
                            file: StaticString,
                            category: String?) -> OSLog {
            let filename = file.bbFilename
            
            switch eventType {
            case .start, .end:
                return OSLog(subsystem: filename,
                             category: category ?? filename)
            case .event, .none:
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
