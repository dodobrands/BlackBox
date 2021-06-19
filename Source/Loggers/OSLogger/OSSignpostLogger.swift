import Foundation
import os

@available(iOS 12.0, *)
extension BlackBox {
    public class OSSignpostLogger: BBLoggerProtocol {
        let logLevels: [BBLogLevel]
        
        public init(logLevels: [BBLogLevel]){
            self.logLevels = logLevels
        }
        
        public func log(_ error: Error,
                        eventType: BBEventType,
                        eventId: UInt64?,
                        file: StaticString,
                        category: String?,
                        function: StaticString,
                        line: UInt) {
            guard logLevels.contains(.error) else { return }
            
            let message = String(reflecting: error)
            
            log(message,
                userInfo: nil,
                logLevel: error.logLevel,
                eventType: eventType,
                eventId: eventId,
                file: file,
                category: category,
                function: function,
                line: line)
        }
        
        public func log(_ message: String,
                        userInfo: CustomDebugStringConvertible?,
                        logLevel: BBLogLevel,
                        eventType: BBEventType,
                        eventId: UInt64?,
                        file: StaticString,
                        category: String?,
                        function: StaticString,
                        line: UInt) {
            guard logLevels.contains(logLevel) else { return }
            
            let logger = self.logger(eventType: eventType,
                                     file: file,
                                     category: category)
            
            let signpostId = eventId.map { OSSignpostID($0) }
            
            log(message,
                logger: logger,
                function: function,
                signpostType: OSSignpostType(eventType),
                signpostId: signpostId)
        }
        
        private func logger(eventType: BBEventType?,
                            file: StaticString,
                            category: String?) -> OSLog {
            let filename = file.bbFilename
            
            switch eventType {
            case .begin, .end, .none:
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
        case .begin:
            self = .begin
        case .end:
            self = .end
        case .event:
            self = .event
        }
    }
}
