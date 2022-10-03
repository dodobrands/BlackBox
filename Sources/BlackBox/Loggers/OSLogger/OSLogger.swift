import Foundation
import os

extension BlackBox {
    /// Redirects logs to Console.app
    /// Usage example: https://habr.com/ru/company/dododev/blog/689758/
    public class OSLogger: BBLoggerProtocol {
        let levels: [BBLogLevel]
        
        public init(levels: [BBLogLevel]){
            self.levels = levels
        }
        
        public func log(_ event: BlackBox.GenericEvent) {
            osLog(event: event)
        }
        
        public func log(_ event: BlackBox.ErrorEvent) {
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
        guard levels.contains(event.level) else { return }
        
        let message = message(from: event)
        
        let logType = OSLogType(event.level)
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
    init(_ level: BBLogLevel) {
        switch level {
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
