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
                logger: OSLog(file: error.file, category: error.category),
                file: error.file,
                function: error.function,
                logType: OSLogType(error.logLevel))
        }
        
        public func log(
            _ entry: BlackBox.Event
        ) {
            guard logLevels.contains(entry.logLevel) else { return }
            
            log(entry.message,
                userInfo: entry.userInfo,
                logger: OSLog(file: entry.file, category: entry.category),
                file: entry.file,
                function: entry.function,
                logType: OSLogType(entry.logLevel))
        }
        
        public func logStart(
            _ entry: BlackBox.Event
        ) {
            guard logLevels.contains(entry.logLevel) else { return }
            
            let formattedMessage = "\(BBEventType.start.description): \(entry.message)"
            
            log(formattedMessage,
                userInfo: entry.userInfo,
                logger: OSLog(file: entry.file, category: entry.category),
                file: entry.file,
                function: entry.function,
                logType: OSLogType(entry.logLevel))
        }
        
        public func logEnd(
            startEntry: BlackBox.Event,
            endEntry: BlackBox.Event
        ) {
            guard logLevels.contains(endEntry.logLevel) else { return }
            
            let formattedMessage = "\(BBEventType.end.description): \(endEntry.message)"
            
            log(formattedMessage,
                userInfo: endEntry.userInfo,
                logger: OSLog(file: endEntry.file, category: endEntry.category),
                file: endEntry.file,
                function: endEntry.function,
                logType: OSLogType(endEntry.logLevel))
        }
    }
}

@available(iOS 12.0, *)
extension BlackBox.OSLogger {
    private func log(_ message: String,
                     userInfo: CustomDebugStringConvertible?,
                     logger: OSLog,
                     file: StaticString,
                     function: StaticString,
                     logType: OSLogType) {
        let userInfo = userInfo?.bbLogDescription ?? "nil"
        let message = message + "\n" + function.description + "\n\n" + "[User Info]:" + "\n" + userInfo
        
        os_log(logType,
               log: logger,
               "%{public}@", message)
    }
}

@available(iOS 12.0, *)
extension OSLog {
    convenience init(file: StaticString, category: String?) {
        self.init(subsystem: file.bbFilename, category: category ?? "")
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
