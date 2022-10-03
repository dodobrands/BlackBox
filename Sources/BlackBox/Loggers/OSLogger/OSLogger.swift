import Foundation
import os

extension BlackBox {
    public class OSLogger: BBLoggerProtocol {
        let logLevels: [BBLogLevel]
        
        public init(logLevels: [BBLogLevel]){
            self.logLevels = logLevels
        }
        
        public func log(_ event: BlackBox.ErrorEvent) {
            osLog(event: event)
        }
        
        public func log(_ event: BlackBox.GenericEvent) {
            osLog(event: event)
        }
        
        public func logStart(_ event: BlackBox.StartEvent) {
            osLog(event: event)
        }
        
        public func logEnd(_ event: BlackBox.EndEvent) {
            osLog(event: event)
        }
    }
}

extension BlackBox.OSLogger {
    private func osLog(event: BlackBox.GenericEvent) {
        guard logLevels.contains(event.logLevel) else { return }
        
        let message = message(from: event)
        
        let logType = OSLogType(event.logLevel)
        let logger = OSLog(event)
        
        os_log(logType,
               log: logger,
               "%{public}@", message)
    }
    
    private func message(from event: BlackBox.GenericEvent) -> String {
        let userInfo = event.userInfo?.bbLogDescription ?? "nil"
        
        let source = [event.source.module,
                      event.source.filename,
                      event.source.function.description].joined(separator: ".")
        
        let message = event.message
        + "\n\n"
        + "[Sender]:"
        + "\n"
        + source
        + "\n\n"
        + "[User Info]:"
        + "\n"
        + userInfo
        
        return message
    }
}

extension OSLog {
    convenience init(_ event: BlackBox.GenericEvent) {
        self.init(
            subsystem: event.source.module,
            category:  event.category ?? ""
        )
    }
}

extension OSLogType {
    init(_ logLevel: BBLogLevel) {
        switch logLevel {
        case .debug:
            self = .default // .debug won't be shown in Console.app, so switching to .default instead
        case .info:
            self = .info
        case .warning:
            self = .error
        case .error:
            self = .fault
        }
    }
}
