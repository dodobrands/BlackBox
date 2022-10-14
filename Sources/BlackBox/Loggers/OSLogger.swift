import Foundation
import os

/// Redirects logs to Console.app
/// Usage example: https://habr.com/ru/company/dododev/blog/689758/
public class OSLogger: BBLoggerProtocol {
    let levels: [BBLogLevel]
    
    public init(
        levels: [BBLogLevel]
    ){
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
    
    func osLog(event: BlackBox.GenericEvent) {
        guard levels.contains(event.level) else { return }
        
        let data = LogData(from: event)
        
        osLog(data)
    }
    
    func osLog(_ data: LogData) {
        let log = OSLog(
            subsystem: data.subsystem,
            category: data.category
        )
        
        os_log(
            data.logType,
            log: log,
            "%{public}@", data.message
        )
    }
}

extension OSLogger {
    struct LogData {
        let logType: OSLogType
        let subsystem: String
        let category: String
        let message: String
        
        init(
            logType: OSLogType,
            subsystem: String,
            category: String,
            message: String
        ) {
            self.logType = logType
            self.subsystem = subsystem
            self.category = category
            self.message = message
        }
        
        init(from event: BlackBox.GenericEvent) {
            let subsystem = event.source.module
            let category = event.category ?? ""
            
            self.init(
                logType: OSLogType(event.level),
                subsystem: subsystem,
                category: category,
                message: Self.message(from: event)
            )
        }
        
        private static func message(from event: BlackBox.GenericEvent) -> String {
            let userInfo = event.userInfo?.bbLogDescription ?? "nil"
            
            let fileWithLine = [event.source.filename, String(event.source.line)].joined(separator: ":")
            
            let source = [
                fileWithLine,
                event.source.function.description
            ].joined(separator: "\n")
            
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
