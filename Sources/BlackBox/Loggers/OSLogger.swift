import Foundation
import os

/// Redirects logs to Console.app and to Xcode console
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
    
    private func osLog(event: BlackBox.GenericEvent) {
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
            func source(from event: BlackBox.GenericEvent) -> String {
                let fileWithLine = [event.source.filename, String(event.source.line)].joined(separator: ":")
                
                return [
                    "[Source]",
                    fileWithLine,
                    event.source.function.description
                ].joined(separator: "\n")
            }
            
            func userInfo(from event: BlackBox.GenericEvent) -> String? {
                guard let userInfo = event.userInfo else { return nil }
                
                return [
                    "[User Info]",
                    userInfo.bbLogDescription
                ].joined(separator: "\n")
            }
            
            // newline at the beginning increments readability in Xcode's console while not decrementing reading in Console.app
            let message = "\n" + event.formattedMessage
            
            return [
                message,
                source(from: event),
                userInfo(from: event)
            ]
                .compactMap { $0 }
                .joined(separator: "\n\n")
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

extension BlackBox.GenericEvent {
    var formattedMessage: String {
        switch self {
        case let endEvent as BlackBox.EndEvent:
            return "\(message), duration: \(endEvent.durationFormatted)"
        default:
            return message
        }
    }
}
