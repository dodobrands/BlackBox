import Foundation
import os

@available(iOS 12.0, *)
extension BlackBox {
    public class OSLogger: BBLoggerProtocol {
        let logLevels: [BBLogLevel]
        
        public init(logLevels: [BBLogLevel]){
            self.logLevels = logLevels
        }
        
        public func log(
            _ error: BlackBox.Error
        ) {
            guard logLevels.contains(error.logLevel) else { return }
            
            let message = String(reflecting: error.error)
            
            log(message,
                userInfo: error.errorUserInfo,
                logger: OSLog(error),
                module: error.module,
                filename: error.filename,
                function: error.function,
                logType: OSLogType(error.logLevel))
        }
        
        public func log(
            _ event: BlackBox.Event
        ) {
            guard logLevels.contains(event.logLevel) else { return }
            
            log(event.message,
                userInfo: event.userInfo,
                logger: OSLog(event),
                module: event.module,
                filename: event.filename,
                function: event.function,
                logType: OSLogType(event.logLevel))
        }
        
        public func logStart(
            _ event: BlackBox.Event
        ) {
            guard logLevels.contains(event.logLevel) else { return }
            
            let formattedMessage = "\(BBEventType.start.description): \(event.message)"
            
            log(formattedMessage,
                userInfo: event.userInfo,
                logger: OSLog(event),
                module: event.module,
                filename: event.filename,
                function: event.function,
                logType: OSLogType(event.logLevel))
        }
        
        public func logEnd(
            startEvent: BlackBox.Event,
            endEvent: BlackBox.Event
        ) {
            guard logLevels.contains(endEvent.logLevel) else { return }
            
            let formattedMessage = "\(BBEventType.end.description): \(endEvent.message)"
            
            log(formattedMessage,
                userInfo: endEvent.userInfo,
                logger: OSLog(endEvent),
                module: endEvent.module,
                filename: endEvent.filename,
                function: endEvent.function,
                logType: OSLogType(endEvent.logLevel))
        }
    }
}

@available(iOS 12.0, *)
extension BlackBox.OSLogger {
    private func log(_ message: String,
                     userInfo: CustomDebugStringConvertible?,
                     logger: OSLog,
                     module: String,
                     filename: String,
                     function: StaticString,
                     logType: OSLogType) {
        let userInfo = userInfo?.bbLogDescription ?? "nil"
        let message = message
        + "\n\n"
        + "[Sender]:"
        + "\n"
        + [module, filename, function.description].joined(separator: ".")
        + "\n\n"
        + "[User Info]:"
        + "\n"
        + userInfo
        
        os_log(logType,
               log: logger,
               "%{public}@", message)
    }
}

@available(iOS 12.0, *)
extension OSLog {
    convenience init(_ event: BlackBox.Event) {
        self.init(
            subsystem: event.module,
            category:  event.category ?? ""
        )
    }
    
    convenience init(_ error: BlackBox.Error) {
        self.init(
            subsystem: error.module,
            category: error.category ?? ""
        )
    }
}

@available(iOS 12.0, *)
extension OSLogType {
    init(_ logLevel: BBLogLevel) {
        switch logLevel {
        case .debug:
            self = .default // .debug won't be shown in Console.app, so switching to .default instead
        case .default:
            self = .default
        case .info:
            self = .info
        case .warning:
            self = .error
        case .error:
            self = .fault
        }
    }
}
